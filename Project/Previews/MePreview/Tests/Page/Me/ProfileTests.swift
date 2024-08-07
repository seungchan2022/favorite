import ComposableArchitecture
import Domain
import Foundation
import Platform
import Search
import XCTest

// MARK: - ProfileTests

final class ProfileTests: XCTestCase {
  override class func tearDown() {
    super.tearDown()
  }

  @MainActor
  func test_teardown() async {
    let sut = SUT()

    await sut.store.send(.teardown)
  }

  @MainActor
  func test_binding() async {
    let sut = SUT()

    await sut.store.send(.set(\.fetchIsMe, .init(isLoading: false, value: false)))
  }

  @MainActor
  func test_getItem_success_case() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    await sut.store.send(.getItem) { state in
      state.fetchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItem) { state in
      state.fetchItem.isLoading = false
      state.fetchItem.value = responseMock
    }
  }

  @MainActor
  func test_getItem_failure_case() async {
    let sut = SUT()

    sut.container.githubDetailUseCaseStub.type = .failure(.invalidTypeCasting)

    await sut.store.send(.getItem) { state in
      state.fetchItem.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchItem) { state in
      state.fetchItem.isLoading = false
    }

    await sut.store.receive(\.throwError)
  }

  @MainActor
  func test_getIsMe_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요가 아닌 상태 => UnMe 상태
    sut.container.githubMeUseCaseFake.reset()

    await sut.store.send(.getIsMe(responseMock)) { state in
      state.fetchIsMe.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsMe) { state in
      state.fetchIsMe.isLoading = false
      state.fetchIsMe.value = false
    }
  }

  @MainActor
  func test_getIsMe_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요인 상태 => Me 상태
    sut.container.githubMeUseCaseFake.reset(
      store: .init(userList: [responseMock]))

    await sut.store.send(.getIsMe(responseMock)) { state in
      state.fetchIsMe.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsMe) { state in
      state.fetchIsMe.isLoading = false
      state.fetchIsMe.value = true
    }
  }

  @MainActor
  func test_updateIsMe_success_case1() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요가 아닌 상태 => UnMe 상태
    sut.container.githubMeUseCaseFake.reset()

    await sut.store.send(.updateIsMe(responseMock)) { state in
      state.fetchIsMe.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsMe) { state in
      state.fetchIsMe.isLoading = false
      /// - Note: 아이템이 좋아요가 아닌 상태였는데,
      /// updateIsMe를 수행했으므로 좋아요인 상태로 변경 ( UnMe => Me)
      state.fetchIsMe.value = true
    }
  }

  @MainActor
  func test_updateIsMe_success_case2() async {
    let sut = SUT()

    let responseMock: GithubEntity.Detail.User.Response = ResponseMock().detailResponse.user.successValue

    /// - Note: 해당 아이템이 좋아요 상태 => Me 상태
    sut.container.githubMeUseCaseFake.reset(
      store: .init(userList: [responseMock]))

    await sut.store.send(.updateIsMe(responseMock)) { state in
      state.fetchIsMe.isLoading = true
    }

    await sut.scheduler.advance()

    await sut.store.receive(\.fetchIsMe) { state in
      state.fetchIsMe.isLoading = false
      /// - Note: 아이템이 좋아요 상태였는데,
      /// updateIsMe를 수행했으므로 좋아요가 아닌 상태로 변경 (Me => UnMe)
      state.fetchIsMe.value = false
    }
  }

  @MainActor
  func test_fetchIsMe_failure_case() async {
    let sut = SUT()

    await sut.store.send(.fetchIsMe(.failure(.invalidTypeCasting)))

    await sut.scheduler.advance()

    await sut.store.receive(\.throwError)

    XCTAssertEqual(sut.container.toastViewActionMock.event.sendErrorMessage, 1)
  }

}

extension ProfileTests {
  struct SUT {

    // MARK: Lifecycle

    init(state: ProfileReducer.State = .init(item: .init(ownerName: "interactord"))) {
      let container = AppContainerMock.generate()
      let main = DispatchQueue.test

      self.container = container
      scheduler = main

      store = .init(
        initialState: state,
        reducer: {
          ProfileReducer(
            sideEffect: .init(
              useCase: container,
              main: main.eraseToAnyScheduler(),
              navigator: container.linkNavigator))
        })
    }

    // MARK: Internal

    let container: AppContainerMock
    let scheduler: TestSchedulerOf<DispatchQueue>
    let store: TestStore<ProfileReducer.State, ProfileReducer.Action>
  }

  struct ResponseMock {
    let detailResponse: GithubDetailUseCaseStub.Response = .init()
    init() { }
  }
}
