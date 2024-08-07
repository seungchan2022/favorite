// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Files

// swiftlint:disable superfluous_disable_command file_length line_length implicit_return

// swiftlint:disable explicit_type_interface identifier_name
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum Files {
  /// detail_repositories_failure.json
  static let detailRepositoriesFailureJson = File(
    name: "detail_repositories_failure",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// detail_repositories_success.json
  static let detailRepositoriesSuccessJson = File(
    name: "detail_repositories_success",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// detail_users_failure.json
  static let detailUsersFailureJson = File(
    name: "detail_users_failure",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// detail_users_success.json
  static let detailUsersSuccessJson = File(
    name: "detail_users_success",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// dummy.json
  static let dummyJson = File(name: "dummy", ext: "json", relativePath: "", mimeType: "application/json")
  /// search_repositories_failure.json
  static let searchRepositoriesFailureJson = File(
    name: "search_repositories_failure",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// search_repositories_success.json
  static let searchRepositoriesSuccessJson = File(
    name: "search_repositories_success",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// search_users_failure.json
  static let searchUsersFailureJson = File(
    name: "search_users_failure",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// search_users_success.json
  static let searchUsersSuccessJson = File(
    name: "search_users_success",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// user_followers_failure.json
  static let userFollowersFailureJson = File(
    name: "user_followers_failure",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
  /// user_followers_success.json
  static let userFollowersSuccessJson = File(
    name: "user_followers_success",
    ext: "json",
    relativePath: "",
    mimeType: "application/json")
}

// MARK: - File

// swiftlint:enable explicit_type_interface identifier_name
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

struct File {
  let name: String
  let ext: String?
  let relativePath: String
  let mimeType: String

  var url: URL {
    url(locale: nil)
  }

  var path: String {
    path(locale: nil)
  }

  func url(locale: Locale?) -> URL {
    let bundle = BundleToken.bundle
    let url = bundle.url(
      forResource: name,
      withExtension: ext,
      subdirectory: relativePath,
      localization: locale?.identifier)
    guard let result = url else {
      let file = name + (ext.flatMap { ".\($0)" } ?? "")
      fatalError("Could not locate file named \(file)")
    }
    return result
  }

  func path(locale: Locale?) -> String {
    url(locale: locale).path
  }
}

// MARK: - BundleToken

// swiftlint:disable convenience_type explicit_type_interface
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

// swiftlint:enable convenience_type explicit_type_interface
