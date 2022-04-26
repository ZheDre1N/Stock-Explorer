import UIKit

// swiftlint:disable all
class ChartView: UIView {
  // MARK: Interface
  public var dataSource: [CVCandle]? {
    didSet {
      setupView()
      let rightOffset = CGPoint(x: chartScrollView.contentSize.width, y: 0)
      chartScrollView.setContentOffset(rightOffset, animated: false)
      setNeedsLayout()
    }
  }
  public var fullScreenButtonHandler: (() -> Void)?
  public var chartStyleButtonHandler: (() -> Void)?

  public func startAnimating(withMockData isMocked: Bool) {}
  public func stopAnimating() {}

  // MARK: Dependencies
  private var chartStyle: ChartStyleProvider = DefaultChartStyle()
  private var chartMath: ChartMathProvider = DefaultChartMath()
  private var chartGridLayerProvider: ChartGridLayerProvider = DefaultGridLayerProvider()
  
  // MARK: Declarations
  private var drawableDataSourceRange: Range<Int>?
  private var drawableDataPoints: [CGPoint]?
  private let drawablePointCountExceedFrameWidth = 40

  // Chart View foundation
  private let topBorder: UIView = .init() // 1 part
  private let chartScrollView: UIScrollView = .init() // 2 part
  private let auxiliaryView: UIView = .init() // 3 part
  private let sectionBorder: UIView = .init() // 4 part
  private let chartStyleButton: UIButton = .init(type: .custom) // 5 part

  // ChartScrollView, 2 part
  private let chartView: UIView = .init() // 2.1 part
  private let chartBorder: UIView = .init() // 2.2 part
  private let chartLabelsView: UIView = .init() // 2.3 part

  // ChartView, 2.1 part
  private var chartGridLayer: CALayer = .init() // 2.1.1 part
  private let chartDataLayer: CALayer = .init() // 2.1.2 part
  private let chartGradientLayer: CAGradientLayer = .init() // 2.1.3 part
  private let chartGradientLayerMask: CAShapeLayer = .init() // 2.1.4 part

  // AuxiliaryView, 3 part
  private let auxiliaryPriceView: UIView = .init() // 3.1 part
  private let auxiliaryBorderView: UIView = .init() // 3.2 part
  private let auxiliaryButton: UIButton = .init(type: .custom) // 3.3 part

  // Long Press layers and Pointers
  private let longPressVerticalLine: CAShapeLayer = .init()
  private let longPressPointExternalCircle: CAShapeLayer = .init()
  private let longPressPointInternalCircle: CAShapeLayer = .init()
  private let longPressTextLabel: CATextLayer = .init()

  private let pointerHorisontalLine: CAShapeLayer = .init()
  private let pointerPriceLabel: CATextLayer = .init()

  // MARK: Constants
  // 1 part
  private let topBorderHeight: CGFloat = 1

  // 2 part
  private let xPointSpace: CGFloat = 5
  private let chartViewPadding: CGFloat = 20
  private let chartBorderHeight: CGFloat = 1
  private let chartLabelsViewHeight: CGFloat = 30

  // 3 part
  private let auxiliaryViewWidth: CGFloat = 30
  private let auxiliaryBorderHeight: CGFloat = 1
  private let auxiliaryButtonHeight: CGFloat = 30

  // 4 part
  private let sectionBorderWidth: CGFloat = 1

  // 5 part
  private let chartStyleButtonPadding: CGFloat = 16
  private let chartStyleButtonHeight: CGFloat = 32
  
  private let labelFont = CTFont(.label, size: 0, language: .none)
  private let labelSize: CGFloat = 11

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init() {
    self.init(frame: CGRect.zero)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  private func setupView() {
    configureDelegates()
    drawTopBorder() // 1 part
    drawChartScrollView() // 2 part
    drawAuxiliaryView() // 3 part
    drawSectionBorder() // 4 part
    drawChartStyleButton() // 5 part
  }

  public override func layoutSubviews() {
    clean()
    setupView()
  }

  private func configureDelegates() {
    chartScrollView.delegate = self
  }

  // MARK: 1 Part
  private func drawTopBorder() { // 1 part
    addSubview(topBorder)
    topBorder.backgroundColor = chartStyle.borderColor
    topBorder.frame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: topBorderHeight
    )
  }

