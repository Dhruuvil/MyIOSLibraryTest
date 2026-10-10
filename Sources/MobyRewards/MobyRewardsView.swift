import UIKit



public class MobyRewardsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {



    // MARK: - UI Components

    private let scrollView = UIScrollView()

    private let contentView = UIView()



    private let titleLabel = UILabel()

    private let subtitleLabel = UILabel()

    private let sectionLabel = UILabel()



    private let tabsContainer = UIView()

    private let pendingTabButton = UIButton(type: .custom)

    private let activeTabButton = UIButton(type: .custom)



    private var collectionView: UICollectionView!

    private let dotsContainer = UIStackView()



    // MARK: - Configuration & Theme

    public var theme = RewardsColorCombination() {

        didSet {

            applyTheme()

        }

    }



    public var cardColors: RewardsCardColors?



    private var showActive = false

    private var isLoading = true

    private var errorMessage = ""



    // MARK: - API Config

    private var affiliateId = ""

    private var appShortName = ""

    private var secureKey = ""

    private var userUnique = ""

    private var gender = ""

    private var age = 0

    private var deviceId = ""



    private var libraryDeviceId: String {

        return "\(appShortName)-\(userUnique)"

    }



    private var storedFsToken = ""

    private var storedFiUserId = ""



    // MARK: - Data Lists

    private var upcomingRewards: [Reward] = []

    private var activeRewards: [Reward] = []



    private var visibleRewards: [Reward] {

        return showActive ? activeRewards : upcomingRewards

    }



    // MARK: - Initializers

    public override init(frame: CGRect) {

        super.init(frame: frame)

        setupViews()

    }



    public required init?(coder: NSCoder) {

        super.init(coder: coder)

        setupViews()

    }



    // MARK: - Setup Views

