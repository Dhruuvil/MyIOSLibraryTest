import Foundation

public struct Reward {
    public var brand: String
    public var offer: String
    public var productName: String
    public var adId: Int
    public var cashback: String
    public var discount: String
    public var offerLeft: Int
    public var active: Bool
    public var scratched: Bool
    public var code: String
    public var couponLink: String
    public var logoUrl: String
    public var rating: Int
    public var couponCode: String
    public var scratchDate: String
    public var expiryDate: String

    public init(
        brand: String,
        offer: String,
        productName: String = "",
        adId: Int = 0,
        cashback: String = "",
        discount: String = "",
        offerLeft: Int = 0,
        active: Bool = false,
        scratched: Bool = false,
        code: String = "",
        couponLink: String = "",
        logoUrl: String = "",
        rating: Int = 0,
        couponCode: String = "",
        scratchDate: String = "",
        expiryDate: String = ""
    ) {
        self.brand = brand
        self.offer = offer
        self.productName = productName
        self.adId = adId
        self.cashback = cashback
        self.discount = discount
        self.offerLeft = offerLeft
        self.active = active
        self.scratched = scratched
        self.code = code
        self.couponLink = couponLink
        self.logoUrl = logoUrl
        self.rating = rating
        self.couponCode = couponCode
        self.scratchDate = scratchDate
        self.expiryDate = expiryDate
    }
}
