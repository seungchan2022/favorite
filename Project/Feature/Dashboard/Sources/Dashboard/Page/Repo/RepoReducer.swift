import Architecture
import ComposableArchitecture
import Dispatch
import Domain
import Foundation

// MARK: - RepoReducer

@Reducer
struct RepoReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: RepoSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    let perPage = 40
    var query = "swift"
    var itemList: [GithubEntity.Search.Repository.Item] = []
    var fetchSearchItem: FetchState.Data<GithubEntity.Search.Repository.Composite?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case search(String)
    case fetchSearchItem(Result<GithubEntity.Search.Repository.Composite, CompositeErrorRepository>)

    case routeToDetail(GithubEntity.Search.Repository.Item)

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

        let page = Int(state.itemList.count / state.perPage) + 1
        state.fetchSearchItem.isLoading = true
        return sideEffect.searchRepository(.init(query: query, page: page, perPage: state.perPage))
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
            sideEffect.useCase.toastViewModel.send(message: "검색결과가 없습니다.")
          }
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToDetail(let item):
        sideEffect.routeToDeatil(item)
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        Logger.error(Logger.Message(stringLiteral: error.displayMessage))
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: RepoSideEffect
}

extension [GithubEntity.Search.Repository.Item] {
  // 중복된게 올라옴
  fileprivate func merge(_ target: Self) -> Self {
    let new = target.reduce(self) { curr, next in
      guard !self.contains(where: { $0.id == next.id }) else { return curr }
      return curr + [next]
    }

    return new
  }
}
