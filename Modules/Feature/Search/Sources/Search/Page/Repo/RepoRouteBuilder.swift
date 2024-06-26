import Architecture
import LinkNavigator

struct RepoRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Search.Path.repo.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: SearchEnvironmentUsable = diContainer.resolve() else { return .none }
      return DebugWrappingController(matchPath: matchPath) {
        RepoPage(store: .init(
          initialState: RepoReducer.State(),
          reducer: {
            RepoReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