    private func setupViews() {

        backgroundColor = theme.backgroundColor



        // ScrollView

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.showsVerticalScrollIndicator = false

        addSubview(scrollView)



        contentView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentView)



        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: topAnchor),

            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),

            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),



            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),

            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)

        ])



        // Title Label

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Your Rewards"

        contentView.addSubview(titleLabel)



        // Subtitle Label

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Scratch, reveal & enjoy your rewards."

        subtitleLabel.numberOfLines = 0

        contentView.addSubview(subtitleLabel)



        // Tabs Container

        tabsContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(tabsContainer)



        pendingTabButton.translatesAutoresizingMaskIntoConstraints = false

        pendingTabButton.setTitle("Upcoming", for: .normal)

        pendingTabButton.addTarget(self, action: #selector(onPendingTabTapped), for: .touchUpInside)

        tabsContainer.addSubview(pendingTabButton)



        activeTabButton.translatesAutoresizingMaskIntoConstraints = false

        activeTabButton.setTitle("Active", for: .normal)

        activeTabButton.addTarget(self, action: #selector(onActiveTabTapped), for: .touchUpInside)

        tabsContainer.addSubview(activeTabButton)



        // Section Label

        sectionLabel.translatesAutoresizingMaskIntoConstraints = false

        sectionLabel.text = "Choose your reward"

        contentView.addSubview(sectionLabel)



        // CollectionView Layout

        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal

        layout.minimumLineSpacing = 12



        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.decelerationRate = .fast

        collectionView.delegate = self

        collectionView.dataSource = self

        collectionView.register(RewardCardCell.self, forCellWithReuseIdentifier: RewardCardCell.reuseIdentifier)

        contentView.addSubview(collectionView)



        // Dots Container

        dotsContainer.translatesAutoresizingMaskIntoConstraints = false

        dotsContainer.axis = .horizontal

        dotsContainer.alignment = .center

        dotsContainer.distribution = .equalSpacing

        dotsContainer.spacing = 6

        contentView.addSubview(dotsContainer)



        setupConstraints()

        applyTheme()

    }



    private func setupConstraints() {

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: theme.screenPaddingTop),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: theme.screenPaddingLeft),

            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -theme.screenPaddingRight),



            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: theme.subtitleTopMargin),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: theme.screenPaddingLeft),

            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -theme.screenPaddingRight),



            tabsContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: theme.tabsTopMargin),

            tabsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: theme.screenPaddingLeft),

            tabsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -theme.screenPaddingRight),

            tabsContainer.heightAnchor.constraint(equalToConstant: theme.tabsHeight),



            pendingTabButton.leadingAnchor.constraint(equalTo: tabsContainer.leadingAnchor),

            pendingTabButton.topAnchor.constraint(equalTo: tabsContainer.topAnchor, constant: 1),

            pendingTabButton.bottomAnchor.constraint(equalTo: tabsContainer.bottomAnchor, constant: -1),

            pendingTabButton.trailingAnchor.constraint(equalTo: tabsContainer.centerXAnchor, constant: -theme.tabSpacing / 2),



            activeTabButton.trailingAnchor.constraint(equalTo: tabsContainer.trailingAnchor),

            activeTabButton.topAnchor.constraint(equalTo: tabsContainer.topAnchor, constant: 1),

            activeTabButton.bottomAnchor.constraint(equalTo: tabsContainer.bottomAnchor, constant: -1),

            activeTabButton.leadingAnchor.constraint(equalTo: tabsContainer.centerXAnchor, constant: theme.tabSpacing / 2),



            sectionLabel.topAnchor.constraint(equalTo: tabsContainer.bottomAnchor, constant: theme.sectionTopMargin),

            sectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: theme.screenPaddingLeft),

            sectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -theme.screenPaddingRight),



            collectionView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: theme.pagerTopMargin),

            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            collectionView.heightAnchor.constraint(equalToConstant: 325),



            dotsContainer.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 2),

            dotsContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            dotsContainer.heightAnchor.constraint(equalToConstant: theme.dotsHeight),

            dotsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -theme.screenPaddingBottom)

        ])

    }



    // MARK: - Theme Application

    private func applyTheme() {

        backgroundColor = theme.backgroundColor



        titleLabel.font = theme.font(ofSize: theme.titleTextSize, weight: .bold)

        titleLabel.textColor = theme.titleTextColor



        subtitleLabel.font = theme.font(ofSize: theme.descriptionTextSize, weight: .regular)

        subtitleLabel.textColor = theme.descriptionTextColor



        sectionLabel.font = theme.font(ofSize: theme.sectionTextSize, weight: .bold)

        sectionLabel.textColor = theme.titleTextColor



        applyTabsStyle()

        collectionView.reloadData()

        refreshDots()

    }



    private func applyTabsStyle() {



        pendingTabButton.layer.cornerRadius = theme.tabRadius

        pendingTabButton.layer.masksToBounds = true

        pendingTabButton.titleLabel?.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)



        if !showActive {

            pendingTabButton.backgroundColor = theme.activeTabColor

            pendingTabButton.setTitleColor(theme.activeTabTextColor, for: .normal)

        } else {

            pendingTabButton.backgroundColor = theme.tabBackgroundColor

            pendingTabButton.setTitleColor(theme.inactiveTabTextColor, for: .normal)

        }





        activeTabButton.layer.cornerRadius = theme.tabRadius

        activeTabButton.layer.masksToBounds = true

        activeTabButton.titleLabel?.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)



        if showActive {

            activeTabButton.backgroundColor = theme.activeTabColor

            activeTabButton.setTitleColor(theme.activeTabTextColor, for: .normal)

        } else {

            activeTabButton.backgroundColor = theme.tabBackgroundColor

            activeTabButton.setTitleColor(theme.inactiveTabTextColor, for: .normal)

        }

    }



    // MARK: - Tab Actions

    @objc private func onPendingTabTapped() {

        showActive = false

        applyTabsStyle()

        collectionView.reloadData()

        if !visibleRewards.isEmpty {

            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)

        }

        refreshDots()

    }



    @objc private func onActiveTabTapped() {

        showActive = true

        isLoading = true

        applyTabsStyle()

        collectionView.reloadData()

        loadActiveOffers()

    }



    // MARK: - API Configuration & Methods

    public func setApiConfig(

        affiliateId: String,

        appShortName: String,

        secureKey: String,

        userUnique: String,

        gender: String,

        age: Int

    ) {

        self.affiliateId = affiliateId

        self.appShortName = appShortName

        self.secureKey = secureKey

        self.userUnique = userUnique

        self.gender = gender

        self.age = age

        self.deviceId = "\(appShortName)-\(userUnique)"



        DispatchQueue.main.async {

            self.loadUpcomingOffers()

        }

    }



    private func loadUpcomingOffers() {

        isLoading = true

        errorMessage = ""

        collectionView.reloadData()



        MobyApi.getUpcomingOffers(

            affiliateId: affiliateId,

            appShortName: appShortName,

            secureKey: secureKey,

            userUnique: userUnique,

            gender: gender,

            age: age,

            deviceId: libraryDeviceId,

            onSuccess: { [weak self] response in

                guard let self = self else { return }

                self.sectionLabel.isHidden = false

                self.storedFsToken = response["fsToken"] as? String ?? ""

                self.storedFiUserId = "\(response["fiUserId"] ?? "")"

                self.setUpcomingOffers(response: response)

                self.refreshDots()

            },

            onError: { [weak self] error in

                guard let self = self else { return }

                self.errorMessage = error

                self.isLoading = false

                self.sectionLabel.isHidden = true

                self.collectionView.reloadData()

            }

        )

    }



    public func setUpcomingOffers(response: [String: Any]) {

        isLoading = false

        storedFsToken = response["fsToken"] as? String ?? ""

        storedFiUserId = "\(response["fiUserId"] ?? "")"



        upcomingRewards.removeAll()



        if let offerList = response["foOfferList"] as? [[String: Any]] {

            for item in offerList {

                let brand = item["fsAdName"] as? String ?? "Offer"

                let discount = item["fsDiscountUpTo"] as? String ?? ""

                let cashback = item["fsFlatCashBack"] as? String ?? ""

                let product = item["fsProductName"] as? String ?? ""



                let offerText: String

                if !discount.isEmpty {

                    offerText = discount

                } else if !cashback.isEmpty {

                    offerText = "\(cashback) Cashback"

                } else if !product.isEmpty {

                    offerText = product

                } else {

                    offerText = "Exclusive Offer"

                }



                let adId = (item["fiAdId"] as? Int) ?? Int("\(item["fiAdId"] ?? 0)") ?? 0

                let offerLeft = (item["fiOfferLeft"] as? Int) ?? Int("\(item["fiOfferLeft"] ?? 0)") ?? 0

                let rating = (item["fiStoreRating"] as? Int) ?? Int("\(item["fiStoreRating"] ?? 0)") ?? 0

                let code = item["fsCouponCode"] as? String ?? ""

                let couponLink = item["fsCouponLink"] as? String ?? ""

                let logoUrl = item["fsAdLogo"] as? String ?? ""

                let expiryDate = item["fsCouponExpiry"] as? String ?? ""



                let reward = Reward(

                    brand: brand,

                    offer: offerText,

                    productName: product,

                    adId: adId,

                    cashback: cashback,

                    discount: discount,

                    offerLeft: offerLeft,

                    active: false,

                    scratched: false,

                    code: code,

                    couponLink: couponLink,

                    logoUrl: logoUrl,

                    rating: rating,

                    couponCode: code,

                    scratchDate: "",

                    expiryDate: expiryDate

                )

                upcomingRewards.append(reward)

            }

        }



        collectionView.reloadData()

        if !showActive && !upcomingRewards.isEmpty {

            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)

        }

        refreshDots()

    }



    private func loadActiveOffers() {

        isLoading = true

        errorMessage = ""

        collectionView.reloadData()



        MobyApi.getActiveOffers(

            affiliateId: affiliateId,

            appShortName: appShortName,

            secureKey: secureKey,

            userUnique: userUnique,

            gender: gender,

            age: age,

            deviceId: libraryDeviceId,

            onSuccess: { [weak self] response in

                guard let self = self else { return }

                self.sectionLabel.isHidden = false

                self.setActiveOffers(response: response)

                self.isLoading = false

                self.showActive = true

                self.collectionView.reloadData()

                self.refreshDots()

                if !self.activeRewards.isEmpty {

                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)

                }

            },

            onError: { [weak self] error in

                guard let self = self else { return }

                self.errorMessage = error

                self.isLoading = false

                self.sectionLabel.isHidden = true

                self.collectionView.reloadData()

            }

        )

    }



    public func setActiveOffers(response: [String: Any]) {

        // Preserve rewards scratched in this session if the API has not returned them yet.
        let locallyScratchedRewards = activeRewards.filter { $0.scratched }
        activeRewards.removeAll()



        if let offerList = response["foOfferList"] as? [[String: Any]] {

            for item in offerList {

                let brand = item["fsAdName"] as? String ?? "Offer"

                let cashback = item["fsFlatCashBack"] as? String ?? ""

                let discount = item["fsDiscountUpTo"] as? String ?? ""

                let product = item["fsProductName"] as? String ?? ""

                let couponCode = item["fsCouponCode"] as? String ?? ""

                let couponLink = item["fsCouponLink"] as? String ?? ""

                let couponExpiry = item["fsCouponExpiry"] as? String ?? ""

                let logoUrl = item["fsAdLogo"] as? String ?? ""



                let offerText: String

                if !cashback.isEmpty {

                    offerText = "\(cashback) Cashback"

                } else if !discount.isEmpty {

                    offerText = discount

                } else if !product.isEmpty {

                    offerText = product

                } else {

                    offerText = "Exclusive Offer"

                }



                let adId = (item["fiAdId"] as? Int) ?? Int("\(item["fiAdId"] ?? 0)") ?? 0

                let rating = (item["fiStoreRating"] as? Int) ?? Int("\(item["fiStoreRating"] ?? 0)") ?? 0



                let reward = Reward(

                    brand: brand,

                    offer: offerText,

                    productName: product,

                    adId: adId,

                    cashback: cashback,

                    discount: discount,

                    offerLeft: 0,

                    active: true,

                    scratched: true,

                    code: couponCode,

                    couponLink: couponLink,

                    logoUrl: logoUrl,

                    rating: rating,

                    couponCode: couponCode,

                    scratchDate: "",

                    expiryDate: couponExpiry

                )

                activeRewards.append(reward)

            }

        }



        // Merge locally scratched rewards that the API has not returned yet.
        for reward in locallyScratchedRewards {
            if !activeRewards.contains(where: { $0.adId == reward.adId }) {
                activeRewards.append(reward)
            }
        }

        collectionView.reloadData()

    }



    // MARK: - Dots Refresh

    private func refreshDots() {

        dotsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let count = visibleRewards.count

        guard count > 0 else { return }



        let currentIndex = currentCenteredIndex()



        for i in 0..<count {

            let dot = UILabel()

            dot.text = "●"

            dot.font = theme.font(ofSize: theme.smallTextSize)

            dot.textColor = (i == currentIndex) ? theme.activeTabColor : theme.mutedTextColor

            dotsContainer.addArrangedSubview(dot)

        }

    }



    private func currentCenteredIndex() -> Int {

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {

            return indexPath.item

        }

        return 0

    }



    // MARK: - CollectionView DataSource & Delegate

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if isLoading || !errorMessage.isEmpty {

            return 1

        }

        return visibleRewards.count

    }



    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardCardCell.reuseIdentifier, for: indexPath) as! RewardCardCell



        if isLoading {

            cell.showSkeleton(theme: theme)

            return cell

        }



        if !errorMessage.isEmpty {

            cell.showError(message: errorMessage, theme: theme)

            return cell

        }



        let reward = visibleRewards[indexPath.item]

        cell.configure(reward: reward, theme: theme, onCardClick: { [weak self] in

            guard let self = self else { return }

            if !reward.active && !reward.scratched {

                self.openScratchPopup(reward: reward)

            }

        })



        return cell

    }



    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width - (theme.screenPaddingLeft + theme.screenPaddingRight)

        return CGSize(width: max(width, 280), height: 315)

    }



    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: theme.screenPaddingLeft, bottom: 0, right: theme.screenPaddingRight)

    }



    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        refreshDots()

    }



    // MARK: - Scratch Popup Modal

    private func openScratchPopup(reward: Reward) {

        guard let window = self.window ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }



        var mutableReward = reward



        let overlay = UIView(frame: window.bounds)

        overlay.backgroundColor = theme.popupOverlayColor

        overlay.tag = 99912



        let popupWidth = window.bounds.width * theme.popupWidthFraction

        let popup = UIView()

        popup.translatesAutoresizingMaskIntoConstraints = false

        popup.backgroundColor = theme.cardBackgroundColor

        popup.layer.cornerRadius = theme.popupRadius

        popup.layer.masksToBounds = true

        overlay.addSubview(popup)



        // Top bar

        let topBar = UIView()

        topBar.translatesAutoresizingMaskIntoConstraints = false

        popup.addSubview(topBar)



        let titleText = mutableReward.productName.isEmpty ? mutableReward.brand : mutableReward.productName

        let productTitleLabel = UILabel()

        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        productTitleLabel.text = titleText

        productTitleLabel.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)

        productTitleLabel.textColor = theme.titleTextColor

        topBar.addSubview(productTitleLabel)



        let closeButton = UIButton(type: .custom)

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setTitle("✕", for: .normal)

        closeButton.setTitleColor(theme.mutedTextColor, for: .normal)

        closeButton.titleLabel?.font = theme.font(ofSize: theme.popupCloseTextSize, weight: .medium)

        closeButton.backgroundColor = theme.infoBackgroundColor

        closeButton.layer.cornerRadius = theme.popupCloseRadius

        topBar.addSubview(closeButton)



        // Container for reveal card & scratch view

        let revealContainer = UIView()

        revealContainer.translatesAutoresizingMaskIntoConstraints = false

        popup.addSubview(revealContainer)



        let activeCardView = ActiveCardView()

        activeCardView.translatesAutoresizingMaskIntoConstraints = false

        activeCardView.configure(reward: mutableReward, theme: theme)

        revealContainer.addSubview(activeCardView)



        let scratchView = ScratchView()

        scratchView.translatesAutoresizingMaskIntoConstraints = false

        scratchView.setScratchColors(

            cover: theme.scratchCoverColor,

            text: theme.scratchTextColor,

            background: theme.scratchBackgroundColor,

            icon: theme.scratchIconColor

        )

        scratchView.setFont(name: theme.fontName, size: theme.bodyTextSize)

        revealContainer.addSubview(scratchView)



        if mutableReward.scratched {

            scratchView.isHidden = true

        }



        NSLayoutConstraint.activate([

            popup.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),

            popup.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),

            popup.widthAnchor.constraint(equalToConstant: popupWidth),



            topBar.topAnchor.constraint(equalTo: popup.topAnchor, constant: theme.popupPaddingTop),

            topBar.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: theme.popupPaddingLeft),

            topBar.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -theme.popupPaddingRight),

            topBar.heightAnchor.constraint(equalToConstant: theme.popupTopBarHeight),



            productTitleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor),

            productTitleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),



            closeButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor),

            closeButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: theme.popupCloseSize),

            closeButton.heightAnchor.constraint(equalToConstant: theme.popupCloseSize),



            revealContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: theme.popupScratchTopMargin),

            revealContainer.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: theme.popupPaddingLeft),

            revealContainer.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -theme.popupPaddingRight),

            revealContainer.bottomAnchor.constraint(equalTo: popup.bottomAnchor, constant: -theme.popupPaddingBottom),



            activeCardView.topAnchor.constraint(equalTo: revealContainer.topAnchor),

            activeCardView.leadingAnchor.constraint(equalTo: revealContainer.leadingAnchor),

            activeCardView.trailingAnchor.constraint(equalTo: revealContainer.trailingAnchor),

            activeCardView.bottomAnchor.constraint(equalTo: revealContainer.bottomAnchor),



            scratchView.topAnchor.constraint(equalTo: revealContainer.topAnchor),

            scratchView.leadingAnchor.constraint(equalTo: revealContainer.leadingAnchor),

            scratchView.trailingAnchor.constraint(equalTo: revealContainer.trailingAnchor),

            scratchView.bottomAnchor.constraint(equalTo: revealContainer.bottomAnchor),

            scratchView.heightAnchor.constraint(greaterThanOrEqualToConstant: max(theme.popupScratchHeight, 360))

        ])



        scratchView.onScratchComplete = { [weak self, weak scratchView] in

            guard let self = self else { return }

            mutableReward.scratched = true
            mutableReward.active = true

            // Move the scratched reward from Upcoming to Active.
            self.upcomingRewards.removeAll { $0.adId == mutableReward.adId }
            if !self.activeRewards.contains(where: { $0.adId == mutableReward.adId }) {
                self.activeRewards.append(mutableReward)
            }

            scratchView?.isHidden = true
            self.collectionView.reloadData()
            self.refreshDots()
            self.applyTabsStyle()

        }



        closeButton.addTarget(

    self,

    action: #selector(closeButtonTapped),

    for: .touchUpInside

)



        window.addSubview(overlay)

    }



    // MARK: - Custom Styling Helpers

    public func setColorCombination(_ value: RewardsColorCombination) {

        self.theme = value

    }



    public func setRewardCardColors(_ value: RewardsCardColors) {

        self.cardColors = value

        collectionView.reloadData()

    }



    public func setBackgroundColorDynamic(_ color: UIColor) {

        theme.backgroundColor = color

        applyTheme()

    }



    public func setButtonColors(button: UIColor, text: UIColor) {

        theme.buttonColor = button

        theme.buttonTextColor = text

        collectionView.reloadData()

    }



    public func setScratchColors(cover: UIColor, text: UIColor, background: UIColor) {

        theme.scratchCoverColor = cover

        theme.scratchTextColor = text

        theme.scratchBackgroundColor = background

        collectionView.reloadData()

    }



    public func setTextColors(title: UIColor, description: UIColor, muted: UIColor) {

        theme.titleTextColor = title

        theme.descriptionTextColor = description

        theme.mutedTextColor = muted

        applyTheme()

    }



    public func setTabColors(background: UIColor, active: UIColor, activeText: UIColor, inactiveText: UIColor) {

        theme.tabBackgroundColor = background

        theme.activeTabColor = active

        theme.activeTabTextColor = activeText

        theme.inactiveTabTextColor = inactiveText

        applyTabsStyle()

    }



    public func setFont(_ font: UIFont) {

        theme.fontName = font.fontName

        applyTheme()

    }


    @objc private func closeButtonTapped() {
        guard let window = self.window ??
            UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        window.viewWithTag(99912)?.removeFromSuperview()
    }

}



