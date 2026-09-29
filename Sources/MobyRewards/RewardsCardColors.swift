import UIKit

public struct RewardsCardColors {
    public var card1: UIColor
    public var card2: UIColor
    public var card3: UIColor

    public init(
        card1: UIColor = UIColor(hex: "#FF6B35"),
        card2: UIColor = UIColor(hex: "#4A90E2"),
        card3: UIColor = UIColor(hex: "#50E3C2")
    ) {
        self.card1 = card1
        self.card2 = card2
        self.card3 = card3
    }
}
