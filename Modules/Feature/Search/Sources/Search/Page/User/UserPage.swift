import Architecture
import ComposableArchitecture
import DesignSystem
import Functor
import SwiftUI

// MARK: - UserPage

struct UserPage {
  @Bindable var store: StoreOf<UserReducer>
  @State private var throttleEvent: ThrottleEvent = .init(value: "", delaySeconds: 1.5)
}

extension UserPage {
  private var searchViewState: SearchBar.ViewState {
    .init(text: $store.query)
  }

  private var gridColumnList: [GridItem] {
    Array(
      repeating: .init(.flexible()),
      count: UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3)
  }

  private var isLoading: Bool {
    store.fetchSearchItem.isLoading
  }

  private var emptyQueryMessage: String {
    "검색을 통해 원하는 정보를 찾아보세요"
  }

  private var navigationTitle: String {
    "User"
  }

  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.Search.Path.user.rawValue)
  }
}

// MARK: View

extension UserPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(title: ""),
        largeTitle: navigationTitle)
      {
        SearchBar(viewState: .init(text: $store.query), throttleAction: { })

        if store.query.isEmpty {
          Text(emptyQueryMessage)
            .font(.title3)
            .padding()
        }

        LazyVGrid(columns: gridColumnList, spacing: .zero) {
          ForEach(store.itemList, id: \.id) { item in
            UserItemComponent(
              viewState: .init(item: item),
              action: { store.send(.routeToDetail($0)) })
              .onAppear {
                guard let last = store.itemList.last, last.id == item.id else { return }
                guard !store.fetchSearchItem.isLoading else { return }
                store.send(.search(store.query))
              }
          }
        }
      }

      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { store.send(.routeToTabBarItem($0)) })
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .scrollDismissesKeyboard(.immediately)
    .toolbar(.hidden, for: .navigationBar)
    .onChange(of: store.query) { _, new in
      throttleEvent.update(value: new)
    }
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      throttleEvent.apply { _ in
        store.send(.search(store.query))
      }
    }
    .onDisappear {
      throttleEvent.reset()
      store.send(.teardown)
    }
  }
}