// MARK: - CollectionView Cell

private class RewardCardCell: UICollectionViewCell {

    static let reuseIdentifier = "RewardCardCell"



    private var onCardClickClosure: (() -> Void)?



    override init(frame: CGRect) {

        super.init(frame: frame)

        contentView.backgroundColor = .clear

    }



    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }



    func showError(message: String, theme: RewardsColorCombination) {

        contentView.subviews.forEach { $0.removeFromSuperview() }



        let errorContainer = UIView()

        errorContainer.translatesAutoresizingMaskIntoConstraints = false

        errorContainer.backgroundColor = theme.errorBackgroundColor

        errorContainer.layer.cornerRadius = theme.cardRadius

        errorContainer.layer.borderColor = theme.errorBorderColor.cgColor

        errorContainer.layer.borderWidth = 1.0

        contentView.addSubview(errorContainer)



        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = message

        label.textColor = theme.errorTextColor

        label.font = theme.font(ofSize: theme.bodyTextSize)

        label.numberOfLines = 0

        label.textAlignment = .center

        errorContainer.addSubview(label)



        NSLayoutConstraint.activate([

            errorContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            errorContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            errorContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            errorContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),



            label.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor, constant: 16),

            label.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor, constant: -16),

            label.centerYAnchor.constraint(equalTo: errorContainer.centerYAnchor)

        ])

    }



    func showSkeleton(theme: RewardsColorCombination) {

        contentView.subviews.forEach { $0.removeFromSuperview() }



        let skeleton = UIView()

        skeleton.translatesAutoresizingMaskIntoConstraints = false

        skeleton.backgroundColor = theme.cardBackgroundColor

        skeleton.layer.cornerRadius = theme.skeletonRadius

        skeleton.layer.borderColor = theme.cardBorderColor.cgColor

        skeleton.layer.borderWidth = 1.0

        contentView.addSubview(skeleton)



        let productBar = UIView()

        productBar.translatesAutoresizingMaskIntoConstraints = false

        productBar.backgroundColor = theme.infoBackgroundColor

        productBar.layer.cornerRadius = 8

        skeleton.addSubview(productBar)



        let scratchBox = UIView()

        scratchBox.translatesAutoresizingMaskIntoConstraints = false

        scratchBox.backgroundColor = theme.scratchBackgroundColor

        scratchBox.layer.cornerRadius = 10

        skeleton.addSubview(scratchBox)



        NSLayoutConstraint.activate([

            skeleton.topAnchor.constraint(equalTo: contentView.topAnchor),

            skeleton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            skeleton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            skeleton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),



            productBar.topAnchor.constraint(equalTo: skeleton.topAnchor, constant: theme.skeletonPadding),

            productBar.leadingAnchor.constraint(equalTo: skeleton.leadingAnchor, constant: theme.skeletonPadding),

            productBar.trailingAnchor.constraint(equalTo: skeleton.trailingAnchor, constant: -theme.skeletonPadding),

            productBar.heightAnchor.constraint(equalToConstant: theme.skeletonProductHeight),



            scratchBox.topAnchor.constraint(equalTo: productBar.bottomAnchor, constant: theme.skeletonScratchTopMargin),

            scratchBox.leadingAnchor.constraint(equalTo: skeleton.leadingAnchor, constant: theme.skeletonPadding),

            scratchBox.trailingAnchor.constraint(equalTo: skeleton.trailingAnchor, constant: -theme.skeletonPadding),

            scratchBox.heightAnchor.constraint(equalToConstant: theme.skeletonScratchHeight)

        ])

    }



    func configure(reward: Reward, theme: RewardsColorCombination, onCardClick: @escaping () -> Void) {

        contentView.subviews.forEach { $0.removeFromSuperview() }

        self.onCardClickClosure = onCardClick



        if reward.active {

            let activeCard = ActiveCardView()

            activeCard.translatesAutoresizingMaskIntoConstraints = false

            activeCard.configure(reward: reward, theme: theme)

            contentView.addSubview(activeCard)



            NSLayoutConstraint.activate([

                activeCard.topAnchor.constraint(equalTo: contentView.topAnchor),

                activeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

                activeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

                activeCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            ])

        } else {

            let card = UIView()

            card.translatesAutoresizingMaskIntoConstraints = false

            card.backgroundColor = theme.tabBackgroundColor

            card.layer.cornerRadius = theme.upcomingProductRadius

            card.layer.shadowColor = theme.cardShadowColor.cgColor

            card.layer.shadowRadius = theme.shadowRadius

            card.layer.shadowOffset = CGSize(width: theme.shadowDx, height: theme.shadowDy)

            card.layer.shadowOpacity = 0.6

            contentView.addSubview(card)



            let productNameLabel = UILabel()

            productNameLabel.translatesAutoresizingMaskIntoConstraints = false

            productNameLabel.text = reward.productName.isEmpty ? reward.brand : reward.productName

            productNameLabel.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)

            productNameLabel.textColor = theme.titleTextColor

            card.addSubview(productNameLabel)



            let scratchContainer = UIView()

            scratchContainer.translatesAutoresizingMaskIntoConstraints = false

            scratchContainer.backgroundColor = theme.primaryColor

            scratchContainer.layer.cornerRadius = theme.cardRadius

            scratchContainer.layer.masksToBounds = true

            card.addSubview(scratchContainer)



            let preview = ScratchView()

            preview.translatesAutoresizingMaskIntoConstraints = false

            preview.setScratchColors(cover: theme.scratchCoverColor, text: theme.scratchTextColor, background: theme.scratchBackgroundColor, icon: theme.scratchIconColor)

            preview.setFont(name: theme.fontName, size: theme.bodyTextSize)

            preview.setInteractionEnabled(false)

            preview.setScratchTextVisible(false)

            scratchContainer.addSubview(preview)



            NSLayoutConstraint.activate([

                card.topAnchor.constraint(equalTo: contentView.topAnchor),

                card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

                card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

                card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),



                productNameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),

                productNameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

                productNameLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),



                scratchContainer.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),

                scratchContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),

                scratchContainer.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),

                scratchContainer.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),



                preview.topAnchor.constraint(equalTo: scratchContainer.topAnchor),

                preview.leadingAnchor.constraint(equalTo: scratchContainer.leadingAnchor),

                preview.trailingAnchor.constraint(equalTo: scratchContainer.trailingAnchor),

                preview.bottomAnchor.constraint(equalTo: scratchContainer.bottomAnchor)

            ])



            let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))

            card.addGestureRecognizer(tap)

            card.isUserInteractionEnabled = true

        }

    }



    @objc private func handleCardTap() {

        onCardClickClosure?()

    }

}



