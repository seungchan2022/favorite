import SwiftUI

// MARK: - TabNavigationComponent

public struct TabNavigationComponent {
  let viewState: ViewState
  let tapAction: (String) -> Void

  public init(viewState: ViewState, tapAction: @escaping (String) -> Void) {
    self.viewState = viewState
    self.tapAction = tapAction
  }
}

// MARK: View

extension TabNavigationComponent: View {
  public var body: some View {
    HStack {
      ForEach(viewState.itemList) { item in
        Button(action: { tapAction(item.matchPath) }) {
          VStack {
            item.icon
              .resizable()
              .scaledToFill()
              .frame(width: 32, height: 32)
              .foregroundStyle(Color.defaultButtonColor(item.isActive))

            Text(item.matchPath)
              .font(.footnote)
              .foregroundStyle(Color.defaultButtonColor(item.isActive))
          }
        }
        if viewState.itemList.last != item {
          Spacer()
        }
      }
    }
    .padding(.horizontal, 32)
    .padding(.top, 8)
    .padding(.bottom, WindowAppearance.safeArea.bottom)
    .background {
      Rectangle()
        .fill(.white)
    }
    .overlay(alignment: .top) {
      Divider()
    }
  }
}

// MARK: TabNavigationComponent.ViewState

extension TabNavigationComponent {
  public struct ViewState: Equatable {

    // MARK: Lifecycle

    public init(activeMatchPath: String) {
      self.activeMatchPath = activeMatchPath
      itemList = [
        .init(
          matchPath: "repo",
          activeMatchPath: activeMatchPath,
          icon: Image(systemName: "shippingbox.fill")),
        .init(
          matchPath: "user",
          activeMatchPath: activeMatchPath,
          icon: Image(systemName: "person.3.fill")),
        .init(
          matchPath: "like",
          activeMatchPath: activeMatchPath,
          icon: Image(systemName: "heart.rectangle")),
        .init(
          matchPath: "me",
          activeMatchPath: activeMatchPath,
          icon: Image(systemName: "person.fill")),
      ]
    }

    // MARK: Internal

    let activeMatchPath: String

    // MARK: Fileprivate

    fileprivate let itemList: [ItemComponent]
  }
}

// MARK: - ItemComponent

private struct ItemComponent: Equatable, Identifiable {
  let matchPath: String // 각 tab의 matchPath
  let activeMatchPath: String // 그 tab이 활성화된 탭을 식별 하기 위해
  let icon: Image

  var isActive: Bool {
    matchPath == activeMatchPath
  }

  var id: String { matchPath }
}

extension Color {
  fileprivate static var defaultButtonColor: (Bool) -> Color {
    { isActive in
      var color: Color {
        isActive == true
        ? DesignSystemColor.label(.default).color
          : DesignSystemColor.palette(.gray(.lv200)).color
      }
      return color
    }
  }
}

//
// #Preview {
//  VStack {
//    Spacer()
//    TabNavigationComponent(
//      viewState: .init(activeMatchPath: "audioMemo"),
//      tapAction: { _ in })
//  }
//  //  .background(.red)
// }
