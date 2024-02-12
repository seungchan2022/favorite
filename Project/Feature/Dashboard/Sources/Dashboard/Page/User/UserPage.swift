import SwiftUI
import Architecture
import ComposableArchitecture

struct UserPage {
  @Bindable var store: StoreOf<UserStore>
}

extension UserPage: View {
  var body: some View {
    Text("UserPage")
  }
}
