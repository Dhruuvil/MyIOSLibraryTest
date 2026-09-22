package com.mobyrewards.myapplication

import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import androidx.activity.ComponentActivity
import com.mobyrewards.mobyrewards.RewardsColorCombination
import com.mobyrewards.mobyrewards.RewardsView

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val rewardsView = RewardsView(this)

        // =========================================================
        // APP -> REWARDS VIEW
        // Current library values are passed from App
        // =========================================================

        rewardsView.setColorCombination(
            RewardsColorCombination(

                // MAIN COLORS
                backgroundColor = Color.WHITE,
                primaryColor = Color.parseColor("#ff6b35"),
                secondaryColor = Color.WHITE,

                // CARD
                cardBackgroundColor = Color.WHITE,
                cardBorderColor = Color.parseColor("#E5E7EB"),
                cardShadowColor = Color.parseColor("#22000000"),

                // TEXT
                titleTextColor = Color.BLACK,
                descriptionTextColor = Color.DKGRAY,
                mutedTextColor = Color.GRAY,

                // TABS
                tabBackgroundColor = Color.parseColor("#EDEFF3"),
                activeTabColor = Color.parseColor("#ff6b35"),
                activeTabTextColor = Color.WHITE,
                inactiveTabTextColor = Color.parseColor("#6B7280"),

                // SCRATCH
                scratchCoverColor = Color.parseColor("#ff6b35"),
                scratchTextColor = Color.WHITE,
                scratchBackgroundColor = Color.parseColor("#FFF3EE"),
                scratchIconColor = Color.WHITE,

                // BUTTON
                buttonColor = Color.WHITE,
                buttonTextColor = Color.parseColor("#ff6b35"),

                // BADGE
                badgeBackgroundColor = Color.parseColor("#FFF0E8"),
                badgeTextColor = Color.parseColor("#007FFF"),

                // INFO
                infoBackgroundColor = Color.parseColor("#F3F4F6"),
                infoIconBackgroundColor = Color.parseColor("#E5E7EB"),
                infoTextColor = Color.parseColor("#374151"),

                // BORDER
                borderColor = Color.parseColor("#E5E7EB"),

                // SHADOW
                shadowColor = Color.parseColor("#22000000"),
                shadowRadius = 8f,
                shadowDx = 0f,
                shadowDy = 4f,

                // FONT
                typeface = Typeface.DEFAULT,

                // TEXT SIZES
                titleTextSize = 24f,
                descriptionTextSize = 13f,
                sectionTextSize = 16f,
                bodyTextSize = 13f,
                buttonTextSize = 13f,
                smallTextSize = 11f,

                // SCREEN SPACING
                screenPaddingLeft = 16,
                screenPaddingTop = 12,
                screenPaddingRight = 16,
                screenPaddingBottom = 8,
                subtitleTopMargin = 2,

                // TABS / HEADER
                tabsTopMargin = 10,
                tabsHeight = 46,
                tabHeight = 44,
                tabSpacing = 5,
                tabRadius = 10,
                sectionTopMargin = 15,
                sectionBottomMargin = 10,
                pagerTopMargin = 2,

                // CARD
                cardSideMargin = 6,
                cardTopMargin = 4,
                cardBottomMargin = 4,
                cardRadius = 10,
                cardBorderWidth = 1,

                // SKELETON
                skeletonPadding = 12,
                skeletonRadius = 10,
                skeletonItemRadius = 10,
                skeletonProductHeight = 42,
                skeletonScratchHeight = 205,
                skeletonScratchTopMargin = 10,

                // UPCOMING
                upcomingCardPadding = 12,
                upcomingProductPaddingHorizontal = 10,
                upcomingProductPaddingVertical = 8,
                upcomingProductRadius = 10,
                upcomingPreviewHeight = 205,
                upcomingPreviewTopMargin = 10,

                // POPUP
                popupOverlayColor = Color.argb(150, 0, 0, 0),
                popupElevation = 100f,
                popupWidthFraction = 0.88f,
                popupPaddingLeft = 14,
                popupPaddingTop = 10,
                popupPaddingRight = 14,
                popupPaddingBottom = 14,
                popupRadius = 10,
                popupTopBarHeight = 38,
                popupCloseSize = 34,
                popupCloseTextSize = 17f,
                popupCloseRadius = 8,
                popupScratchHeight = 220,
                popupScratchTopMargin = 10,
                popupActiveCardTopMargin = 8,

                // ACTIVE CARD
                activeCardPadding = 14,
                activeCardRadius = 16,
                activeLogoSize = 50,
                activeLogoRadius = 11,
                activeBrandInfoPaddingLeft = 10,
                activeBrandInfoPaddingRight = 8,
                activeProductTopMargin = 3,
                ratingPaddingHorizontal = 8,
                ratingPaddingVertical = 5,
                ratingRadius = 9,
                unlockedMessageTopMargin = 12,
                unlockedMessageBottomMargin = 10,
                offerBoxPaddingHorizontal = 12,
                offerBoxPaddingVertical = 13,
                offerBoxRadius = 13,
                smallBlockTopMargin = 4,
                couponPaddingHorizontal = 10,
                couponPaddingVertical = 8,
                couponRadius = 10,
                couponLabelTopMargin = 10,
                couponCodeTopMargin = 4,
                shopPaddingHorizontal = 16,
                shopPaddingVertical = 10,
                shopRadius = 11,
                bottomRowTopMargin = 11,

                // DOTS
                dotsHeight = 28,
                dotHorizontalPadding = 3
            )
        )

        // =========================================================
        // API CONFIG — SAME AS YOUR CURRENT CODE
        // =========================================================

        rewardsView.setApiConfig(
            affiliateId = "MOBY_7",
            appShortName = "MBY",
            secureKey = "ztxwjmch",
            userUnique = "91367682460",
            gender = "male",
            age = 30
        )

        setContentView(rewardsView)
    }
}