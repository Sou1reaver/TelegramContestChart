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
        case middle
        case left
        case right
    }
    
    private var selectedControlType: ControlType = .none
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var maskOverlay: UIView!
    @IBOutlet weak var selector: ChartViewControlSelector!
    @IBOutlet weak var selectorWidth: NSLayoutConstraint!
    @IBOutlet weak var selectorLeading: NSLayoutConstraint!
    
    private var isFirstLayout = true
    private lazy var maskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.fillRule = .evenOdd
        return maskLayer
    }()
    
    private var xMaskCoordinate: CGFloat = 0
    private var minSelectorkWidth: CGFloat {
        return contentView.bounds.width/4.0
    }
    private var minSelectorkX: CGFloat {
        return 0
    }
    private var maxSelectorkX: CGFloat {
        return contentView.bounds.width - selectorWidth.constant
    }
    private var previousLocation = CGPoint()
    
    var widthZoom: CGFloat {
        return contentView.bounds.width/selector.bounds.width
    }
    var xOffsetScale: CGFloat {
        return selectorLeading.constant/contentView.bounds.width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstLayout {
            selectorLeading.constant = minSelectorkX
            selectorWidth.constant = contentView.bounds.width

        }
        updateLayerFrames()
        isFirstLayout = false
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        let locationForLeftControl = convert(location, to: selector)
        let locationForRightControl = convert(location, to: selector)
        
        if selector.leftControl.frame.contains(locationForLeftControl) {
            selectedControlType = .left
        } else if selector.rightControl.frame.contains(locationForRightControl) {
            selectedControlType = .right
        } else if selector.frame.contains(location) {
            selectedControlType = .middle
        } else {
            selectedControlType = .none
        }
        
        previousLocation = location
        return selectedControlType != .none
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        let deltaLocation = CGFloat(location.x - previousLocation.x)
        
        switch selectedControlType {
        case .left:
            let oldLeading = selectorLeading.constant
            let newLeading = max(minSelectorkX, min(oldLeading+deltaLocation, (oldLeading+selectorWidth.constant)-minSelectorkWidth))
            selectorLeading.constant = newLeading
            selectorWidth.constant += oldLeading-newLeading

        case .right:
            
            let newWidth = selectorWidth.constant + deltaLocation
            selectorWidth.constant = boundSelectorWidth(newWidth)
        case .middle:
            let newOffset = selectorLeading.constant + deltaLocation
            selectorLeading.constant = boundXOffset(newOffset)
        case .none:
            return false
        }
        previousLocation = location
        
        layoutIfNeeded()
        updateLayerFrames()
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        selectedControlType = .none
    }
    
    override func cancelTracking(with event: UIEvent?) {
        selectedControlType = .none
    }
    
    private func initialSetup() {
        fromNib()
        selectorLeading.constant = minSelectorkX
        selectorWidth.constant = contentView.bounds.width
        
    }
    
    private func boundSelectorWidth(_ width: CGFloat) -> CGFloat {
        return max(minSelectorkWidth, min(width, contentView.bounds.width-selectorLeading.constant))
    }
    
    private func boundXOffset(_ offset: CGFloat) -> CGFloat {
        return max(minSelectorkX, min(maxSelectorkX, offset))
    }
    
    private func updateLayerFrames()  {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let path = CGMutablePath()
        
        let maskFrame = CGRect(x: selectorLeading.constant, y: 0.0, width: selectorWidth.constant, height: maskOverlay.bounds.height)
        path.addRect(maskFrame)
        path.addRect(CGRect(origin: .zero, size: maskOverlay.frame.size))
     
        maskLayer.path = path

        maskOverlay.layer.mask = maskLayer
        maskOverlay.clipsToBounds = true
        
        maskLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func addChartWith(data: ChartViewData) {
        chartView.drawChartWith(data: data, withMaxLineVisibleValue: data.maxLineValue)
    }
}
