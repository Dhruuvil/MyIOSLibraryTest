package com.mobyrewards.mobyrewards

import android.graphics.Color
import android.graphics.Typeface

data class RewardsColorCombination(

    // =========================
    // MAIN COLORS
    // =========================

    val backgroundColor: Int = Color.parseColor("#F7F8FC"),
    val primaryColor: Int = Color.parseColor("#FF6B35"),
    val secondaryColor: Int = Color.parseColor("#4D67E8"),

    // =========================
    // CARD
    // =========================

    val cardBackgroundColor: Int = Color.WHITE,
    val cardBorderColor: Int = Color.parseColor("#E5E7EB"),
    val cardShadowColor: Int = Color.parseColor("#22000000"),

    // =========================
    // TEXT
    // =========================

    val titleTextColor: Int = Color.parseColor("#111827"),
    val descriptionTextColor: Int = Color.parseColor("#4B5563"),
    val mutedTextColor: Int = Color.parseColor("#9CA3AF"),

    // =========================
    // TABS
    // =========================

    val tabBackgroundColor: Int = Color.parseColor("#EDEFF3"),
    val activeTabColor: Int = Color.parseColor("#FF6B35"),
    val activeTabTextColor: Int = Color.WHITE,
    val inactiveTabTextColor: Int = Color.parseColor("#6B7280"),

    // =========================
    // SCRATCH
    // =========================

    val scratchCoverColor: Int = Color.parseColor("#FF6B35"),
    val scratchTextColor: Int = Color.WHITE,
    val scratchBackgroundColor: Int = Color.parseColor("#FFF3EE"),
    val scratchIconColor: Int = Color.WHITE,

    // =========================
    // BUTTON
    // =========================

    val buttonColor: Int = Color.parseColor("#123B3A"),
    val buttonTextColor: Int = Color.WHITE,

    // =========================
    // BADGE
    // =========================

    val badgeBackgroundColor: Int = Color.parseColor("#FFF0E8"),
    val badgeTextColor: Int = Color.parseColor("#FF6B35"),

    // =========================
    // INFO
    // =========================

    val infoBackgroundColor: Int = Color.parseColor("#F3F4F6"),
    val infoIconBackgroundColor: Int = Color.parseColor("#E5E7EB"),
    val infoTextColor: Int = Color.parseColor("#374151"),

    // =========================
    // BORDER
    // =========================

    val borderColor: Int = Color.parseColor("#E5E7EB"),

    // =========================
    // SHADOW
    // =========================

    val shadowColor: Int = Color.parseColor("#22000000"),
    val shadowRadius: Float = 8f,
    val shadowDx: Float = 0f,
    val shadowDy: Float = 4f,

    // =========================
    // FONT
    // =========================

    val typeface: Typeface = Typeface.create(
        "sans-serif",
        Typeface.NORMAL
    ),

    // =========================
    // TEXT SIZES
    // =========================

    val titleTextSize: Float = 24f,
    val descriptionTextSize: Float = 13f,
    val sectionTextSize: Float = 16f,
    val bodyTextSize: Float = 13f,
    val buttonTextSize: Float = 13f,
    val smallTextSize: Float = 11f,

    // =========================
    // SCREEN SPACING
    // =========================

    val screenPaddingLeft: Int = 16,
    val screenPaddingTop: Int = 12,
    val screenPaddingRight: Int = 16,
    val screenPaddingBottom: Int = 8,

    val subtitleTopMargin: Int = 2,

    // =========================
    // TABS / HEADER LAYOUT
    // =========================

    val tabsTopMargin: Int = 10,
    val tabsHeight: Int = 46,
    val tabHeight: Int = 44,
    val tabSpacing: Int = 5,
    val tabRadius: Int = 10,

    val sectionTopMargin: Int = 15,
    val sectionBottomMargin: Int = 10,
    val pagerTopMargin: Int = 2,

    // =========================
    // GENERAL CARD LAYOUT
    // =========================

    val cardSideMargin: Int = 6,
    val cardTopMargin: Int = 4,
    val cardBottomMargin: Int = 4,
    val cardRadius: Int = 10,
    val cardBorderWidth: Int = 1,

    // =========================
    // SKELETON
    // =========================

    val skeletonPadding: Int = 12,
    val skeletonRadius: Int = 10,
    val skeletonItemRadius: Int = 10,
    val skeletonProductHeight: Int = 42,
    val skeletonScratchHeight: Int = 205,
    val skeletonScratchTopMargin: Int = 10,

    // =========================
    // UPCOMING CARD
    // =========================

    val upcomingCardPadding: Int = 12,
    val upcomingProductPaddingHorizontal: Int = 10,
    val upcomingProductPaddingVertical: Int = 8,
    val upcomingProductRadius: Int = 10,
    val upcomingPreviewHeight: Int = 205,
    val upcomingPreviewTopMargin: Int = 10,

    // =========================
    // POPUP
    // =========================

    val popupOverlayColor: Int = Color.argb(150, 0, 0, 0),
    val popupElevation: Float = 100f,
    val popupWidthFraction: Float = 0.88f,

    val popupPaddingLeft: Int = 14,
    val popupPaddingTop: Int = 10,
    val popupPaddingRight: Int = 14,
    val popupPaddingBottom: Int = 14,
    val popupRadius: Int = 10,

    val popupTopBarHeight: Int = 38,
    val popupCloseSize: Int = 34,
    val popupCloseTextSize: Float = 17f,
    val popupCloseRadius: Int = 8,

    val popupScratchHeight: Int = 220,
    val popupScratchTopMargin: Int = 10,
    val popupActiveCardTopMargin: Int = 8,

    // =========================
    // ACTIVE CARD
    // =========================

    val activeCardPadding: Int = 14,
    val activeCardRadius: Int = 16,

    val activeLogoSize: Int = 50,
    val activeLogoRadius: Int = 11,

    val activeBrandInfoPaddingLeft: Int = 10,
    val activeBrandInfoPaddingRight: Int = 8,
    val activeProductTopMargin: Int = 3,

    val ratingPaddingHorizontal: Int = 8,
    val ratingPaddingVertical: Int = 5,
    val ratingRadius: Int = 9,

    val unlockedMessageTopMargin: Int = 12,
    val unlockedMessageBottomMargin: Int = 10,

    val offerBoxPaddingHorizontal: Int = 12,
    val offerBoxPaddingVertical: Int = 13,
    val offerBoxRadius: Int = 13,

    val smallBlockTopMargin: Int = 4,

    val couponPaddingHorizontal: Int = 10,
    val couponPaddingVertical: Int = 8,
    val couponRadius: Int = 10,
    val couponLabelTopMargin: Int = 10,
    val couponCodeTopMargin: Int = 4,

    val shopPaddingHorizontal: Int = 16,
    val shopPaddingVertical: Int = 10,
    val shopRadius: Int = 11,
    val bottomRowTopMargin: Int = 11,

    // =========================
    // DOTS
    // =========================

    val dotsHeight: Int = 28,
    val dotHorizontalPadding: Int = 3
)
