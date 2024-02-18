import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - RepoSideEffect

struct RepoSideEffect {
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

extension RepoSideEffect {
  var searchRepository: (GithubEntity.Search.Repository.Request) -> Effect<RepoStore.Action> {
    { item in
      .publisher {
        useCase.githubSearchUsecase.searchRepository(item)
          .receive(on: main)
          .map {
            GithubEntity.Search.Repository.Composite(
              request: item,
              response: $0)
          }
          .mapToResult()
          .map(RepoStore.Action.fetchSearchItem)
      }
    }
  }
}
