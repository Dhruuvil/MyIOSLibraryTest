import SwiftUI
import UIKit

public struct MobyRewardsSwiftUIView: UIViewRepresentable {

    public var affiliateId: String
    public var appShortName: String
    public var secureKey: String
    public var userUnique: String
    public var gender: String
    public var age: Int
    public var theme: RewardsColorCombination

    public init(
        affiliateId: String,
        appShortName: String,
        secureKey: String,
        userUnique: String,
        gender: String,
        age: Int,
        theme: RewardsColorCombination = RewardsColorCombination()
    ) {
        self.affiliateId = affiliateId
        self.appShortName = appShortName
        self.secureKey = secureKey
        self.userUnique = userUnique
        self.gender = gender
        self.age = age
        self.theme = theme
    }

    public func makeUIView(context: Context) -> MobyRewardsView {
        let view = MobyRewardsView()
        view.theme = theme
        view.setApiConfig(
            affiliateId: affiliateId,
            appShortName: appShortName,
            secureKey: secureKey,
            userUnique: userUnique,
            gender: gender,
            age: age
        )
        return view
    }

    public func updateUIView(_ uiView: MobyRewardsView, context: Context) {
        uiView.theme = theme
    }
}