  // MARK: 2 Part
  private func drawChartScrollView() { // 2 part
    addSubview(chartScrollView)
    chartScrollView.showsHorizontalScrollIndicator = false
    chartScrollView.frame = CGRect(
      x: 0,
      y: topBorderHeight,
      width: frame.size.width - auxiliaryViewWidth - sectionBorderWidth,
      height: frame.size.height - topBorderHeight
    )

    if let dataSource = dataSource {
      chartScrollView.contentSize = CGSize(
        width: CGFloat(dataSource.count) * xPointSpace,
        height: chartScrollView.frame.size.height
      )
    }

    drawChartView() // 2.1 part
    drawChartBorder() // 2.2 part
    drawLabelsView() // 2.3 part
  }

  private func drawChartView() { // 2.1 part
    chartScrollView.addSubview(chartView)
    chartView.frame = CGRect(
      x: 0,
      y: chartViewPadding,
      width: chartScrollView.contentSize.width,
      height: chartScrollView.contentSize.height - (2 * chartViewPadding) - chartLabelsViewHeight
    )

    drawGridLayer() // 2.1.1 part
    drawLineChartLayer() // 2.1.2 part
    drawGradientLayer() // 2.1.3 part
    drawMaskGradientLayer() // 2.1.4 part

    configureLongTouchRecognizer()
  }

  private func drawGridLayer() { // 2.1.1 part
    chartGridLayer.frame = CGRect(
      x: 0,
      y: 0,
      width: chartScrollView.contentSize.width,
      height: chartScrollView.contentSize.height - chartLabelsViewHeight - chartBorderHeight
    )
    chartScrollView.layer.addSublayer(chartGridLayer)

    if let dataSource = dataSource {
      chartGridLayer = chartGridLayerProvider.drawGridLayer(
        on: chartGridLayer,
        dataSource: dataSource,
        xPointSpace: xPointSpace
      )
    }
  }

  private func drawLineChartLayer() { // 2.1.2 part
    guard
      let dataSource = dataSource,
      let drawableDataSourceRange = chartMath.getDrawableDataSourceRange(
        offsetX: chartScrollView.contentOffset.x,
        viewWidth: chartScrollView.frame.size.width,
        dataSourceCount: dataSource.count,
        xPointSpace: xPointSpace,
        visibility: drawablePointCountExceedFrameWidth
      )
    else {
      return
    }
    self.drawableDataSourceRange = drawableDataSourceRange
    drawableDataPoints = chartMath.getDrawableDataPoints(
      viewHeight: chartView.frame.height,
      xPointSpace: xPointSpace,
      with: dataSource,
      and: drawableDataSourceRange
    )
    drawLineChart()
    chartView.layer.addSublayer(chartDataLayer)
  }

  private func drawGradientLayer() { // 2.1.3 part
    chartGradientLayer.frame = chartView.bounds
    chartGradientLayer.colors = chartStyle.gradients
    chartView.layer.addSublayer(chartGradientLayer)
  }

  private func drawMaskGradientLayer() { // 2.1.4 part
    if let visibleDataPoints = drawableDataPoints, !visibleDataPoints.isEmpty {
      let path = UIBezierPath()
      path.move(to: CGPoint(x: visibleDataPoints[0].x, y: chartView.frame.height))
      path.addLine(to: visibleDataPoints[0])
      if let chartPath = createChartLinePath() {
        path.append(chartPath)
      }
      path.addLine(to: CGPoint(
        x: visibleDataPoints[visibleDataPoints.count - 1].x,
        y: chartView.frame.height
      ))
      path.addLine(to: CGPoint(
        x: visibleDataPoints[0].x,
        y: chartView.frame.height
      ))
      chartGradientLayerMask.path = path.cgPath
      chartGradientLayer.mask = chartGradientLayerMask
    }
  }

  private func drawChartBorder() { // 2.2 part
    addSubview(chartBorder)
    chartBorder.frame = CGRect(
      x: 0,
      y: frame.size.height - chartLabelsViewHeight - chartBorderHeight,
      width: frame.size.width - sectionBorderWidth - auxiliaryViewWidth,
      height: chartBorderHeight
    )
    chartBorder.backgroundColor = chartStyle.borderColor
  }

