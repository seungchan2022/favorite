import Foundation

// MARK: - Link.Dashboard

extension Link {
  public enum Dashboard { }
}

// MARK: - Link.Dashboard.Path

extension Link.Dashboard {
  public enum Path: String, Equatable {
    case repo
    case repoDetail
    case user
    case userDetail
    case profile
    case follower
    case like
    case topic
    case topicDetail
  }
}
