import UIKit

// MARK: - UIColor Hex Extension
public extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        if hexSanitized.count == 8 {
            let a = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            let r = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let g = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let b = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        } else if hexSanitized.count == 6 {
            let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else {
            self.init(white: 0.0, alpha: 1.0)
        }
    }
}

// MARK: - RewardsColorCombination
public struct RewardsColorCombination {

    // MAIN COLORS
    public var backgroundColor: UIColor = UIColor(hex: "#F7F8FC")
    public var primaryColor: UIColor = UIColor(hex: "#FF6B35")
    public var secondaryColor: UIColor = .white

    // CARD
    public var cardBackgroundColor: UIColor = .white
    public var cardBorderColor: UIColor = UIColor(hex: "#E5E7EB")
    public var cardShadowColor: UIColor = UIColor.black.withAlphaComponent(0.13)

    // TEXT
    public var titleTextColor: UIColor = UIColor(hex: "#111827")
    public var descriptionTextColor: UIColor = UIColor(hex: "#4B5563")
    public var mutedTextColor: UIColor = UIColor(hex: "#9CA3AF")

    // TABS
    public var tabBackgroundColor: UIColor = UIColor(hex: "#EDEFF3")
    public var activeTabColor: UIColor = UIColor(hex: "#FF6B35")
    public var activeTabTextColor: UIColor = .white
    public var inactiveTabTextColor: UIColor = UIColor(hex: "#6B7280")

    // SCRATCH
    public var scratchCoverColor: UIColor = UIColor(hex: "#FF6B35")
    public var scratchTextColor: UIColor = .white
    public var scratchBackgroundColor: UIColor = UIColor(hex: "#FFF3EE")
    public var scratchIconColor: UIColor = .white

    // BUTTON
    public var buttonColor: UIColor = .white
    public var buttonTextColor: UIColor = UIColor(hex: "#FF6B35")

    // BADGE
    public var badgeBackgroundColor: UIColor = UIColor(hex: "#FFF0E8")
    public var badgeTextColor: UIColor = UIColor(hex: "#FF6B35")

    // INFO
    public var infoBackgroundColor: UIColor = UIColor(hex: "#F3F4F6")
    public var infoIconBackgroundColor: UIColor = UIColor(hex: "#E5E7EB")
    public var infoTextColor: UIColor = UIColor(hex: "#374151")

    // BORDER
    public var borderColor: UIColor = UIColor(hex: "#E5E7EB")

    // ERROR COLORS
    public var errorTextColor: UIColor = .red
    public var errorBackgroundColor: UIColor = UIColor(hex: "#FFF1F1")
    public var errorBorderColor: UIColor = UIColor(hex: "#FFD0D0")

