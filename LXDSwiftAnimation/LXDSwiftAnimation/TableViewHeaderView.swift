//
//  TableViewHeaderView.swift
//  LXDSwiftAnimation
//
//  Created by linxinda on 16/10/10.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

import UIKit

class TableViewHeaderView: UIView {

    private lazy var colorLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.isOpaque = true
        layer.fillColor = UIColor(red: 84/255.0, green: 180/255.0, blue: 239/255.0, alpha: 1).cgColor
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(colorLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayer(controlY: CGFloat, base: CGFloat) {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: base))
        path.addQuadCurve(to: CGPoint(x: 0, y: base), control: CGPoint(x: frame.width/2, y: controlY))
        path.closeSubpath()
        colorLayer.path = path
    }
    
}
