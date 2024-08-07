import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .preview(
  projectName: "Authentication",
  packages: [
    .local(path: .relativeToRoot("Modules/Core/Architecture")),
    .local(path: .relativeToRoot("Modules/Core/DesignSystem")),
    .local(path: .relativeToRoot("Modules/Core/Domain")),
    .local(path: .relativeToRoot("Modules/Core/Platform")),
    .local(path: .relativeToRoot("Modules/Core/Functor")),
    .local(path: .relativeToRoot("Modules/Feature/Authentication")),
  ],
  dependencies: [
    .package(product: "Authentication", type: .runtime),
  ])
