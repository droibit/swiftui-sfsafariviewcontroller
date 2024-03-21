import SafariServices
import SwiftUI

public struct SafariView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = SFSafariViewController
    public typealias Configuration = SFSafariViewController.Configuration
    public typealias DismissButtonStyle = SFSafariViewController.DismissButtonStyle

    private let url: URL
    private let appearance: Appearance?
    private let configuration: Configuration?

    public init(
        url: URL,
        appearance: Appearance? = nil,
        configuration: Configuration? = nil
    ) {
        self.url = url
        self.appearance = appearance
        self.configuration = configuration
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> SFSafariViewController {
        let vc: SFSafariViewController = if let configuration {
            .init(url: url, configuration: configuration)
        } else {
            .init(url: url)
        }

        if let preferredBarTintColor = appearance?.preferredBarTintColor {
            vc.preferredBarTintColor = preferredBarTintColor
        }
        if let preferredControlTintColor = appearance?.preferredControlTintColor {
            vc.preferredControlTintColor = preferredControlTintColor
        }
        if let dismissButtonStyle = appearance?.dismissButtonStyle {
            vc.dismissButtonStyle = dismissButtonStyle
        }
        return vc
    }

    public func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<Self>
    ) {}
}

public extension SafariView {
    struct Appearance {
        public let preferredBarTintColor: UIColor?
        public let preferredControlTintColor: UIColor?
        public let dismissButtonStyle: DismissButtonStyle?

        public init(
            preferredBarTintColor: UIColor? = nil,
            preferredControlTintColor: UIColor? = nil,
            dismissButtonStyle: DismissButtonStyle? = nil
        ) {
            self.preferredBarTintColor = preferredBarTintColor
            self.preferredControlTintColor = preferredControlTintColor
            self.dismissButtonStyle = dismissButtonStyle
        }
    }
}

// MARK: - Modifier

public struct OpenURLInSafariViewModifier: ViewModifier {
    @State private var fullScreenOpenURL: OpenURLItem?
    @State private var modalOpenURL: OpenURLItem?
    @EnvironmentObject private var sceneDelegate: SceneDelegate

    private let appearance: SafariView.Appearance?
    private let configuration: SafariView.Configuration?
    private let presentationStyle: PresentationStyle

    init(
        appearance: SafariView.Appearance? = nil,
        configuration: SafariView.Configuration? = nil,
        presentationStyle: PresentationStyle = .fullScreen
    ) {
        self.appearance = appearance
        self.presentationStyle = presentationStyle
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction(handler: handleURL))
            .fullScreenCover(item: $fullScreenOpenURL) { item in
                SafariView(url: item.url, appearance: appearance, configuration: configuration)
                    .ignoresSafeArea()
            }
            .sheet(item: $modalOpenURL) { item in
                SafariView(url: item.url, appearance: appearance, configuration: configuration)
                    .ignoresSafeArea()
            }
    }

    private func handleURL(_ url: URL) -> OpenURLAction.Result {
        switch url.scheme {
        case "http", "https":
            ensureOpenURLItem(with: url)
            return .handled
        default:
            return .systemAction(url)
        }
    }

    private func ensureOpenURLItem(with url: URL) {
        switch presentationStyle {
        case .fullScreen:
            fullScreenOpenURL = .init(url: url, style: .fullScreen)
        case .modal:
            modalOpenURL = .init(url: url, style: .modal)
        }
    }
}

public extension OpenURLInSafariViewModifier {
    enum PresentationStyle: Identifiable {
        case fullScreen
        case modal

        public var id: Self {
            self
        }
    }
}

public extension View {
    func openURLInSafariView(
        appearance: SafariView.Appearance? = nil,
        configuration: SafariView.Configuration? = nil,
        presentationStyle: OpenURLInSafariViewModifier.PresentationStyle = .fullScreen
    ) -> some View {
        modifier(
            OpenURLInSafariViewModifier(
                appearance: appearance,
                configuration: configuration,
                presentationStyle: presentationStyle
            )
        )
    }
}

// MARK: - Private

private struct OpenURLItem: Identifiable {
    let url: URL
    let style: OpenURLInSafariViewModifier.PresentationStyle

    var id: OpenURLInSafariViewModifier.PresentationStyle {
        style
    }
}