  private func drawLabelsView() { // 2.3 part
    chartScrollView.addSubview(chartLabelsView)
    chartLabelsView.frame = CGRect(
      x: 0,
      y: chartScrollView.contentSize.height - chartLabelsViewHeight,
      width: chartScrollView.contentSize.width,
      height: chartLabelsViewHeight
    )

    guard let dataSource = dataSource else {
      return
    }

    for valueIndex in 0..<dataSource.count where valueIndex % 16 == 0 {

      let textLabelLayer = CATextLayer()
      let label = dataSource[valueIndex].label
      let textLabelLayerWidth: CGFloat = 60

      textLabelLayer.frame = CGRect(
        x: CGFloat(valueIndex) * xPointSpace - textLabelLayerWidth / 2,
        y: 5,
        width: textLabelLayerWidth,
        height: 15
      )
      textLabelLayer.foregroundColor = chartStyle.labelColor
      textLabelLayer.contentsScale = UIScreen.main.scale
      textLabelLayer.font = labelFont
      textLabelLayer.fontSize = labelSize
      textLabelLayer.string = label
      textLabelLayer.alignmentMode = .center
      chartLabelsView.layer.addSublayer(textLabelLayer)
    }
  }

  // MARK: 3 Part
  private func drawAuxiliaryView() { // 3 part
    addSubview(auxiliaryView)
    auxiliaryView.frame = CGRect(
      x: frame.size.width - auxiliaryViewWidth,
      y: topBorderHeight,
      width: auxiliaryViewWidth,
      height: frame.size.height - topBorderHeight
    )
    auxiliaryView.clipsToBounds = true
    drawPriceView() // 3.1 part
    drawAuxiliaryBorder() // 3.2 part
    drawAuxiliaryButton() // 3.3 part
  }

  private func drawPriceView() { // 3.1 part
    auxiliaryView.addSubview(auxiliaryPriceView)
    auxiliaryPriceView.clipsToBounds = true
    auxiliaryPriceView.frame = CGRect(
      x: 0,
      y: 0,
      width: auxiliaryViewWidth,
      height: auxiliaryView.frame.size.height - auxiliaryButtonHeight - auxiliaryBorderHeight
    )
    drawGridTextLayer()

    guard let dataSource = dataSource else {
      return
    }

    if let visibleViewRange = chartMath.getDrawableDataSourceRange(
      offsetX: chartScrollView.contentOffset.x,
      viewWidth: chartScrollView.frame.size.width,
      dataSourceCount: dataSource.count,
      xPointSpace: xPointSpace,
      visibility: 0
    ) {
      let visibleViewDataSource = Array(dataSource[visibleViewRange.lowerBound..<visibleViewRange.upperBound])
      let candle = visibleViewDataSource.last
      drawPointerPriceLabel(candle: candle)
      drawPointerHorisontalLine(candle: candle)
    }
  }

  private func drawAuxiliaryBorder() { // 3.2 part
    auxiliaryView.addSubview(auxiliaryBorderView)
    auxiliaryBorderView.frame = CGRect(
      x: 0,
      y: frame.size.height - auxiliaryButtonHeight - topBorderHeight - auxiliaryBorderHeight,
      width: frame.size.width,
      height: auxiliaryBorderHeight
    )
    auxiliaryBorderView.backgroundColor = chartStyle.borderColor
  }

