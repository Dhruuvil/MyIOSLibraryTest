
package com.mobyrewards.mobyrewards

import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.net.Uri
import android.view.ViewOutlineProvider
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager2.widget.ViewPager2
import org.json.JSONObject
import kotlin.math.abs
import java.net.HttpURLConnection
import java.net.URL
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.PixelFormat
import android.graphics.Color
import android.graphics.drawable.Drawable

class RewardsView(
    context: android.content.Context
) : FrameLayout(context) {

    private lateinit var titleText: TextView
    private lateinit var subtitleText: TextView
    private lateinit var sectionText: TextView
    private lateinit var pendingTab: TextView
    private lateinit var activeTab: TextView
    private lateinit var pager: ViewPager2

    private var theme: RewardsColorCombination = RewardsColorCombination()
    private var cardColors: RewardsCardColors? = null

    private var showActive = false
    private var isLoading = true

    // =========================================================
    // API CONFIG
    // =========================================================

    // API CONFIG - VALUES COME FROM APP
    private var affiliateId = ""
    private var appShortName = ""
    private var secureKey = ""
    private var userUnique = ""
    private var gender = ""
    private var age = 0
    private var deviceId = ""

    // LIBRARY GENERATED DATA
    private val libraryDeviceId: String
        get() = "$appShortName-$userUnique"

    // DATA STORED FROM UPCOMING API RESPONSE
    private var storedFsToken = ""
    private var storedFiUserId = ""
    // =========================================================
    // SEPARATE UPCOMING / ACTIVE LISTS
    // =========================================================

    private val upcomingRewards = mutableListOf<Reward>()
    private val activeRewards = mutableListOf<Reward>()

    private val adapter = RewardAdapter()

    init {
        setBackgroundColor(theme.backgroundColor)

        val content = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL

            setPadding(
                dp(theme.screenPaddingLeft),
                dp(theme.screenPaddingTop),
                dp(theme.screenPaddingRight),
                dp(theme.screenPaddingBottom)
            )
        }

        addView(
            content,
            LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT
            )
        )

        titleText = textView("Your Rewards")

        subtitleText =
            textView("Scratch, reveal & enjoy your rewards.")

        sectionText =
            textView("Choose your reward")

        content.addView(titleText)

        content.addView(
            subtitleText,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dp(theme.subtitleTopMargin)
            }
        )

        // =====================================================
        // TABS
        // =====================================================

        val tabs = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            setPadding(0, 0, 0, 0)
            clipChildren = false
            clipToPadding = false
            elevation = 0f
            stateListAnimator = null
        }

        pendingTab = textView("Upcoming")
        activeTab = textView("Active")

        tabs.addView(
            pendingTab,
            LinearLayout.LayoutParams(
                0,
                dp(44),
                1f
            ).apply {
                rightMargin = dp(theme.tabSpacing)
            }
        )

        tabs.addView(
            activeTab,
            LinearLayout.LayoutParams(
                0,
                dp(44),
                1f
            ).apply {
                leftMargin = dp(theme.tabSpacing)
            }
        )

        content.addView(
            tabs,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                dp(46)
            ).apply {
                topMargin = dp(10)
            }
        )

        content.addView(
            sectionText,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dp(theme.sectionTopMargin)
                bottomMargin = dp(theme.sectionBottomMargin)
            }
        )

        // =====================================================
        // PAGER
        // =====================================================

        pager = ViewPager2(context).apply {
            adapter = this@RewardsView.adapter
            clipToPadding = false
            clipChildren = false
        }

        content.addView(
            pager,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                0,
                1f
            ).apply {
                topMargin = dp(theme.pagerTopMargin)
            }
        )

        pager.setPageTransformer { page, position ->

            val value = abs(position).coerceAtMost(1f)

            page.scaleX =
                0.94f + (1f - value) * 0.06f

            page.scaleY =
                0.94f + (1f - value) * 0.06f

            page.alpha =
                0.85f + (1f - value) * 0.15f
        }

        // =====================================================
        // UPCOMING TAB
        // =====================================================

        pendingTab.setOnClickListener {

            showActive = false

            pager.currentItem = 0

            adapter.notifyDataSetChanged()

            applyTabs()
        }

        // =====================================================
        // ACTIVE TAB
        // =====================================================

        activeTab.setOnClickListener {

            showActive = true

            isLoading = true
            adapter.notifyDataSetChanged()

            loadActiveOffers()
        }

        applyHeader()
        applyTabs()
    }

    // =========================================================
    // API CONFIG
    // =========================================================

    fun setApiConfig(
        affiliateId: String,
        appShortName: String,
        secureKey: String,
        userUnique: String,
        gender: String,
        age: Int
    ) {

        this.affiliateId = affiliateId
        this.appShortName = appShortName
        this.secureKey = secureKey
        this.userUnique = userUnique
        this.gender = gender
        this.age = age

        // Library creates Device ID
        this.deviceId = "$appShortName-$userUnique"

        // Library calls Upcoming API
        post {
            loadUpcomingOffers()
        }
    }

    private fun loadUpcomingOffers() {

        isLoading = true
        adapter.notifyDataSetChanged()

        MobyApi.getUpcomingOffers(
            affiliateId = affiliateId,
            appShortName = appShortName,
            secureKey = secureKey,
            userUnique = userUnique,
            gender = gender,
            age = age,
            deviceId = libraryDeviceId,

            onSuccess = { response ->

                android.util.Log.d(
                    "MOBY_UPCOMING_API",
                    "FULL RESPONSE = ${response}"
                )

                android.util.Log.d(
                    "MOBY_UPCOMING_API",
                    "foOfferList = ${response.optJSONArray("foOfferList")}"
                )

                storedFsToken = response.optString("fsToken", "")
                storedFiUserId = response.optString("fiUserId", "")

                setUpcomingOffers(response)
            },
            onError = { error ->

                android.util.Log.e(
                    "MOBY_UPCOMING_API",
                    "Upcoming API Error: $error"
                )

                isLoading = false
                adapter.notifyDataSetChanged()
            }
        )
    }

    // =========================================================
    // UPCOMING API
    // =========================================================

    fun setUpcomingOffers(response: JSONObject) {

        isLoading = false

        storedFsToken = response.optString("fsToken", "")
        storedFiUserId = response.optString("fiUserId", "")

        val offerList =
            response.optJSONArray("foOfferList")

        upcomingRewards.clear()

        if (offerList == null) {
            adapter.notifyDataSetChanged()
            return
        }
        for (i in 0 until offerList.length()) {

            val item =
                offerList.optJSONObject(i)
                    ?: continue

            val brand =
                item.optString("fsAdName", "Offer")

            val discount =
                item.optString("fsDiscountUpTo", "")

            val cashback =
                item.optString("fsFlatCashBack", "")

            val product =
                item.optString("fsProductName", "")

            val offerText =
                when {

                    discount.isNotBlank() ->
                        discount

                    cashback.isNotBlank() ->
                        "$cashback Cashback"

                    product.isNotBlank() ->
                        product

                    else ->
                        "Exclusive Offer"
                }

            upcomingRewards.add(
                Reward(
                    brand = brand,
                    offer = offerText,
                    productName = product,
                    adId = item.optInt("fiAdId", 0),
                    cashback = cashback,
                    discount = discount,
                    offerLeft = item.optString(
                        "fiOfferLeft",
                        "0"
                    ).toIntOrNull() ?: 0,
                    rating = item.optInt("fiStoreRating", 0),
                    code = item.optString("fsCouponCode", ""),
                    couponCode = item.optString("fsCouponCode", ""),
                    couponLink = item.optString("fsCouponLink", ""),
                    logoUrl = item.optString("fsAdLogo", ""),
                    expiryDate = item.optString("fsCouponExpiry", ""),
                    active = false
                )
            )
        }

        // API data successfully loaded
        isLoading = false

        adapter.notifyDataSetChanged()

        if (!showActive) {
            pager.post {
                pager.currentItem = 0
            }
        }

        applyTabs()
    }

    // =========================================================
    // ACTIVE API
    // =========================================================

    fun setActiveOffers(response: JSONObject) {

        val offerList =
            response.optJSONArray("foOfferList")

        activeRewards.clear()

        if (offerList == null) {
            adapter.notifyDataSetChanged()
            return
        }

        for (i in 0 until offerList.length()) {

            val item =
                offerList.optJSONObject(i)
                    ?: continue

            val brand =
                item.optString("fsAdName", "Offer")

            val cashback =
                item.optString("fsFlatCashBack", "")

            val discount =
                item.optString("fsDiscountUpTo", "")

            val product =
                item.optString("fsProductName", "")

            val couponCode =
                item.optString("fsCouponCode", "")

            val couponLink =
                item.optString("fsCouponLink", "")

            val couponExpiry =
                item.optString("fsCouponExpiry", "")

            val logoUrl =
                item.optString("fsAdLogo", "")

            val offerText =
                when {

                    cashback.isNotBlank() ->
                        "$cashback Cashback"

                    discount.isNotBlank() ->
                        discount

                    product.isNotBlank() ->
                        product

                    else ->
                        "Exclusive Offer"
                }

            activeRewards.add(
                Reward(
                    brand = brand,
                    offer = offerText,
                    productName = product,
                    adId = item.optInt("fiAdId", 0),
                    cashback = cashback,
                    discount = discount,
                    offerLeft = 0,
                    active = true,
                    scratched = true,
                    code = couponCode,
                    couponLink = couponLink,
                    logoUrl = logoUrl,
                    rating = item.optInt("fiStoreRating", 0),
                    expiryDate = couponExpiry
                )
            )
        }

        adapter.notifyDataSetChanged()
    }

    // =========================================================
    // VISIBLE REWARDS
    // =========================================================

    private fun visibleRewards(): List<Reward> {

        return if (showActive) {
            activeRewards
        } else {
            upcomingRewards
        }
    }
    private fun loadActiveOffers() {
        android.util.Log.d(
            "MOBY_ACTIVE_API",
            "ACTIVE API CALLED"
        )

        MobyApi.getActiveOffers(
            affiliateId = affiliateId,
            appShortName = appShortName,
            secureKey = secureKey,
            userUnique = userUnique,
            gender = gender,
            age = age,
            deviceId = libraryDeviceId,

            onSuccess = { response ->

                android.util.Log.d(
                    "MOBY_ACTIVE_API",
                    "ACTIVE RESPONSE = $response"
                )

                setActiveOffers(response)

                isLoading = false
                showActive = true

                adapter.notifyDataSetChanged()
                applyTabs()

                pager.post {
                    pager.currentItem = 0
                }
            },

            onError = { error ->

                android.util.Log.e(
                    "MOBY_ACTIVE_API",
                    "ACTIVE ERROR = $error"
                )

                isLoading = false
                adapter.notifyDataSetChanged()
            }
        )
    }
    // =========================================================
    // DYNAMIC COLORS
    // =========================================================

    fun setColorCombination(
        value: RewardsColorCombination
    ) {

        theme = value

        setBackgroundColor(
            value.backgroundColor
        )

        applyHeader()
        applyTabs()

        adapter.notifyDataSetChanged()
    }

    fun setRewardCardColors(
        value: RewardsCardColors
    ) {

        cardColors = value

        adapter.notifyDataSetChanged()
    }

    fun setBackgroundColorDynamic(
        color: Int
    ) {

        theme = theme.copy(
            backgroundColor = color
        )

        setBackgroundColor(color)
    }

    fun setButtonColors(
        button: Int,
        text: Int
    ) {

        theme = theme.copy(
            buttonColor = button,
            buttonTextColor = text
        )

        adapter.notifyDataSetChanged()
    }

    fun setScratchColors(
        cover: Int,
        text: Int,
        background: Int
    ) {

        theme = theme.copy(
            scratchCoverColor = cover,
            scratchTextColor = text,
            scratchBackgroundColor = background
        )

        adapter.notifyDataSetChanged()
    }

    fun setTextColors(
        title: Int,
        description: Int,
        muted: Int
    ) {

        theme = theme.copy(
            titleTextColor = title,
            descriptionTextColor = description,
            mutedTextColor = muted
        )

        applyHeader()

        adapter.notifyDataSetChanged()
    }

    fun setTabColors(
        background: Int,
        active: Int,
        activeText: Int,
        inactiveText: Int
    ) {

        theme = theme.copy(
            tabBackgroundColor = background,
            activeTabColor = active,
            activeTabTextColor = activeText,
            inactiveTabTextColor = inactiveText
        )

        applyTabs()
    }

    fun setFont(
        typeface: Typeface
    ) {

        theme = theme.copy(
            typeface = typeface
        )

        applyHeader()

        adapter.notifyDataSetChanged()
    }

    // =========================================================
    // HEADER
    // =========================================================

    private fun applyHeader() {

        titleText.apply {

            setTextColor(
                theme.titleTextColor
            )

            textSize =
                theme.titleTextSize

            typeface =
                Typeface.create(
                    theme.typeface,
                    Typeface.BOLD
                )

            gravity =
                Gravity.START
        }

        subtitleText.apply {

            setTextColor(
                theme.descriptionTextColor
            )

            textSize =
                theme.descriptionTextSize

            typeface =
                theme.typeface

            gravity =
                Gravity.START
        }

        sectionText.apply {

            setTextColor(
                theme.titleTextColor
            )

            textSize =
                theme.sectionTextSize

            typeface =
                Typeface.create(
                    theme.typeface,
                    Typeface.BOLD
                )

            gravity =
                Gravity.START
        }
    }

    // =========================================================
    // TABS
    // =========================================================

    private fun applyTabs() {

        animateTab(
            pendingTab,
            selected = !showActive
        )

        animateTab(
            activeTab,
            selected = showActive
        )
    }

    private fun animateTab(
        view: TextView,
        selected: Boolean
    ) {

        val backgroundColor =
            if (selected)
                theme.activeTabColor
            else
                theme.tabBackgroundColor

        val textColor =
            if (selected)
                theme.activeTabTextColor
            else
                theme.inactiveTabTextColor

        val radius =
            dp(10).toFloat()

        view.background =
            GradientDrawable().apply {

                cornerRadii =
                    floatArrayOf(
                        radius,
                        radius,
                        radius,
                        radius,
                        radius,
                        radius,
                        radius,
                        radius
                    )

                setColor(
                    backgroundColor
                )
            }

        view.setTextColor(textColor)

        view.textSize =
            theme.bodyTextSize

        view.typeface =
            Typeface.create(
                theme.typeface,
                Typeface.BOLD
            )

        view.gravity =
            Gravity.CENTER

        view.animate().cancel()

        if (selected) {

            view.scaleX = 0.96f
            view.scaleY = 0.96f

            view.animate()
                .scaleX(1.04f)
                .scaleY(1.04f)
                .setDuration(120L)
                .withEndAction {

                    view.animate()
                        .scaleX(1f)
                        .scaleY(1f)
                        .setDuration(100L)
                        .start()
                }
                .start()

        } else {

            view.scaleX = 1f
            view.scaleY = 1f
        }

        view.translationY = 0f
        view.elevation = 0f
        view.alpha = 1f
    }

    // =========================================================
    // REWARD ADAPTER
    // =========================================================

    private inner class RewardAdapter :
        RecyclerView.Adapter<RewardAdapter.Holder>() {

        override fun onCreateViewHolder(
            parent: ViewGroup,
            viewType: Int
        ): Holder {

            val root =
                LinearLayout(context).apply {

                    orientation =
                        LinearLayout.VERTICAL

                    layoutParams =
                        ViewGroup.LayoutParams(
                            ViewGroup.LayoutParams.MATCH_PARENT,
                            ViewGroup.LayoutParams.MATCH_PARENT
                        )
                }

            return Holder(root)
        }

        override fun onBindViewHolder(
            holder: Holder,
            position: Int
        ) {

            if (isLoading) {
                holder.showSkeleton()
                return
            }

            val list = visibleRewards()

            if (position < list.size) {
                holder.bind(
                    list[position],
                    position
                )
            }
        }

        override fun getItemCount(): Int {

            return if (isLoading) {
                1
            } else {
                visibleRewards().size
            }
        }

        inner class Holder(
            private val root: LinearLayout
        ) : RecyclerView.ViewHolder(root) {

            fun showSkeleton() {

                root.removeAllViews()

                val skeleton = LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL

                    setPadding(
                        dp(12),
                        dp(12),
                        dp(12),
                        dp(12)
                    )

                    background = GradientDrawable().apply {
                        setColor(theme.cardBackgroundColor)
                        cornerRadius = dp(10).toFloat()
                        setStroke(
                            dp(1),
                            theme.cardBorderColor
                        )
                    }

                    layoutParams = LinearLayout.LayoutParams(
                        LayoutParams.MATCH_PARENT,
                        LayoutParams.WRAP_CONTENT
                    ).apply {
                        leftMargin = dp(6)
                        rightMargin = dp(6)
                        topMargin = dp(theme.cardTopMargin)
                        bottomMargin = dp(theme.cardBottomMargin)
                    }
                }

                // Product name skeleton
                val product = View(context).apply {
                    background = GradientDrawable().apply {
                        setColor(theme.infoBackgroundColor)
                        cornerRadius = dp(10).toFloat()
                    }
                }

                skeleton.addView(
                    product,
                    LinearLayout.LayoutParams(
                        LayoutParams.MATCH_PARENT,
                        dp(42)
                    )
                )

                // Scratch card skeleton
                val scratch = View(context).apply {
                    background = GradientDrawable().apply {
                        setColor(theme.scratchBackgroundColor)
                        cornerRadius = dp(10).toFloat()
                    }
                }

                skeleton.addView(
                    scratch,
                    LinearLayout.LayoutParams(
                        LayoutParams.MATCH_PARENT,
                        dp(205)
                    ).apply {
                        topMargin = dp(10)
                    }
                )

                root.addView(skeleton)
            }

            fun bind(
                reward: Reward,
                position: Int
            ) {

                root.removeAllViews()

                val card =
                    LinearLayout(context).apply {

                        orientation =
                            LinearLayout.VERTICAL

                        gravity =
                            Gravity.TOP

                        layoutParams =
                            LinearLayout.LayoutParams(
                                LayoutParams.MATCH_PARENT,
                                LayoutParams.WRAP_CONTENT
                            ).apply {

                                leftMargin =
                                    dp(6)

                                rightMargin =
                                    dp(6)

                                topMargin =
                                    dp(theme.cardTopMargin)

                                bottomMargin =
                                    dp(theme.cardBottomMargin)
                            }
                    }

                if (!reward.active) {

                    card.background =
                        GradientDrawable().apply {

                            setColor(
                                theme.cardBackgroundColor
                            )

                            cornerRadius =
                                dp(10).toFloat()

                            setStroke(
                                dp(1),
                                theme.cardBorderColor
                            )
                        }

                } else {

                    card.background = null
                }

                if (reward.active) {

                    createActiveCard(
                        card,
                        reward,
                        theme
                    )

                } else {

                    createUpcomingCard(
                        card,
                        reward,
                        theme
                    )
                }

                root.addView(card)

                addDots(
                    root,
                    position,
                    theme
                )
            }
        }
    }

    // =========================================================
    // UPCOMING CARD
    // =========================================================

    private fun createUpcomingCard(
        card: LinearLayout,
        reward: Reward,
        c: RewardsColorCombination
    ) {

        // =====================================================
        // OUTER UPCOMING CARD
        // =====================================================

        card.removeAllViews()

        card.orientation = LinearLayout.VERTICAL

        card.setPadding(
            dp(10),
            dp(10),
            dp(10),
            dp(10)
        )

        card.background = GradientDrawable().apply {
            setColor(c.tabBackgroundColor)
            cornerRadius = dp(11).toFloat()
        }
        // Shadow / Elevation
        card.elevation = dp(6).toFloat()

        // =====================================================
        // PRODUCT NAME
        // LEFT SIDE
        // =====================================================

        val productName = text(
            if (reward.productName.isNotBlank())
                reward.productName
            else
                reward.brand,
            c.bodyTextSize,
            c.titleTextColor,
            true
        )

        productName.gravity = Gravity.START

        productName.setPadding(
            dp(4),
            dp(2),
            dp(4),
            dp(6)
        )

        card.addView(
            productName,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            )
        )

        // =====================================================
        // ORANGE SCRATCH AREA
        // SAME OUTER CARD NI ANDAR
        // =====================================================

        val scratchContainer = FrameLayout(context).apply {

            background = GradientDrawable().apply {
                setColor(c.primaryColor)
                cornerRadius = dp(10).toFloat()
            }

            clipChildren = true
            clipToPadding = true
        }

        val preview = ScratchView(context)

        preview.setScratchColors(
            c.scratchCoverColor,
            c.scratchTextColor,
            c.scratchBackgroundColor,
            c.scratchIconColor
        )

        preview.setFont(
            c.typeface,
            c.bodyTextSize
        )

        preview.setInteractionEnabled(false)
        preview.setScratchTextVisible(false)

        scratchContainer.addView(
            preview,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                dp(257)
            )
        )

        card.addView(
            scratchContainer,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                dp(257)
            )
        )

        // =====================================================
        // CLICK
        // =====================================================

        card.setOnClickListener {

            if (!reward.scratched) {

                openScratchPopup(
                    reward,
                    card
                )
            }
        }
    }

    // =========================================================
    // SCRATCH POPUP
    // =========================================================

    private fun openScratchPopup(
        reward: Reward,
        sourceCard: View
    ) {

        val c = theme

        val overlay =
            FrameLayout(context).apply {

                setBackgroundColor(
                    android.graphics.Color.argb(
                        150,
                        0,
                        0,
                        0
                    )
                )

                elevation =
                    dp(100).toFloat()

                alpha = 1f
            }

        addView(
            overlay,
            LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT
            )
        )

        val popup =
            LinearLayout(context).apply {

                orientation =
                    LinearLayout.VERTICAL

                setPadding(
                    dp(14),
                    dp(10),
                    dp(14),
                    dp(14)
                )

                background =
                    GradientDrawable().apply {

                        setColor(
                            c.cardBackgroundColor
                        )

                        cornerRadius =
                            dp(11).toFloat()
                    }
            }

        // =====================================================
        // TOP BAR
        // =====================================================

        val topBar =
            FrameLayout(context)

        val productTitle =
            text(
                if (reward.productName.isNotBlank())
                    reward.productName
                else
                    reward.brand,
                c.bodyTextSize,
                c.titleTextColor,
                true
            )

        productTitle.gravity =
            Gravity.CENTER_VERTICAL

        topBar.addView(
            productTitle,
            FrameLayout.LayoutParams(
                LayoutParams.WRAP_CONTENT,
                dp(38),
                Gravity.START or
                        Gravity.CENTER_VERTICAL
            )
        )

        val close =
            TextView(context).apply {

                text = "✕"

                textSize = 17f

                setTextColor(
                    c.mutedTextColor
                )

                gravity =
                    Gravity.CENTER

                typeface =
                    c.typeface

                background =
                    GradientDrawable().apply {

                        setColor(
                            c.infoBackgroundColor
                        )

                        cornerRadius =
                            dp(8).toFloat()
                    }
            }

        topBar.addView(
            close,
            FrameLayout.LayoutParams(
                dp(34),
                dp(34),
                Gravity.END or
                        Gravity.CENTER_VERTICAL
            )
        )

        popup.addView(
            topBar,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                dp(38)
            )
        )

        // =====================================================
