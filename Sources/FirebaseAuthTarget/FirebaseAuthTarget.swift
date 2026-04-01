@_exported import FirebaseAuth
import FirebaseCore

// Force linker to include FirebaseAuth symbols
@available(*, unavailable)
private enum _ForceLink {
    static let auth: Auth.Type = Auth.self
    static let user: User.Type = User.self
    static let app: FirebaseApp.Type = FirebaseApp.self
}