  private func drawAuxiliaryButton() { // 3.3 part
    auxiliaryView.addSubview(auxiliaryButton)

    auxiliaryButton.frame = CGRect(
      x: 0,
      y: frame.size.height - auxiliaryButtonHeight,
      width: auxiliaryButtonHeight,
      height: auxiliaryButtonHeight
    )

    var image: UIImage?
    if #available(iOS 13.0, *) {
      image = UIImage(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
    } else {
      // Fallback on earlier versions
    }
    auxiliaryButton.setImage(image, for: .normal)
    auxiliaryButton.tintColor = chartStyle.fullButtonTintColor
    auxiliaryButton.addTarget(self, action: #selector(self.fullScreenButtonTapped), for: .touchUpInside)
  }

  @objc func fullScreenButtonTapped(sender: UIButton) {
    guard let fullScreenButtonHandler = fullScreenButtonHandler else { return }
    fullScreenButtonHandler()
  }

  // MARK: 4 Part
  private func drawSectionBorder() { // 4 part
    addSubview(sectionBorder)
    sectionBorder.frame = CGRect(
      x: frame.size.width - auxiliaryViewWidth - sectionBorderWidth,
      y: topBorderHeight,
      width: sectionBorderWidth,
      height: frame.size.height - topBorderHeight
    )
    sectionBorder.backgroundColor = chartStyle.borderColor
  }

  // MARK: 5 Part
  private func drawChartStyleButton() { // 5 part
    addSubview(chartStyleButton)

    chartStyleButton.frame = CGRect(
      x: chartStyleButtonPadding,
      y: chartStyleButtonPadding + topBorderHeight,
      width: chartStyleButtonHeight,
      height: chartStyleButtonHeight
    )
    let iconImage = UIImage(systemName: "line.diagonal")
    chartStyleButton.setImage(iconImage, for: .normal)
    chartStyleButton.backgroundColor = UIColor(white: 0.25, alpha: 0.25)
    chartStyleButton.tintColor = chartStyle.changeStyleButtonColor
    chartStyleButton.layer.borderWidth = 1.0
    chartStyleButton.layer.borderColor = chartStyle.changeStyleButtonColor.cgColor
    chartStyleButton.layer.cornerRadius = 8
    chartStyleButton.addTarget(self, action: #selector(self.chartStyleButtonTapped), for: .touchUpInside)
  }

  @objc func chartStyleButtonTapped(sender: UIButton) {
    guard let chartStyleButtonHandler = chartStyleButtonHandler else {
      return
    }
    chartStyleButtonHandler()
  }

  // MARK: Helpers
  private func drawLineChart() {
    if let path = createChartLinePath() {
      let lineLayer = CAShapeLayer()
      lineLayer.path = path.cgPath
      lineLayer.strokeColor = chartStyle.chartLineColor.cgColor
      lineLayer.fillColor = UIColor.clear.cgColor
      lineLayer.lineWidth = 2
      chartDataLayer.addSublayer(lineLayer)
    }
  }

  private func createChartLinePath() -> UIBezierPath? {
    guard let drawableDataPoints = drawableDataPoints, !drawableDataPoints.isEmpty else {
      return nil
    }
    let path = UIBezierPath()
    path.move(to: drawableDataPoints[0])

    for pointIndex in 1..<drawableDataPoints.count {
      path.addLine(to: drawableDataPoints[pointIndex])
    }
    return path
  }



  private func drawGridTextLayer() {
    guard let dataSource = dataSource, let visibleRange = drawableDataSourceRange else {
      return
    }

    let visibleDataSource = Array(dataSource[visibleRange.lowerBound..<visibleRange.upperBound])

    if let max = visibleDataSource.max()?.close,
       let min = visibleDataSource.min()?.close {

      let minCGFloat = CGFloat(min)
      let maxCGFloat = CGFloat(max)

      let gridValue: [CGFloat] = [0, 0.25, 0.5, 0.75, 1]
      for value in gridValue {
        let textLayerY: CGFloat = chartView.frame.size.height * CGFloat(value) + chartViewPadding
        let textLayer = CATextLayer()
        let textLayerHeight: CGFloat = 12
        var textValue = maxCGFloat - (maxCGFloat - minCGFloat) * value
        if textValue == 0 {
          textValue = minCGFloat
        }
        textLayer.frame = CGRect(
          x: 0,
          y: textLayerY - textLayerHeight / 2,
          width: auxiliaryPriceView.frame.size.width,
          height: textLayerHeight
        )

        textLayer.foregroundColor = chartStyle.labelColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = labelFont
        textLayer.fontSize = labelSize
        textLayer.string = "\(round(textValue * 10) / 10 )"
        textLayer.alignmentMode = .center

        auxiliaryPriceView.layer.addSublayer(textLayer)
      }
    }
  }

  private func drawPointerPriceLabel(candle: CVCandle?) {
    guard
      let dataSource = dataSource,
      let visibleFullRange = drawableDataSourceRange
    else {
      return
    }

    let visibleFullDataSource = Array(dataSource[visibleFullRange.lowerBound..<visibleFullRange.upperBound])

    if let candlePrice = candle?.close,
       let max = visibleFullDataSource.max()?.close,
       let min = visibleFullDataSource.min()?.close {


      let screenHeight = chartView.frame.size.height
      let valueRange = CGFloat(max - min)
      let valueHeight = CGFloat(max - candlePrice)
      let textLayerY = screenHeight * valueHeight / valueRange + chartViewPadding - labelSize / 2

      pointerPriceLabel.frame = CGRect(
        x: 0,
        y: textLayerY,
        width: auxiliaryPriceView.frame.size.width,
        height: labelSize + labelSize * 0.25
      )

      pointerPriceLabel.removeAllAnimations()
      pointerPriceLabel.foregroundColor = chartStyle.labelColor
      pointerPriceLabel.backgroundColor = chartStyle.currentPricePointerColor.cgColor
      pointerPriceLabel.contentsScale = UIScreen.main.scale
      pointerPriceLabel.font = labelFont
      pointerPriceLabel.fontSize = labelSize
      pointerPriceLabel.string = "\(round(candlePrice * 10) / 10)"
      pointerPriceLabel.alignmentMode = .center
      auxiliaryPriceView.layer.addSublayer(pointerPriceLabel)
    }
  }

  private func drawPointerHorisontalLine(candle: CVCandle?) {
    guard let dataSource = dataSource, let drawableDataSourceRange = drawableDataSourceRange else {
      return
    }
    let visibleFullDataSource = Array(dataSource[drawableDataSourceRange.lowerBound..<drawableDataSourceRange.upperBound])

    if let candlePrice = candle?.close,
       let max = visibleFullDataSource.max()?.close,
       let min = visibleFullDataSource.min()?.close {

      let textLayerHeight: CGFloat = 12

      let screenHeight = chartView.frame.size.height
      let valueRange = CGFloat(max - min)
      let valueHeight = CGFloat(max - candlePrice)
      let textLayerY = screenHeight * valueHeight / valueRange + chartViewPadding - textLayerHeight / 2

      // draw horisontal line on chartScrollView
      let pathLine = UIBezierPath()
      pathLine.move(to: CGPoint(x: 0, y: textLayerY - textLayerHeight - 2))
      pathLine.addLine(to: CGPoint(x: chartView.frame.size.width, y: textLayerY - textLayerHeight - 2))
      pointerHorisontalLine.path = pathLine.cgPath
      pointerHorisontalLine.lineDashPattern = [6, 6]
      pointerHorisontalLine.strokeColor = chartStyle.currentPricePointerColor.cgColor
      pointerHorisontalLine.lineWidth = 1
      chartView.layer.addSublayer(pointerHorisontalLine)
    }
  }

  private func clean() {
    auxiliaryPriceView.layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }

    chartDataLayer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }

    chartGridLayer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }

