@_exported import Apollo

// Force linker to include Apollo symbols
@available(*, unavailable)
private enum _ForceLink {
    static let client: ApolloClient.Type = ApolloClient.self
    static let store: ApolloStore.Type = ApolloStore.self
}