// MARK: - Active Card View

private class ActiveCardView: UIView {

    private var onCopyCouponAction: (() -> Void)?
    private var onShopNowAction: (() -> Void)?


    override init(frame: CGRect) {

        super.init(frame: frame)

    }



    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }



    func configure(reward: Reward, theme: RewardsColorCombination) {

        subviews.forEach { $0.removeFromSuperview() }



        backgroundColor = theme.primaryColor

        layer.cornerRadius = theme.activeCardRadius

        layer.masksToBounds = true



        let container = UIStackView()

        container.translatesAutoresizingMaskIntoConstraints = false

        container.axis = .vertical

        container.spacing = 8
        container.distribution = .fill

        addSubview(container)



        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: topAnchor, constant: theme.activeCardPadding),

            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: theme.activeCardPadding),

            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -theme.activeCardPadding),

            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)

        ])



        // Top Row: Logo | Brand + Product | Rating

        let topRow = UIStackView()

        topRow.axis = .horizontal

        topRow.alignment = .center

        topRow.distribution = .fill
        topRow.spacing = 12
        // Keep the logo/brand row at its natural height so it cannot stretch
        // and create an unwanted gap before the unlocked-offer message.
        topRow.setContentHuggingPriority(.required, for: .vertical)
        topRow.setContentCompressionResistancePriority(.required, for: .vertical)



        let logoImageView = UIImageView()

        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        logoImageView.contentMode = .scaleAspectFit

        logoImageView.backgroundColor = .clear

        logoImageView.layer.cornerRadius = theme.activeLogoRadius

        logoImageView.clipsToBounds = true



        NSLayoutConstraint.activate([

            logoImageView.widthAnchor.constraint(equalToConstant: 58),

            logoImageView.heightAnchor.constraint(equalToConstant: 58)

        ])



        if let url = URL(string: reward.logoUrl) {

            URLSession.shared.dataTask(with: url) { data, _, _ in

                if let data = data, let image = UIImage(data: data) {

                    DispatchQueue.main.async {

                        logoImageView.image = image

                    }

                }

            }.resume()

        }



        let brandProductStack = UIStackView()

        brandProductStack.axis = .vertical

        brandProductStack.spacing = 2



        let brandLabel = UILabel()

        brandLabel.text = reward.brand

        brandLabel.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)

        brandLabel.textColor = theme.secondaryColor

        brandProductStack.addArrangedSubview(brandLabel)



        if !reward.productName.isEmpty {

            let productLabel = UILabel()

            productLabel.text = reward.productName

            productLabel.font = theme.font(ofSize: theme.smallTextSize, weight: .regular)

            productLabel.textColor = theme.secondaryColor

            brandProductStack.addArrangedSubview(productLabel)

        }



        topRow.addArrangedSubview(logoImageView)

        topRow.addArrangedSubview(brandProductStack)



        if reward.rating > 0 {

            // Fixed-width rating pill with a native flame icon.
            let ratingPill = UIStackView()
            ratingPill.translatesAutoresizingMaskIntoConstraints = false
            ratingPill.axis = .horizontal
            ratingPill.alignment = .center
            ratingPill.distribution = .fill
            ratingPill.spacing = 5
            ratingPill.isLayoutMarginsRelativeArrangement = true
            ratingPill.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            ratingPill.backgroundColor = theme.secondaryColor
            ratingPill.layer.cornerRadius = theme.ratingRadius
            ratingPill.clipsToBounds = true

            let fireIcon = UIImageView(image: UIImage(systemName: "flame.fill"))
            fireIcon.translatesAutoresizingMaskIntoConstraints = false
            fireIcon.contentMode = .scaleAspectFit
            fireIcon.tintColor = theme.primaryColor

            let ratingLabel = UILabel()
            ratingLabel.text = "\(reward.rating)"
            ratingLabel.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)
            ratingLabel.textColor = theme.primaryColor
            ratingLabel.textAlignment = .center
            ratingLabel.setContentHuggingPriority(.required, for: .horizontal)

            ratingPill.addArrangedSubview(fireIcon)
            ratingPill.addArrangedSubview(ratingLabel)
            NSLayoutConstraint.activate([
                ratingPill.widthAnchor.constraint(equalToConstant: 66),
                ratingPill.heightAnchor.constraint(equalToConstant: 28),
                fireIcon.widthAnchor.constraint(equalToConstant: 16),
                fireIcon.heightAnchor.constraint(equalToConstant: 18)
            ])
            topRow.addArrangedSubview(ratingPill)
        }

        container.addArrangedSubview(topRow)

        // Unlocked Message with a native celebration icon.
        let messageRow = UIStackView()
        messageRow.axis = .horizontal
        messageRow.alignment = .center
        messageRow.spacing = 6

        let celebrationIcon = UIImageView(image: UIImage(systemName: "party.popper.fill"))
        celebrationIcon.translatesAutoresizingMaskIntoConstraints = false
        celebrationIcon.contentMode = .scaleAspectFit
        celebrationIcon.tintColor = theme.secondaryColor
        NSLayoutConstraint.activate([
            celebrationIcon.widthAnchor.constraint(equalToConstant: 16),
            celebrationIcon.heightAnchor.constraint(equalToConstant: 16)
        ])

        let messageLabel = UILabel()
        messageLabel.text = "You unlocked an exclusive offer!"
        messageLabel.font = theme.font(ofSize: theme.smallTextSize, weight: .regular)
        messageLabel.textColor = theme.secondaryColor
        messageLabel.numberOfLines = 1
        messageLabel.lineBreakMode = .byTruncatingTail

        messageRow.addArrangedSubview(celebrationIcon)
        messageRow.addArrangedSubview(messageLabel)
        container.addArrangedSubview(messageRow)



        // Offer Box — preserve the existing design and keep the content visible.
        let offerBox = UIStackView()
        offerBox.translatesAutoresizingMaskIntoConstraints = false
        offerBox.axis = .vertical
        offerBox.alignment = .fill
        offerBox.distribution = .fill
        offerBox.spacing = 3
        offerBox.backgroundColor = .white
        offerBox.layer.cornerRadius = theme.offerBoxRadius
        offerBox.clipsToBounds = true
        offerBox.isLayoutMarginsRelativeArrangement = true
        // Keep the offer panel compact so the logo row, coupon, expiry date,
        // and Shop Now button remain visible inside the popup.
        offerBox.layoutMargins = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)

        let discountLabel = UILabel()
        let discountText = !reward.discount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Discount Up to \(reward.discount)"
            : (!reward.offer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? reward.offer
                : "Exclusive Offer")
        discountLabel.text = discountText
        discountLabel.font = theme.font(ofSize: theme.titleTextSize, weight: .bold)
        discountLabel.textColor = .darkText
        discountLabel.textAlignment = .center
        discountLabel.numberOfLines = 2
        discountLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        offerBox.addArrangedSubview(discountLabel)

        let cashbackText = !reward.cashback.isEmpty ? "\(reward.cashback) Cashback" : ""
        if !cashbackText.isEmpty {
            let cashbackLabel = UILabel()
            cashbackLabel.text = cashbackText
            cashbackLabel.font = theme.font(ofSize: theme.smallTextSize, weight: .regular)
            cashbackLabel.textColor = .darkGray
            cashbackLabel.textAlignment = .center
            cashbackLabel.numberOfLines = 1
            cashbackLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            offerBox.addArrangedSubview(cashbackLabel)
        }

        offerBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 84).isActive = true
        offerBox.setContentCompressionResistancePriority(.required, for: .vertical)
        container.addArrangedSubview(offerBox)



        // Coupon Box

        if !reward.code.isEmpty {

            let couponBox = UIView()

            couponBox.backgroundColor = theme.primaryColor

            couponBox.layer.cornerRadius = theme.couponRadius

            couponBox.layer.borderColor = theme.secondaryColor.cgColor

            couponBox.layer.borderWidth = 1.0



            let couponLabel = UILabel()

            couponLabel.translatesAutoresizingMaskIntoConstraints = false

            couponLabel.text = reward.code

            couponLabel.font = theme.font(ofSize: theme.bodyTextSize, weight: .bold)

            couponLabel.textColor = theme.secondaryColor

            couponBox.addSubview(couponLabel)



            let copyButton = UIButton(type: .system)

            copyButton.translatesAutoresizingMaskIntoConstraints = false

            copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
            copyButton.tintColor = theme.secondaryColor
            copyButton.accessibilityLabel = "Copy coupon code"

            couponBox.addSubview(copyButton)



            self.onCopyCouponAction = { [weak self] in
                UIPasteboard.general.string = reward.code
                self?.showToast(message: "Coupon copied successfully")
            }
            copyButton.addTarget(self, action: #selector(copyCouponTapped), for: .touchUpInside)



            NSLayoutConstraint.activate([

                couponLabel.leadingAnchor.constraint(equalTo: couponBox.leadingAnchor, constant: 12),

                couponLabel.centerYAnchor.constraint(equalTo: couponBox.centerYAnchor),



                copyButton.trailingAnchor.constraint(equalTo: couponBox.trailingAnchor, constant: -9),

                copyButton.centerYAnchor.constraint(equalTo: couponBox.centerYAnchor),

                copyButton.widthAnchor.constraint(equalToConstant: 30),

                copyButton.heightAnchor.constraint(equalToConstant: 30),



                couponBox.heightAnchor.constraint(equalToConstant: 44)

            ])



            container.addArrangedSubview(couponBox)

        }



        // Bottom Row: Expiry Left | Shop Now Right
        let bottomRow = UIStackView()
        bottomRow.translatesAutoresizingMaskIntoConstraints = false
        bottomRow.axis = .horizontal
        bottomRow.alignment = .center
        bottomRow.distribution = .fill
        bottomRow.spacing = 8

        let expiryStack = UIStackView()
        expiryStack.axis = .horizontal
        expiryStack.alignment = .center
        expiryStack.spacing = 5
        expiryStack.distribution = .fill

        let calendarImage = UIImage(systemName: "calendar") ?? UIImage(systemName: "calendar.circle")
        let calLabel = UIImageView(image: calendarImage)
        calLabel.isHidden = calendarImage == nil
        calLabel.tintColor = theme.secondaryColor
        calLabel.contentMode = .scaleAspectFit
        calLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calLabel.widthAnchor.constraint(equalToConstant: 14),
            calLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        calLabel.setContentHuggingPriority(.required, for: .horizontal)

        let expiryLabel = UILabel()
        expiryLabel.text = !reward.expiryDate.isEmpty ? reward.expiryDate : "-"
        expiryLabel.font = theme.font(ofSize: theme.smallTextSize, weight: .regular)
        expiryLabel.textColor = theme.secondaryColor
        expiryLabel.textAlignment = .left
        expiryLabel.numberOfLines = 1
        expiryLabel.lineBreakMode = .byTruncatingTail
        expiryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        expiryStack.addArrangedSubview(calLabel)
        expiryStack.addArrangedSubview(expiryLabel)

        let shopNowButton = UIButton(type: .custom)
        shopNowButton.translatesAutoresizingMaskIntoConstraints = false
        shopNowButton.setTitle("SHOP NOW", for: .normal)
        shopNowButton.setTitleColor(theme.buttonTextColor, for: .normal)
        shopNowButton.titleLabel?.font = theme.font(ofSize: theme.buttonTextSize, weight: .bold)
        shopNowButton.titleLabel?.textAlignment = .center
        shopNowButton.backgroundColor = theme.buttonColor
        shopNowButton.layer.cornerRadius = theme.shopRadius
        shopNowButton.clipsToBounds = true
        shopNowButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        shopNowButton.titleLabel?.lineBreakMode = .byClipping
        shopNowButton.setContentHuggingPriority(.required, for: .horizontal)
        shopNowButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            shopNowButton.widthAnchor.constraint(equalToConstant: 120),
            shopNowButton.heightAnchor.constraint(equalToConstant: 38)
        ])

        self.onShopNowAction = { [weak self] in
            if !reward.code.isEmpty {
                UIPasteboard.general.string = reward.code
                self?.showToast(message: "Coupon copied successfully")
            }

            if !reward.couponLink.isEmpty, let url = URL(string: reward.couponLink) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        shopNowButton.addTarget(self, action: #selector(shopNowTapped), for: .touchUpInside)

        bottomRow.addArrangedSubview(expiryStack)
        bottomRow.addArrangedSubview(shopNowButton)
        container.addArrangedSubview(bottomRow)

    }



    private func showToast(message: String) {

        guard let window = window ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }



        let toastLabel = UILabel()

        toastLabel.text = message

        toastLabel.textColor = .white

        toastLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)

        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        toastLabel.textAlignment = .center

        toastLabel.layer.cornerRadius = 10

        toastLabel.clipsToBounds = true

        toastLabel.numberOfLines = 0



        let textSize = toastLabel.intrinsicContentSize

        let labelWidth = min(textSize.width + 30, window.frame.width - 40)

        let labelHeight = textSize.height + 16



        toastLabel.frame = CGRect(

            x: (window.frame.width - labelWidth) / 2,

            y: window.frame.height - 100,

            width: labelWidth,

            height: labelHeight

        )



        window.addSubview(toastLabel)



        UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut, animations: {

            toastLabel.alpha = 0.0

        }, completion: { _ in

            toastLabel.removeFromSuperview()

        })

    }


    @objc private func copyCouponTapped() {
        onCopyCouponAction?()
    }

    @objc private func shopNowTapped() {
        onShopNowAction?()
    }

}