    chartLabelsView.layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }

    chartView.layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }
  }

  // MARK: Long Press Gesture
  private func configureLongTouchRecognizer() {
    let longTouchRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTouched))
    chartScrollView.addGestureRecognizer(longTouchRecognizer)
  }

  @objc func longTouched(sender: UILongPressGestureRecognizer) {
    let longPressPoint = sender.location(in: chartView)
    let longPressSelfPoint = sender.location(in: self)
    guard let longPressData = getLongPressData(from: longPressPoint) else {
      return
    }

    let longPressCandle = longPressData.chartCandle

    if sender.state == UIGestureRecognizer.State.began {
      drawLongPressVerticalLine(longPressData.point.x)
      drawPointerPriceLabel(candle: longPressCandle)
      drawPointerHorisontalLine(candle: longPressCandle)
      drawLongPressPoint(longPressData.point)
      drawLongPressTextLabel(
        point: longPressData.point,
        candle: longPressData.chartCandle,
        selfPoint: longPressSelfPoint
      )
      layoutIfNeeded()
    } else if sender.state == UIGestureRecognizer.State.changed {
      drawLongPressVerticalLine(longPressData.point.x)
      drawPointerPriceLabel(candle: longPressCandle)
      drawPointerHorisontalLine(candle: longPressCandle)
      drawLongPressPoint(longPressData.point)
      drawLongPressTextLabel(
        point: longPressData.point,
        candle: longPressData.chartCandle,
        selfPoint: longPressSelfPoint
      )
      layoutIfNeeded()
    } else if sender.state == UIGestureRecognizer.State.ended {
      setNeedsLayout()
    }
  }

  private func drawLongPressVerticalLine(_ xTouchPoint: CGFloat) {
    let pathLine = UIBezierPath()
    pathLine.move(to: CGPoint(x: xTouchPoint, y: 0 - chartViewPadding))
    pathLine.addLine(to: CGPoint(x: xTouchPoint, y: chartView.frame.size.height + chartViewPadding + 5))
    longPressVerticalLine.path = pathLine.cgPath
    longPressVerticalLine.strokeColor = chartStyle.currentPricePointerColor.cgColor
    longPressVerticalLine.lineWidth = 1
    chartView.layer.addSublayer(longPressVerticalLine)
  }

  private func drawLongPressPoint(_ point: CGPoint) {
    // External Point on ChartView
    let externalCirclePath = UIBezierPath(
      arcCenter: point,
      radius: 4,
      startAngle: 0,
      endAngle: CGFloat.pi * 2,
      clockwise: true
    )

    longPressPointExternalCircle.path = externalCirclePath.cgPath
    longPressPointExternalCircle.fillColor = chartStyle.externalPointColor.cgColor
    longPressPointExternalCircle.strokeColor = chartStyle.externalPointColor.cgColor
    longPressPointExternalCircle.lineWidth = 1
    chartView.layer.addSublayer(longPressPointExternalCircle)

    // Internal Point on ChartView
    let internalCirclePath = UIBezierPath(
      arcCenter: point,
      radius: 2,
      startAngle: 0,
      endAngle: CGFloat.pi * 2,
      clockwise: true
    )

    longPressPointInternalCircle.path = internalCirclePath.cgPath
    longPressPointInternalCircle.fillColor = chartStyle.internPointColor.cgColor
    longPressPointInternalCircle.strokeColor = chartStyle.internPointColor.cgColor
    longPressPointInternalCircle.lineWidth = 1
    chartView.layer.addSublayer(longPressPointInternalCircle)
  }

  private func drawLongPressTextLabel(point: CGPoint, candle: CVCandle, selfPoint: CGPoint) {
    var offsetX: CGFloat

    if selfPoint.x < 30 {
      offsetX = 30
    } else if selfPoint.x > (frame.size.width - auxiliaryViewWidth - sectionBorderWidth - 30) {
      offsetX = -30
    } else {
      offsetX = 0
    }
    longPressTextLabel.removeAllAnimations()
    longPressTextLabel.frame = CGRect(
      x: point.x - 30 + offsetX,
      y: 5,
      width: 60,
      height: 15
    )
    longPressTextLabel.removeAllAnimations()
    longPressTextLabel.foregroundColor = chartStyle.labelColor
    longPressTextLabel.backgroundColor = chartStyle.currentPricePointerColor.cgColor
    longPressTextLabel.contentsScale = UIScreen.main.scale
    longPressTextLabel.font = labelFont
    longPressTextLabel.fontSize = labelSize
    longPressTextLabel.string = candle.label
    longPressTextLabel.alignmentMode = .center
    chartLabelsView.layer.addSublayer(longPressTextLabel)
  }

  private func getLongPressData(from pressPoint: CGPoint) -> (point: CGPoint, chartCandle: CVCandle)? {
    guard
      let dataSource = dataSource,
      !dataSource.isEmpty,
      let drawableDataSourceRange = drawableDataSourceRange,
      let drawableDataPoints = drawableDataPoints
    else {
      return nil
    }

    var nearestPoint = drawableDataPoints[0]
    var nearestIndex = 0
    var minGap: CGFloat = CGFloat.infinity

    for (index, point) in drawableDataPoints.enumerated() {
      if abs(point.x - pressPoint.x) < minGap {
        minGap = abs(point.x - pressPoint.x)
        nearestPoint = point
        nearestIndex = drawableDataSourceRange.lowerBound + index
      }
    }
    return (point: nearestPoint, chartCandle: dataSource[nearestIndex])
  }
}

extension ChartView: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // update drawableDataSourceRange
    // update drawableDataSourcePoints
    setNeedsLayout()
  }
}
// swiftlint:enable all