import Architecture
import LinkNavigator

struct LikeRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Like.Path.like.rawValue

    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: LikeEnvironmentUsable = diContainer.resolve() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        LikePage(store: .init(
          initialState: LikeReducer.State(),
          reducer: {
            LikeReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
