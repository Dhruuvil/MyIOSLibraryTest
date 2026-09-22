
package com.mobyrewards.mobyrewards

import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View

class ScratchView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null
) : View(context, attrs) {

    private var bitmap: Bitmap? = null
    private var scratchCanvas: Canvas? = null

    private var coverColor = 0
    private var textColor = 0
    private var iconColor = 0
    private var backgroundColor = 0

    private var scratchText = "SCRATCH TO REVEAL"
    private var showScratchText = true

    private var typeface: Typeface? = null
    private var textSize = 0f

    private var lastX = 0f
    private var lastY = 0f

    private var completed = false
    private var scratching = false
    private var interactionEnabled = true

    private val coverPaint =
        Paint(Paint.ANTI_ALIAS_FLAG)

    private val scratchPaint =
        Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
            xfermode = PorterDuffXfermode(
                PorterDuff.Mode.CLEAR
            )
        }

    var onScratchStart: (() -> Unit)? = null
    var onScratchEnd: (() -> Unit)? = null
    var onScratchComplete: (() -> Unit)? = null

    init {
        setLayerType(
            LAYER_TYPE_SOFTWARE,
            null
        )
    }

    override fun onSizeChanged(
        width: Int,
        height: Int,
        oldWidth: Int,
        oldHeight: Int
    ) {
        createLayer(width, height)
    }

    private fun createLayer(
        width: Int,
        height: Int
    ) {
        if (width <= 0 || height <= 0) return

        bitmap = Bitmap.createBitmap(
            width,
            height,
            Bitmap.Config.ARGB_8888
        )

        scratchCanvas = Canvas(bitmap!!)

        coverPaint.color = coverColor

        scratchCanvas?.drawRect(
            0f,
            0f,
            width.toFloat(),
            height.toFloat(),
            coverPaint
        )

        drawRewardIcons()
    }

    private fun drawRewardIcons() {

        val c = scratchCanvas ?: return

        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = iconColor
            style = Paint.Style.STROKE
            strokeWidth = dp(2.5f)
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
        }

        val softPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = iconColor
            alpha = 55
            style = Paint.Style.FILL
        }

        // =====================================================
        // TOP + SIDE ICONS
        // =====================================================

        // Top-left circle
        c.drawCircle(
            width * 0.14f,
            height * 0.18f,
            dp(12f),
            softPaint
        )

        c.drawCircle(
            width * 0.14f,
            height * 0.18f,
            dp(12f),
            paint
        )

        // Top-center star
        drawStar(
            c,
            width * 0.50f,
            height * 0.14f,
            dp(12f),
            paint
        )

        // Top-right small gift
        drawSmallGift(
            c,
            width * 0.84f,
            height * 0.20f,
            paint
        )

        // Left plus
        c.drawLine(
            width * 0.22f - dp(9f),
            height * 0.46f,
            width * 0.22f + dp(9f),
            height * 0.46f,
            paint
        )

        c.drawLine(
            width * 0.22f,
            height * 0.46f - dp(9f),
            width * 0.22f,
            height * 0.46f + dp(9f),
            paint
        )

        // Right circle
        c.drawCircle(
            width * 0.78f,
            height * 0.46f,
            dp(12f),
            paint
        )

        // =====================================================
        // BOTTOM 3 ICONS
        // =====================================================

        // Bottom-left star
        drawStar(
            c,
            width * 0.14f,
            height * 0.78f,
            dp(12f),
            paint
        )

        // Bottom-center small gift
        drawSmallGift(
            c,
            width * 0.50f,
            height * 0.84f,
            paint
        )

        // Bottom-right plus
        c.drawLine(
            width * 0.86f - dp(9f),
            height * 0.78f,
            width * 0.86f + dp(9f),
            height * 0.78f,
            paint
        )

        c.drawLine(
            width * 0.86f,
            height * 0.78f - dp(9f),
            width * 0.86f,
            height * 0.78f + dp(9f),
            paint
        )

        // =====================================================
        // MAIN GIFT CIRCLE
        // =====================================================

        val mainCircle =
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                color = iconColor
                alpha = 65
            }

        val centerX = width / 2f
        val centerY = height / 2f

        c.drawCircle(
            centerX,
            centerY - dp(10f),
            dp(52f),
            mainCircle
        )

        // =====================================================
        // MAIN GIFT
        // =====================================================

        val gift =
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                color = textColor
                style = Paint.Style.STROKE
                strokeWidth = dp(4f)
                strokeCap = Paint.Cap.ROUND
                strokeJoin = Paint.Join.ROUND
            }

        val left = centerX - dp(24f)
        val right = centerX + dp(24f)
        val top = centerY - dp(32f)
        val bottom = centerY + dp(18f)

        c.drawRect(
            left,
            top + dp(10f),
            right,
            bottom,
            gift
        )

        c.drawLine(
            centerX,
            top + dp(10f),
            centerX,
            bottom,
            gift
        )

        c.drawLine(
            left - dp(3f),
            top + dp(10f),
            right + dp(3f),
            top + dp(10f),
            gift
        )

        c.drawArc(
            RectF(
                centerX - dp(18f),
                top - dp(8f),
                centerX,
                top + dp(12f)
            ),
            180f,
            180f,
            false,
            gift
        )

        c.drawArc(
            RectF(
                centerX,
                top - dp(8f),
                centerX + dp(18f),
                top + dp(12f)
            ),
            180f,
            180f,
            false,
            gift
        )


    }

    private fun drawSmallGift(
        c: Canvas,
        x: Float,
        y: Float,
        paint: Paint
    ) {
        val size = dp(10f)

        c.drawRect(
            x - size,
            y - size + dp(4f),
            x + size,
            y + size,
            paint
        )

        c.drawLine(
            x,
            y - size + dp(4f),
            x,
            y + size,
            paint
        )

        c.drawLine(
            x - size - dp(2f),
            y - size + dp(4f),
            x + size + dp(2f),
            y - size + dp(4f),
            paint
        )
    }

    private fun drawStar(
        c: Canvas,
        x: Float,
        y: Float,
        radius: Float,
        paint: Paint
    ) {
        val path = Path()

        for (i in 0 until 10) {

            val angle =
                Math.toRadians(
                    (-90 + i * 36).toDouble()
                )

            val r =
                if (i % 2 == 0)
                    radius
                else
                    radius * 0.42f

            val px =
                x + (Math.cos(angle) * r).toFloat()

            val py =
                y + (Math.sin(angle) * r).toFloat()

            if (i == 0)
                path.moveTo(px, py)
            else
                path.lineTo(px, py)
        }

        path.close()
        c.drawPath(path, paint)
    }

    override fun onDraw(canvas: Canvas) {

        canvas.drawColor(
            Color.TRANSPARENT,
            PorterDuff.Mode.CLEAR
        )

        val radius = dp(16f)

        val path = Path().apply {
            addRoundRect(
                RectF(
                    0f,
                    0f,
                    width.toFloat(),
                    height.toFloat()
                ),
                radius,
                radius,
                Path.Direction.CW
            )
        }

        canvas.save()

        canvas.clipPath(path)

        bitmap?.let {
            canvas.drawBitmap(
                it,
                0f,
                0f,
                null
            )
        }

        canvas.restore()
    }

    override fun onTouchEvent(
        event: MotionEvent
    ): Boolean {

        if (!interactionEnabled) return false

        if (completed) return true

        when (event.actionMasked) {

            MotionEvent.ACTION_DOWN -> {

                scratching = true

                parent?.requestDisallowInterceptTouchEvent(
                    true
                )

                lastX = event.x
                lastY = event.y

                onScratchStart?.invoke()

                scratchPaint.strokeWidth =
                    dp(55f)

                scratchCanvas?.drawCircle(
                    event.x,
                    event.y,
                    dp(27f),
                    scratchPaint
                )

                invalidate()

                return true
            }

            MotionEvent.ACTION_MOVE -> {

                scratchCanvas?.drawLine(
                    lastX,
                    lastY,
                    event.x,
                    event.y,
                    scratchPaint
                )

                lastX = event.x
                lastY = event.y

                invalidate()

                // 10% scratched = Active
                if (scratchPercentage() >= 50f) {
                    completeScratch()
                }

                return true
            }

            MotionEvent.ACTION_UP,
            MotionEvent.ACTION_CANCEL -> {

                scratching = false

                parent?.requestDisallowInterceptTouchEvent(
                    false
                )

                if (!completed) {
                    onScratchEnd?.invoke()
                }

                return true
            }
        }

        return true
    }

    private fun scratchPercentage(): Float {

        val b = bitmap ?: return 0f

        var total = 0
        var scratched = 0

        val step = 6

        var y = 0

        while (y < b.height) {

            var x = 0

            while (x < b.width) {

                total++

                if (
                    Color.alpha(
                        b.getPixel(x, y)
                    ) < 40
                ) {
                    scratched++
                }

                x += step
            }

            y += step
        }

        if (total == 0) return 0f

        return scratched.toFloat() /
                total.toFloat() * 100f
    }

    private fun completeScratch() {

        if (completed) return

        completed = true
        scratching = false
        interactionEnabled = false
        isEnabled = false

        parent?.requestDisallowInterceptTouchEvent(
            false
        )

        bitmap?.eraseColor(
            Color.TRANSPARENT
        )

        invalidate()

        onScratchComplete?.invoke()
    }

    fun setInteractionEnabled(enabled: Boolean) {
        interactionEnabled = enabled
    }

    fun setScratchTextVisible(visible: Boolean) {
        showScratchText = visible

        if (!completed) {
            createLayer(width, height)
            invalidate()
        }
    }

    fun resetScratch() {

        completed = false
        scratching = false
        interactionEnabled = true

        createLayer(
            width,
            height
        )

        invalidate()
    }

    fun setScratchColors(
        cover: Int,
        text: Int,
        background: Int,
        icon: Int
    ) {

        coverColor = cover
        textColor = text
        backgroundColor = background
        iconColor = icon

        if (!completed) {

            createLayer(
                width,
                height
            )

            invalidate()
        }
    }

    fun setScratchText(
        text: String
    ) {

        scratchText = text

        if (!completed) {

            createLayer(
                width,
                height
            )

            invalidate()
        }
    }

    fun setFont(
        font: Typeface,
        size: Float
    ) {

        typeface = font
        textSize = size

        if (!completed) {

            createLayer(
                width,
                height
            )

            invalidate()
        }
    }

    private fun dp(
        value: Float
    ): Float {
        return value *
                resources.displayMetrics.density
    }
}

