import Architecture
import LinkNavigator

struct LikeRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Dashboard.Path.like.rawValue
    
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      guard let env: DashboardEnvironmentUsable = diContainer.resolve() else { return .none }
      
      return DebugWrappingController(matchPath: matchPath) {
        LikePage(store: .init(
          initialState: LikeStore.State(),
          reducer: {
            LikeStore.init(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
