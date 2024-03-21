import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(alignment: .leading, spacing: 4.0) {
                Text("FullScreen:")
                    .font(.title2)

                VStack {
                    Link("Visit Apple", destination: URL(string: "https://apple.com")!)
                    Text("Click [here](https://apple.com)")
                }
                .tint(.red)
                .openURLInSafariView(
                    appearance: .init(
                        preferredBarTintColor: .systemGray6,
                        preferredControlTintColor: .red,
                        dismissButtonStyle: .done
                    ),
                    configuration: makeConfiguration(),
                    presentationStyle: .fullScreen
                )
            }.padding()

            VStack(alignment: .leading, spacing: 4.0) {
                Text("Modal:")
                    .font(.title2)

                VStack {
                    Link("Visit Apple", destination: URL(string: "https://apple.com")!)
                    Text("Click [here](https://apple.com)")
                }
                .tint(.green)
                .openURLInSafariView(
                    appearance: .init(
                        preferredBarTintColor: .systemGray6,
                        preferredControlTintColor: .black,
                        dismissButtonStyle: .cancel
                    ),
                    configuration: makeConfiguration(),
                    presentationStyle: .modal
                )
            }.padding()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Sample")
    }
}

private func makeConfiguration() -> SafariView.Configuration {
    let configuration = SafariView.Configuration()
    configuration.barCollapsingEnabled = true
    return configuration
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .previewLayout(.sizeThatFits)
    }
}