// SCRATCH + ACTIVE CARD REVEAL AREA
// =====================================================

        val revealContainer = FrameLayout(context)

        val activeCard =
            LinearLayout(context).apply {
                orientation = LinearLayout.VERTICAL
                visibility = View.VISIBLE
            }

        createActiveCard(
            activeCard,
            reward,
            c
        )

        revealContainer.addView(
            activeCard,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )
        )

        val scratch = ScratchView(context)

        scratch.setScratchColors(
            c.scratchCoverColor,
            c.scratchTextColor,
            c.scratchBackgroundColor,
            c.scratchIconColor
        )

        scratch.setFont(
            c.typeface,
            c.bodyTextSize
        )

        revealContainer.addView(
            scratch,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT
            )
        )

        popup.addView(
            revealContainer,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                dp(290)
            ).apply {
                topMargin = dp(10)
            }
        )


// =====================================================
// IF ALREADY SCRATCHED
// =====================================================

        if (reward.scratched) {

            scratch.visibility = View.GONE
            activeCard.visibility = View.VISIBLE
        }
        val popupWidth =
            (
                    resources.displayMetrics.widthPixels *
                            0.88f
                    ).toInt()

        overlay.addView(
            popup,
            FrameLayout.LayoutParams(
                popupWidth,
                LayoutParams.WRAP_CONTENT,
                Gravity.CENTER
            )
        )

        // =====================================================
        // SCRATCH COMPLETE
        // =====================================================
        scratch.onScratchComplete = {

            reward.scratched = true

            scratch.isEnabled = false
            scratch.visibility = View.GONE

            activeCard.visibility = View.VISIBLE

            revealContainer.post {

                val widthSpec = View.MeasureSpec.makeMeasureSpec(
                    revealContainer.width,
                    View.MeasureSpec.EXACTLY
                )

                val heightSpec = View.MeasureSpec.makeMeasureSpec(
                    0,
                    View.MeasureSpec.UNSPECIFIED
                )

                activeCard.measure(
                    widthSpec,
                    heightSpec
                )

                val fullHeight = activeCard.measuredHeight

                revealContainer.layoutParams =
                    revealContainer.layoutParams.apply {
                        height = fullHeight
                    }

                activeCard.layoutParams =
                    activeCard.layoutParams.apply {
                        height = fullHeight
                    }

                revealContainer.requestLayout()
                popup.requestLayout()
            }
        }

        // =====================================================
        // CLOSE
        // =====================================================

        close.setOnClickListener {


            if (!reward.scratched) {
                removeView(overlay)
                return@setOnClickListener
            }

            if (
                reward.adId > 0 &&
                storedFsToken.isNotBlank() &&
                storedFiUserId.isNotBlank()
            ) {

                MobyApi.directSubmitQuiz(
                    adId = reward.adId,
                    deviceUniqueId = 3,
                    token = storedFsToken,
                    userId = storedFiUserId,
                    userContact = libraryDeviceId,
                    deviceId = libraryDeviceId,
                    isPwa = "no",

                    onSuccess = {

                        loadActiveOffers()

                        removeView(overlay)
                    },

                    onError = {
                        // Keep popup open if submit fails.
                    }
                )

            } else {

                removeView(overlay)
            }
        }
    }

    // =========================================================
    // ACTIVE CARD
    // =========================================================

    private fun createActiveCard(
        card: LinearLayout,
        reward: Reward,
        c: RewardsColorCombination
    ) {

        card.removeAllViews()
        card.orientation = LinearLayout.VERTICAL

        // =====================================================
        // MAIN CARD
        // =====================================================

        card.background = GradientDrawable().apply {
            setColor(c.primaryColor)
            cornerRadius = dp(14).toFloat()
        }

        card.setPadding(
            dp(16),
            dp(14),
            dp(16),
            dp(12)
        )

        // =====================================================
        // TOP ROW
        // LOGO | BRAND + PRODUCT | RATING
        // =====================================================

        val topRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        // ---------------- LOGO ----------------

        val logo = ImageView(context).apply {
            scaleType = ImageView.ScaleType.CENTER_CROP

            background = GradientDrawable().apply {
                setColor(Color.BLACK)
                cornerRadius = dp(9).toFloat()
            }

            clipToOutline = true
        }

        topRow.addView(
            logo,
            LinearLayout.LayoutParams(
                dp(58),
                dp(58)
            )
        )

        loadLogo(
            logo,
            reward.logoUrl
        )

        // ---------------- BRAND + PRODUCT ----------------

        val brandProduct = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val brand = text(
            reward.brand,
            c.bodyTextSize,
            c.secondaryColor,
            true
        )

        brandProduct.addView(brand)

        if (reward.productName.isNotBlank()) {

            val product = text(
                reward.productName,
                c.smallTextSize,
                c.secondaryColor,
                false
            )

            brandProduct.addView(
                product,
                LinearLayout.LayoutParams(
                    LayoutParams.WRAP_CONTENT,
                    LayoutParams.WRAP_CONTENT
                ).apply {
                    topMargin = dp(2)
                }
            )
        }

        topRow.addView(
            brandProduct,
            LinearLayout.LayoutParams(
                0,
                LayoutParams.WRAP_CONTENT,
                1f
            ).apply {
                leftMargin = dp(12)
            }
        )

        // ---------------- RATING ----------------

        if (reward.rating > 0) {

            val rating = text(
                "🔥 ${reward.rating}",
                c.bodyTextSize,
                c.primaryColor,
                true
            )

            rating.gravity = Gravity.CENTER

            rating.setPadding(
                dp(11),
                dp(7),
                dp(11),
                dp(7)
            )

            rating.background = GradientDrawable().apply {
                setColor(c.secondaryColor)
                cornerRadius = dp(11).toFloat()
            }

            topRow.addView(
                rating,
                LinearLayout.LayoutParams(
                    LayoutParams.WRAP_CONTENT,
                    LayoutParams.WRAP_CONTENT
                ).apply {
                    gravity = Gravity.TOP
                }
            )
        }

        card.addView(
            topRow,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dp(0)
            }
        )

        // =====================================================
        // UNLOCKED MESSAGE
        // =====================================================

        val message = text(
            "🎉 You unlocked an exclusive offer!",
            c.smallTextSize,
            c.secondaryColor,
            false
        )

        card.addView(
            message,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dp(10)
                bottomMargin = dp(10)
            }
        )

        // =====================================================
        // CASHBACK / OFFER BOX
        // =====================================================

        val offerBox = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER

            setPadding(
                dp(10),
                dp(11),
                dp(10),
                dp(11)
            )

            background = GradientDrawable().apply {
                setColor(c.secondaryColor)
                cornerRadius = dp(11).toFloat()
            }
        }

        val cashbackText =
            if (reward.cashback.isNotBlank()) {
                "${reward.cashback} Cashback"
            } else {
                reward.offer
            }

        val cashback = text(
            cashbackText,
            c.titleTextSize,
            c.titleTextColor,
            true
        )

        cashback.gravity = Gravity.CENTER

        offerBox.addView(
            cashback,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            )
        )

        if (reward.discount.isNotBlank()) {

            val discount = text(
                "Discount Up to ${reward.discount}",
                c.smallTextSize,
                c.mutedTextColor,
                false
            )

            discount.gravity = Gravity.CENTER

            offerBox.addView(
                discount,
                LinearLayout.LayoutParams(
                    LayoutParams.MATCH_PARENT,
                    LayoutParams.WRAP_CONTENT
                ).apply {
                    topMargin = dp(3)
                }
            )
        }

        card.addView(
            offerBox,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            )
        )

        // =====================================================
        // COUPON BOX
        // =====================================================

        if (reward.code.isNotBlank()) {

            val couponBox = LinearLayout(context).apply {

                orientation = LinearLayout.HORIZONTAL
                gravity = Gravity.CENTER_VERTICAL

                setPadding(
                    dp(12),
                    dp(9),
                    dp(9),
                    dp(9)
                )

                background = createDottedBorder(
                    borderColor = c.secondaryColor,
                    fillColor = c.primaryColor,
                    radius = dp(8).toFloat()
                )
            }

            val coupon = text(
                reward.code,
                c.bodyTextSize,
                c.secondaryColor,
                true
            )

            coupon.gravity = Gravity.CENTER

            couponBox.addView(
                coupon,
                LinearLayout.LayoutParams(
                    0,
                    LayoutParams.WRAP_CONTENT,
                    1f
                )
            )

            val copy = text(
                "",
                c.bodyTextSize,
                c.secondaryColor,
                true
            )

            copy.gravity = Gravity.CENTER

            couponBox.addView(
                copy,
                LinearLayout.LayoutParams(
                    dp(30),
                    dp(30)
                )
            )

            card.addView(
                couponBox,
                LinearLayout.LayoutParams(
                    LayoutParams.MATCH_PARENT,
                    LayoutParams.WRAP_CONTENT
                ).apply {
                    topMargin = dp(10)
                }
            )
        }

        // =====================================================
        // BOTTOM ROW
        // DATE LEFT | SHOP NOW RIGHT
        // =====================================================

        val bottomRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL

            setPadding(
                dp(0),
                dp(9),
                dp(0),
                dp(0)
            )
        }

        // ---------------- DATE SECTION ----------------

        val expirySection = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val calendarIcon = ImageView(context).apply {
            setImageResource(
                com.mobyrewards.mobyrewards.R.drawable.ic_calendar
            )

            scaleType = ImageView.ScaleType.CENTER_INSIDE
        }

        expirySection.addView(
            calendarIcon,
            LinearLayout.LayoutParams(
                dp(22),
                dp(22)
            ).apply {
                rightMargin = dp(5)
            }
        )

        val expiry = text(
            if (reward.expiryDate.isNotBlank()) {
                reward.expiryDate
            } else {
                "-"
            },
            c.smallTextSize,
            c.secondaryColor,
            false
        )

        expiry.gravity = Gravity.CENTER_VERTICAL

        expirySection.addView(
            expiry,
            LinearLayout.LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
            )
        )

        bottomRow.addView(
            expirySection,
            LinearLayout.LayoutParams(
                0,
                LayoutParams.WRAP_CONTENT,
                1f
            )
        )

        // ---------------- SHOP NOW ----------------

        val shopNow = text(
            "SHOP NOW",
            c.buttonTextSize,
            c.buttonTextColor,
            true
        )

        shopNow.gravity = Gravity.CENTER

        shopNow.setPadding(
            dp(17),
            dp(9),
            dp(17),
            dp(9)
        )

        shopNow.background = GradientDrawable().apply {
            setColor(c.buttonColor)
            cornerRadius = dp(9).toFloat()
        }

        shopNow.setOnClickListener {

            if (reward.couponLink.isNotBlank()) {

                try {
                    context.startActivity(
                        Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse(reward.couponLink)
                        )
                    )
                } catch (_: Exception) {
                }
            }
        }

        bottomRow.addView(
            shopNow,
            LinearLayout.LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
            )
        )

        card.addView(
            bottomRow,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
            )
        )
    }
    // =========================================================
    // DOTS
    // =========================================================

    private fun addDots(
        parent: LinearLayout,
        position: Int,
        c: RewardsColorCombination
    ) {

        val dots =
            LinearLayout(context).apply {

                orientation =
                    LinearLayout.HORIZONTAL

                gravity =
                    Gravity.CENTER
            }

        val count =
            visibleRewards().size

        for (index in 0 until count) {

            val dot =
                TextView(context).apply {

                    text = "●"

                    textSize =
                        c.smallTextSize

                    setTextColor(
                        if (index == position)
                            c.activeTabColor
                        else
                            c.mutedTextColor
                    )

                    typeface =
                        c.typeface

                    setPadding(
                        dp(3),
                        0,
                        dp(3),
                        0
                    )
                }

            dots.addView(dot)
        }

        parent.addView(
            dots,
            LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                dp(c.dotsHeight)
            )
        )
    }

    // =========================================================
    // IMAGE LOADER
    // =========================================================

    private fun loadLogo(
        imageView: ImageView,
        url: String
    ) {

        if (url.isBlank()) return

        Thread {

            try {

                val connection =
                    URL(url).openConnection() as HttpURLConnection

                connection.connectTimeout = 10000
                connection.readTimeout = 10000
                connection.doInput = true
                connection.connect()

                val bitmap =
                    connection.inputStream.use {
                        BitmapFactory.decodeStream(it)
                    }

                connection.disconnect()

                if (bitmap != null) {

                    imageView.post {
                        imageView.setImageBitmap(bitmap)
                    }
                }

            } catch (_: Exception) {
            }
        }.start()
    }

    // =========================================================
    // TEXT HELPERS
    // =========================================================

    private fun text(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean
    ): TextView {

        return TextView(context).apply {

            text = value

            textSize = size

            setTextColor(color)

            typeface =
                Typeface.create(
                    theme.typeface,
                    if (bold)
                        Typeface.BOLD
                    else
                        Typeface.NORMAL
                )
        }
    }

    private fun textView(
        value: String
    ): TextView {

        return TextView(context).apply {
            text = value
        }
    }

    private fun createDottedBorder(
        borderColor: Int,
        fillColor: Int,
        radius: Float
    ): Drawable {

        return object : Drawable() {

            private val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                style = Paint.Style.FILL
                color = fillColor
            }

            private val borderPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                style = Paint.Style.STROKE
                strokeWidth = dp(1).toFloat()
                color = borderColor
                isAntiAlias = true

                pathEffect = android.graphics.DashPathEffect(
                    floatArrayOf(
                        dp(3).toFloat(),
                        dp(3).toFloat()
                    ),
                    0f
                )
            }

            override fun draw(canvas: Canvas) {

                val inset = dp(2).toFloat()

                val rect = RectF(
                    bounds.left.toFloat() + inset,
                    bounds.top.toFloat() + inset,
                    bounds.right.toFloat() - inset,
                    bounds.bottom.toFloat() - inset
                )

                canvas.drawRoundRect(
                    rect,
                    radius,
                    radius,
                    fillPaint
                )

                canvas.drawRoundRect(
                    rect,
                    radius,
                    radius,
                    borderPaint
                )
            }

            override fun setAlpha(alpha: Int) {
                fillPaint.alpha = alpha
                borderPaint.alpha = alpha
            }

            override fun setColorFilter(
                colorFilter: android.graphics.ColorFilter?
            ) {
                fillPaint.colorFilter = colorFilter
                borderPaint.colorFilter = colorFilter
            }

            override fun getOpacity(): Int {
                return PixelFormat.TRANSLUCENT
            }
        }
    }

    private fun dp(
        value: Int
    ): Int {

        return (
                value *
                        resources.displayMetrics.density
                ).toInt()
    }

    // =========================================================
    // REWARD MODEL
    // =========================================================

    private data class Reward(

        val brand: String,

        val offer: String,

        val productName: String = "",

        val adId: Int = 0,

        val cashback: String = "",

        val discount: String = "",

        val offerLeft: Int = 0,

        var active: Boolean = false,

        var scratched: Boolean = false,

        val code: String = "",

        val couponLink: String = "",

        val logoUrl: String = "",

        val rating: Int = 0,

        val couponCode: String = "",

        val scratchDate: String = "",

        val expiryDate: String = ""
    )
}