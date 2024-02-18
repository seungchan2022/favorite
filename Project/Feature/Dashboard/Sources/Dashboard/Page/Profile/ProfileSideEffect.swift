import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - ProfileSideEffect

struct ProfileSideEffect {
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

extension ProfileSideEffect {
  var userProfile: (String) -> Effect<ProfileStore.Action> {
    { item in
      .publisher {
        useCase.githubSearchUsecase.userProfile(item)
          .receive(on: main)
          .mapToResult()
          .map(ProfileStore.Action.fetchProfileItem)
      }
    }
  }
}