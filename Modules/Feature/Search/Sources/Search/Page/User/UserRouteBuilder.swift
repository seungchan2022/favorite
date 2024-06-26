import Architecture
import LinkNavigator

struct UserRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Search.Path.user.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: SearchEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        UserPage(store: .init(
          initialState: UserReducer.State(),
          reducer: {
            UserReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
