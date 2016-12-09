//
//  SpringViewController.swift
//  TimerAnimation
//
//  Created by linxinda on 2016/12/6.
//  Copyright © 2016年 Jolimark. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController {
    
    private lazy var layer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor(colorLiteralRed: 34/255.0, green: 194/255.0, blue: 100/255.0, alpha: 1).cgColor
        return layer
    }()
    var displayLink: CADisplayLink?
    
    @IBOutlet private weak var referView: UIView!
    @IBOutlet private weak var springView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(layer)
    }
    
    @IBAction func animate(_ sender: Any) {
        let target = CGPoint(x: 0, y: view.center.y / 2)
        referView.layer.position = target
        springView.layer.position = target
        
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(animateWave))
        displayLink?.add(to: RunLoop.current, forMode: .commonModes)
        
        let move = CASpringAnimation(keyPath: "position")
        move.fromValue = NSValue(cgPoint: .zero)
        move.toValue = NSValue(cgPoint: target)
        move.duration = 2
        
        let spring = CASpringAnimation(keyPath: "position")
        spring.fromValue = NSValue(cgPoint: .zero)
        spring.toValue = NSValue(cgPoint: target)
        spring.duration = 2
        spring.damping = 7
        
        referView.layer.add(move, forKey: nil)
        springView.layer.add(spring, forKey: nil)
        referView.layer.position = target
        springView.layer.position = target
    }
    
    func animateWave() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: view.frame.width, y: 0))
        
        let controlY = springView.layer.presentation()?.position.y
        let referY = referView.layer.presentation()?.position.y
        
        path.addLine(to: CGPoint(x: view.frame.width, y: referY!))
        path.addQuadCurve(to: CGPoint(x: 0, y: referY!), control: CGPoint(x: view.frame.width / 2, y: controlY!))
        path.addLine(to: .zero)
        layer.path = path
    }
    
}
