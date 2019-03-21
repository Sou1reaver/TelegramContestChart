//
//  ChartViewControl.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 14/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartViewControl: UIControl {
    
    private enum ControlType {
        case none
        case mask
        case left
        case right
    }
    
    private var selectedControlType: ControlType = .none
    
    private lazy var maskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.fillRule = .evenOdd
        return maskLayer
    }()
    
    private lazy var maskOverlay: UIView = {
        let maskOverlay = UIView()
        maskOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.03)
        maskOverlay.frame = bounds
        maskOverlay.isUserInteractionEnabled = false
        insertSubview(maskOverlay, aboveSubview: chartView)
        return maskOverlay
    }()
    
    private lazy var chartView: ChartView = {
        let chartView = ChartView()
        chartView.backgroundColor = .white
        chartView.frame = bounds
        chartView.isUserInteractionEnabled = false
        insertSubview(chartView, at: 0)
        return chartView
    }()
    
    private var xMaskCoordinate: CGFloat = 0
    private let minMaskWidth: CGFloat = 100
    private var maskWidth: CGFloat = 100
    private var maskFrame: CGRect = .zero
    private var previousLocation = CGPoint()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chartView.frame = bounds
        maskOverlay.frame = bounds
        updateLayerFrames()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        previousLocation = location
        return maskFrame.contains(location)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        let deltaLocation = CGFloat(location.x - previousLocation.x)
        
        xMaskCoordinate = max(0, min(maskOverlay.bounds.width-maskWidth, xMaskCoordinate + deltaLocation))
    
        previousLocation = location
        
        updateLayerFrames()
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {

    }
    
    override func cancelTracking(with event: UIEvent?) {

    }
    
    private func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    private func updateLayerFrames()  {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let path = CGMutablePath()
        
        maskFrame = CGRect(x: xMaskCoordinate, y: 0, width: maskWidth, height: maskOverlay.bounds.height)
        path.addRect(maskFrame)
        path.addRect(CGRect(origin: .zero, size: maskOverlay.frame.size))
     
        maskLayer.path = path

        maskOverlay.layer.mask = maskLayer
        maskOverlay.clipsToBounds = true
        
        maskLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func addChartWith(lines: [ChartViewLine]) {
        chartView.drawChartWith(lines: lines)
    }
}
