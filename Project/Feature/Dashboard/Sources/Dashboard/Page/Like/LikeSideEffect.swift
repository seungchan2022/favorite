import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - LikeSideEffect

struct LikeSideEffect {
  let useCase: DashboardEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  init(
    useCase: DashboardEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension LikeSideEffect {
  var getItemList: () -> Effect<LikeReducer.Action> {
    {
      .publisher {
        useCase.githubLikeUseCase.getItemList()
          .receive(on: main)
          .mapToResult()
          .map(LikeReducer.Action.fetchItemList)
      }
    }
  }

  var routeToRepoDetail: (GithubEntity.Detail.Repository.Response) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.repoDetail.rawValue,
          items: item.serialized()),
        isAnimated: true)
    }
  }

  var routeToUserDetail: (GithubEntity.Detail.User.Response) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.userDetail.rawValue,
          items: item.serialized()),
        isAnimated: true)
    }
  }
}

extension GithubEntity.Detail.Repository.Response {
  fileprivate func serialized() -> GithubEntity.Detail.Repository.Request {
    .init(ownerName: owner.login, repositoryname: name)
  }
}

extension GithubEntity.Detail.User.Response {
  fileprivate func serialized() -> GithubEntity.Detail.User.Request {
    .init(ownerName: loginName)
  }
}
