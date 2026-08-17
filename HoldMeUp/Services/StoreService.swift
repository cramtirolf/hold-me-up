import StoreKit

/// Product identifiers must match whatever's configured in App Store Connect
/// once Developer Program enrollment + IAP setup is done — see CLAUDE.md
/// "Deferred / TODO". These are placeholders and will not resolve to real
/// products yet.
enum StoreProduct: String, CaseIterable {
    case tipSmall = "com.wynwin.holdmeup.tip.small"
    case tipMedium = "com.wynwin.holdmeup.tip.medium"
    case tipLarge = "com.wynwin.holdmeup.tip.large"
    case partyPack = "com.wynwin.holdmeup.unlock.partypack"
}

@MainActor
final class StoreService: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var partyPackUnlocked = false

    func loadProducts() async {
        guard let fetched = try? await Product.products(for: StoreProduct.allCases.map(\.rawValue)) else { return }
        products = fetched
    }

    func purchase(_ product: Product) async {
        guard let result = try? await product.purchase() else { return }
        if case .success(let verification) = result, case .verified(let transaction) = verification {
            if transaction.productID == StoreProduct.partyPack.rawValue {
                partyPackUnlocked = true
            }
            await transaction.finish()
        }
    }
}
