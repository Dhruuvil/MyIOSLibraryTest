import UIKit
import MobyRewards

class MobyRewardsDemoViewController: UIViewController {

    private var rewardsView: MobyRewardsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Moby Rewards Demo"

        // 1. Instantiate the MobyRewardsView
        rewardsView = MobyRewardsView(frame: view.bounds)
        rewardsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(rewardsView)

        // 2. Set API Configuration
        rewardsView.setApiConfig(
            affiliateId: "MOBY_7",
            appShortName: "AF2YFN",
            secureKey: "ztxwjmch",
            userUnique: "9726782361",
            gender: "male",
            age: 30
        )
    }
}
