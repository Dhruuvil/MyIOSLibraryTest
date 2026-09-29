import UIKit

public class ScratchView: UIView {

    // MARK: - Properties
    private var scratchImage: UIImage?
    private var lastPoint: CGPoint = .zero

    private var coverColor: UIColor = UIColor(hex: "#FF6B35")
    private var textColor: UIColor = .white
    private var iconColor: UIColor = .white
    private var scratchBackgroundColor: UIColor = UIColor(hex: "#FFF3EE")

    private var scratchText: String = "SCRATCH TO REVEAL"
    private var showScratchText: Bool = true

    private var fontName: String = ""
    private var textSize: CGFloat = 13.0

    private var completed: Bool = false
    private var scratching: Bool = false
    private var interactionEnabled: Bool = true

    public var onScratchStart: (() -> Void)?
    public var onScratchEnd: (() -> Void)?
    public var onScratchComplete: (() -> Void)?

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        isOpaque = false
        layer.cornerRadius = 16.0
        layer.masksToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if scratchImage == nil && bounds.width > 0 && bounds.height > 0 && !completed {
            createLayer(width: bounds.width, height: bounds.height)
        }
    }

    // MARK: - Layer Creation
    private func createLayer(width: CGFloat, height: CGFloat) {
        guard width > 0, height > 0 else { return }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Draw cover background
        context.setFillColor(coverColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        // Draw decorative icons
        drawRewardIcons(in: context, width: width, height: height)

        scratchImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    private func drawRewardIcons(in context: CGContext, width: CGFloat, height: CGFloat) {
        let strokeColor = iconColor.cgColor
        let softColor = iconColor.withAlphaComponent(0.22).cgColor

        context.setLineWidth(2.5)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        // 1. Top-left soft circle
        context.setFillColor(softColor)
        context.addEllipse(in: CGRect(x: width * 0.14 - 12, y: height * 0.18 - 12, width: 24, height: 24))
        context.fillPath()

        context.setStrokeColor(strokeColor)
        context.addEllipse(in: CGRect(x: width * 0.14 - 12, y: height * 0.18 - 12, width: 24, height: 24))
        context.strokePath()

        // 2. Top-center star
        drawStar(in: context, cx: width * 0.50, cy: height * 0.14, radius: 12)

        // 3. Top-right small gift
        drawSmallGift(in: context, cx: width * 0.84, cy: height * 0.20)

        // 4. Left plus
        context.setStrokeColor(strokeColor)
        context.move(to: CGPoint(x: width * 0.22 - 9, y: height * 0.46))
        context.addLine(to: CGPoint(x: width * 0.22 + 9, y: height * 0.46))
        context.move(to: CGPoint(x: width * 0.22, y: height * 0.46 - 9))
        context.addLine(to: CGPoint(x: width * 0.22, y: height * 0.46 + 9))
        context.strokePath()

        // 5. Right circle
        context.addEllipse(in: CGRect(x: width * 0.78 - 12, y: height * 0.46 - 12, width: 24, height: 24))
        context.strokePath()

        // 6. Bottom-left star
        drawStar(in: context, cx: width * 0.14, cy: height * 0.78, radius: 12)

        // 7. Bottom-center small gift
        drawSmallGift(in: context, cx: width * 0.50, cy: height * 0.84)

        // 8. Bottom-right plus
        context.move(to: CGPoint(x: width * 0.86 - 9, y: height * 0.78))
        context.addLine(to: CGPoint(x: width * 0.86 + 9, y: height * 0.78))
        context.move(to: CGPoint(x: width * 0.86, y: height * 0.78 - 9))
        context.addLine(to: CGPoint(x: width * 0.86, y: height * 0.78 + 9))
        context.strokePath()

        // 9. Main gift circle background
        let mainCircleColor = iconColor.withAlphaComponent(0.25).cgColor
        let centerX = width / 2.0
        let centerY = height / 2.0
        context.setFillColor(mainCircleColor)
        context.addEllipse(in: CGRect(x: centerX - 52, y: centerY - 10 - 52, width: 104, height: 104))
        context.fillPath()

        // 10. Main gift box
        context.setStrokeColor(textColor.cgColor)
        context.setLineWidth(4.0)

        let left = centerX - 24
        let right = centerX + 24
        let top = centerY - 32
        let bottom = centerY + 18

        // Box rectangle
        context.stroke(CGRect(x: left, y: top + 10, width: right - left, height: bottom - (top + 10)))

        // Center line
        context.move(to: CGPoint(x: centerX, y: top + 10))
        context.addLine(to: CGPoint(x: centerX, y: bottom))
        context.strokePath()

        // Lid top bar
        context.move(to: CGPoint(x: left - 3, y: top + 10))
        context.addLine(to: CGPoint(x: right + 3, y: top + 10))
        context.strokePath()

        // Bow arcs
        context.addArc(center: CGPoint(x: centerX - 9, y: top + 2), radius: 9, startAngle: 0, endAngle: .pi, clockwise: true)
        context.strokePath()

        context.addArc(center: CGPoint(x: centerX + 9, y: top + 2), radius: 9, startAngle: 0, endAngle: .pi, clockwise: true)
        context.strokePath()
    }

    private func drawSmallGift(in context: CGContext, cx: CGFloat, cy: CGFloat) {
        let size: CGFloat = 10.0
        let strokeColor = iconColor.cgColor
        context.setStrokeColor(strokeColor)
        context.setLineWidth(2.5)

        context.stroke(CGRect(x: cx - size, y: cy - size + 4, width: size * 2, height: size * 2 - 4))

        context.move(to: CGPoint(x: cx, y: cy - size + 4))
        context.addLine(to: CGPoint(x: cx, y: cy + size))
        context.strokePath()

        context.move(to: CGPoint(x: cx - size - 2, y: cy - size + 4))
        context.addLine(to: CGPoint(x: cx + size + 2, y: cy - size + 4))
        context.strokePath()
    }

    private func drawStar(in context: CGContext, cx: CGFloat, cy: CGFloat, radius: CGFloat) {
        let path = CGMutablePath()
        for i in 0..<10 {
            let angle = CGFloat(-90 + i * 36) * .pi / 180.0
            let r: CGFloat = (i % 2 == 0) ? radius : (radius * 0.42)
            let px = cx + cos(angle) * r
            let py = cy + sin(angle) * r
            if i == 0 {
                path.move(to: CGPoint(x: px, y: py))
            } else {
                path.addLine(to: CGPoint(x: px, y: py))
            }
        }
        path.closeSubpath()
        context.setStrokeColor(iconColor.cgColor)
        context.setLineWidth(2.5)
        context.addPath(path)
        context.strokePath()
    }

    // MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        guard let scratchImage = scratchImage else { return }
        scratchImage.draw(in: rect)
    }

    // MARK: - Touch Handling
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard interactionEnabled, !completed, let touch = touches.first else { return }
        scratching = true
        lastPoint = touch.location(in: self)
        onScratchStart?()

        eraseLine(from: lastPoint, to: lastPoint)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard interactionEnabled, !completed, scratching, let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        eraseLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint

        if scratchPercentage() >= 50.0 {
            completeScratch()
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard scratching else { return }
        scratching = false
        if !completed {
            onScratchEnd?()
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    // MARK: - Erase Line
    private func eraseLine(from startPoint: CGPoint, to endPoint: CGPoint) {
        guard let currentImage = scratchImage else { return }
        let size = bounds.size
        guard size.width > 0, size.height > 0 else { return }

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        currentImage.draw(in: CGRect(origin: .zero, size: size))

        context.setBlendMode(.clear)
        context.setLineCap(.round)
        context.setLineWidth(55.0)

        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.strokePath()

        scratchImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setNeedsDisplay()
    }

    // MARK: - Scratch Percentage Calculation
    private func scratchPercentage() -> Float {
        guard let scratchImage = scratchImage, let cgImage = scratchImage.cgImage else { return 0.0 }

        let width = cgImage.width
        let height = cgImage.height
        guard width > 0, height > 0 else { return 0.0 }

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var rawData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        ) else { return 0.0 }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var total = 0
        var scratched = 0
        let step = 8

        var y = 0
        while y < height {
            var x = 0
            while x < width {
                total += 1
                let byteIndex = (bytesPerRow * y) + (x * bytesPerPixel)
                let alpha = rawData[byteIndex + 3]
                if alpha < 40 {
                    scratched += 1
                }
                x += step
            }
            y += step
        }

        if total == 0 { return 0.0 }
        return (Float(scratched) / Float(total)) * 100.0
    }

    // MARK: - Public Controls
    private func completeScratch() {
        if completed { return }
        completed = true
        scratching = false
        interactionEnabled = false

        scratchImage = nil
        setNeedsDisplay()

        onScratchComplete?()
    }

    public func setInteractionEnabled(_ enabled: Bool) {
        interactionEnabled = enabled
    }

    public func setScratchTextVisible(_ visible: Bool) {
        showScratchText = visible
        if !completed && bounds.width > 0 && bounds.height > 0 {
            createLayer(width: bounds.width, height: bounds.height)
            setNeedsDisplay()
        }
    }

    public func resetScratch() {
        completed = false
        scratching = false
        interactionEnabled = true
        if bounds.width > 0 && bounds.height > 0 {
            createLayer(width: bounds.width, height: bounds.height)
            setNeedsDisplay()
        }
    }

    public func setScratchColors(cover: UIColor, text: UIColor, background: UIColor, icon: UIColor) {
        coverColor = cover
        textColor = text
        scratchBackgroundColor = background
        iconColor = icon

        if !completed && bounds.width > 0 && bounds.height > 0 {
            createLayer(width: bounds.width, height: bounds.height)
            setNeedsDisplay()
        }
    }

    public func setScratchText(_ text: String) {
        scratchText = text
        if !completed && bounds.width > 0 && bounds.height > 0 {
            createLayer(width: bounds.width, height: bounds.height)
            setNeedsDisplay()
        }
    }

    public func setFont(name: String, size: CGFloat) {
        fontName = name
        textSize = size
        if !completed && bounds.width > 0 && bounds.height > 0 {
            createLayer(width: bounds.width, height: bounds.height)
            setNeedsDisplay()
        }
    }
}