    // SHADOW
    public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.13)
    public var shadowRadius: CGFloat = 8.0
    public var shadowDx: CGFloat = 0.0
    public var shadowDy: CGFloat = 4.0

    // FONT
    public var fontName: String = ""

    // TEXT SIZES
    public var titleTextSize: CGFloat = 24.0
    public var descriptionTextSize: CGFloat = 13.0
    public var sectionTextSize: CGFloat = 16.0
    public var bodyTextSize: CGFloat = 13.0
    public var buttonTextSize: CGFloat = 13.0
    public var smallTextSize: CGFloat = 11.0

    // SCREEN SPACING
    public var screenPaddingLeft: CGFloat = 16.0
    public var screenPaddingTop: CGFloat = 12.0
    public var screenPaddingRight: CGFloat = 16.0
    public var screenPaddingBottom: CGFloat = 8.0

    public var subtitleTopMargin: CGFloat = 2.0

    // TABS / HEADER LAYOUT
    public var tabsTopMargin: CGFloat = 10.0
    public var tabsHeight: CGFloat = 46.0
    public var tabHeight: CGFloat = 44.0
    public var tabSpacing: CGFloat = 5.0
    public var tabRadius: CGFloat = 10.0

    public var sectionTopMargin: CGFloat = 15.0
    public var sectionBottomMargin: CGFloat = 10.0
    public var pagerTopMargin: CGFloat = 2.0

    // GENERAL CARD LAYOUT
    public var cardSideMargin: CGFloat = 6.0
    public var cardTopMargin: CGFloat = 4.0
    public var cardBottomMargin: CGFloat = 4.0
    public var cardRadius: CGFloat = 10.0
    public var cardBorderWidth: CGFloat = 1.0

    // SKELETON
    public var skeletonPadding: CGFloat = 12.0
    public var skeletonRadius: CGFloat = 10.0
    public var skeletonItemRadius: CGFloat = 10.0
    public var skeletonProductHeight: CGFloat = 42.0
    public var skeletonScratchHeight: CGFloat = 205.0
    public var skeletonScratchTopMargin: CGFloat = 10.0

    // UPCOMING CARD
    public var upcomingCardPadding: CGFloat = 12.0
    public var upcomingProductPaddingHorizontal: CGFloat = 10.0
    public var upcomingProductPaddingVertical: CGFloat = 8.0
    public var upcomingProductRadius: CGFloat = 10.0
    public var upcomingPreviewHeight: CGFloat = 205.0
    public var upcomingPreviewTopMargin: CGFloat = 10.0

    // POPUP
    public var popupOverlayColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    public var popupElevation: CGFloat = 100.0
    public var popupWidthFraction: CGFloat = 0.88

    public var popupPaddingLeft: CGFloat = 14.0
    public var popupPaddingTop: CGFloat = 10.0
    public var popupPaddingRight: CGFloat = 14.0
    public var popupPaddingBottom: CGFloat = 14.0
    public var popupRadius: CGFloat = 10.0

    public var popupTopBarHeight: CGFloat = 38.0
    public var popupCloseSize: CGFloat = 34.0
    public var popupCloseTextSize: CGFloat = 17.0
    public var popupCloseRadius: CGFloat = 8.0

    public var popupScratchHeight: CGFloat = 220.0
    public var popupScratchTopMargin: CGFloat = 10.0
    public var popupActiveCardTopMargin: CGFloat = 8.0

    // ACTIVE CARD
    public var activeCardPadding: CGFloat = 14.0
    public var activeCardRadius: CGFloat = 16.0

    public var activeLogoSize: CGFloat = 50.0
    public var activeLogoRadius: CGFloat = 11.0

    public var activeBrandInfoPaddingLeft: CGFloat = 10.0
    public var activeBrandInfoPaddingRight: CGFloat = 8.0
    public var activeProductTopMargin: CGFloat = 3.0

    public var ratingPaddingHorizontal: CGFloat = 8.0
    public var ratingPaddingVertical: CGFloat = 5.0
    public var ratingRadius: CGFloat = 9.0

    public var unlockedMessageTopMargin: CGFloat = 12.0
    public var unlockedMessageBottomMargin: CGFloat = 10.0

    public var offerBoxPaddingHorizontal: CGFloat = 12.0
    public var offerBoxPaddingVertical: CGFloat = 13.0
    public var offerBoxRadius: CGFloat = 13.0

    public var smallBlockTopMargin: CGFloat = 4.0

    public var couponPaddingHorizontal: CGFloat = 10.0
    public var couponPaddingVertical: CGFloat = 8.0
    public var couponRadius: CGFloat = 10.0
    public var couponLabelTopMargin: CGFloat = 10.0
    public var couponCodeTopMargin: CGFloat = 4.0

    public var shopPaddingHorizontal: CGFloat = 16.0
    public var shopPaddingVertical: CGFloat = 10.0
    public var shopRadius: CGFloat = 11.0
    public var bottomRowTopMargin: CGFloat = 11.0

    // DOTS
    public var dotsHeight: CGFloat = 28.0
    public var dotHorizontalPadding: CGFloat = 3.0

    public init() {}

    public func font(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        if !fontName.isEmpty, let customFont = UIFont(name: fontName, size: size) {
            return customFont
        }
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
