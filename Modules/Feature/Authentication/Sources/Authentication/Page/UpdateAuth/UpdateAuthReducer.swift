import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct UpdateAuthReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdateAuthSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    
    var item: Auth.Me.Response = .init(uid: "", userName: "", email: "", photoURL: "")
    
    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)
    var fetchSignOut: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    
    var fetchUpdateUserName: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    
    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUserInfo
    
    case onTapSignOut
    
    case onTapUpdateUserName
    
    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)
    case fetchSignOut(Result<Bool, CompositeErrorRepository>)
    
    case fetchUpdateUserName(Result<Bool, CompositeErrorRepository>)
    
    case routeToBack
    
    case throwError(CompositeErrorRepository)
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUserInfo
    case requestSignOut
    case requestUpdateUserName
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
        
      case .getUserInfo:
        state.fetchUserInfo.isLoading = true
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)
        
      case .onTapSignOut:
        state.fetchSignOut.isLoading = true
        return sideEffect
          .signOut()
          .cancellable(pageID: pageID, id: CancelID.requestSignOut, cancelInFlight: true)
        
      case .onTapUpdateUserName:
        state.fetchUpdateUserName.isLoading = true
        return sideEffect
          .updateUserName("test")
          .cancellable(pageID: pageID, id: CancelID.requestUpdateUserName, cancelInFlight: true)
        
      case .fetchUserInfo(let result):
        state.fetchUserInfo.isLoading = false
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", userName: "", email: "", photoURL: "")
          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }
        
      case .fetchSignOut(let result):
        state.fetchSignOut.isLoading = false
        switch result {
        case .success:
          sideEffect.routeToSignIn()
          return .none
          
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }
        
      case .fetchUpdateUserName(let result):
        state.fetchUpdateUserName.isLoading = false
        switch result {
        case .success:
//          return .send(.getUserInfo)
          return .run { await $0(.getUserInfo) }
          
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }
        
      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UpdateAuthSideEffect
}
