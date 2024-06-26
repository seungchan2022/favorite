import Architecture
import LinkNavigator

// MARK: - LikeRouteBuilderGroup

public struct LikeRouteBuilderGroup<RootNavigator: RootNavigatorType> {
  public init() { }
}

extension LikeRouteBuilderGroup {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      LikeRouteBuilder.generate(),
    ]
  }

  public static var template: [RouteBuilderOf<RootNavigator>] {
    [
    ]
  }
}
