import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

// MARK: - UserReducer

@Reducer
struct UserReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UserSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var query = "s"
    var itemList: [GithubEntity.Search.User.Item] = []
    var fetchSearchItem: FetchState.Data<GithubEntity.Search.User.Composite?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case search(String)
    case fetchSearchItem(Result<GithubEntity.Search.User.Composite, CompositeErrorRepository>)

    case routeToDetail(GithubEntity.Search.User.Item)

    case throwError(CompositeErrorRepository)
    case teardown
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSearch
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .search(let query):
        guard !query.isEmpty else {
          state.itemList = []
          return .none
        }

        if state.query != state.fetchSearchItem.value?.request.query { state.itemList = [] }
        if let totalCount = state.fetchSearchItem.value?.response.totalCount, totalCount < state.itemList.count {
          return .none
        }

        let page = Int(state.itemList.count / 30) + 1
        state.fetchSearchItem.isLoading = true
        return sideEffect.searchUser(.init(query: query, page: page))
          .cancellable(pageID: pageID, id: CancelID.requestSearch, cancelInFlight: true)

      case .fetchSearchItem(let result):
        state.fetchSearchItem.isLoading = false
        guard !state.query.isEmpty else {
          state.itemList = []
          return .none
        }

        switch result {
        case .success(let item):
          state.fetchSearchItem.value = item
          state.itemList = state.itemList.merge(item.response.itemList)
          if state.itemList.isEmpty {
            sideEffect.useCase.toastViewModel.send(message: "검색 결과가 없습니다.")
          }
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToDetail(let item):
        sideEffect.routeToDetail(item)
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        Logger.error(.init(stringLiteral: error.displayMessage))
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UserSideEffect
}

extension [GithubEntity.Search.User.Item] {
  fileprivate func merge(_ targer: Self) -> Self {
    let new = targer.reduce(self) { curr, next in
      guard !self.contains(where: { $0.id == next.id }) else { return curr }
      return curr + [next]
    }

    return new
  }
}
