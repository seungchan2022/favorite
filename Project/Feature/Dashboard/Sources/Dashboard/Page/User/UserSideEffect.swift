import Architecture
import ComposableArchitecture
import Foundation
import Domain
import CombineExt

struct UserSideEffect {
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

extension UserSideEffect {
  var searchUser: (GithubEntity.Search.User.Request) -> Effect<UserStore.Action> {
    { item in
        .publisher {
          useCase.githubSearchUsecase.searchUser(item)
            .receive(on: main)
            .map {
              GithubEntity.Search.User.Composite(
                request: item,
                response: $0)
            }
            .mapToResult()
            .map(UserStore.Action.fetchSearchItem)
        }
    }
  }
}