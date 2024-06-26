import Architecture
import Domain
import LinkNavigator

struct UserDetailRouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.Common.Path.userDetail.rawValue

    return .init(matchPath: matchPath) { navigator, items, diConatiner -> RouteViewController? in

      guard let env: CommonEnvironmentUsable = diConatiner.resolve() else { return .none }
      guard let query: GithubEntity.Detail.User.Request = items.decoded() else { return .none }

      return DebugWrappingController(matchPath: matchPath) {
        UserDetailPage(store: .init(
          initialState: UserDetailReducer.State(item: query),
          reducer: {
            UserDetailReducer(sideEffect: .init(
              useCase: env,
              navigator: navigator))
          }))
      }
    }
  }
}
