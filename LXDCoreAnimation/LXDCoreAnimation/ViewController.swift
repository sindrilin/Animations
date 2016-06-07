//
//  ViewController.swift
//  LXDCoreAnimation
//
//  Created by 林欣达 on 16/6/7.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let layer = CAShapeLayer()
    var timer: NSTimer?
    
    let leftLayer = CAShapeLayer()
    let centerLayer = CAShapeLayer()
    let rightLayer = CAShapeLayer()
    let fluctLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 图层属性
        layer.strokeEnd = 0
        layer.lineWidth = 6
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.redColor().CGColor
        
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOffset = CGSize(width: 2, height: 5)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        self.view.layer.addSublayer(layer)
        
        
        //MAKR: - 隐式动画的响应者
        let actionView = LXDActionView()
        view.addSubview(actionView)
        print("===========normal call===========")
        print("\(self.view.actionForLayer(self.view.layer, forKey: "opacity"))")
        actionView.layer.opacity = 0.5
        UIView.animateWithDuration(0.25) {
            print("===========animate block call===========")
            print("\(self.view.actionForLayer(self.view.layer, forKey: "opacity"))")
            actionView.layer.opacity = 0
        }
        
        //MARK: - 粘球弹簧动画实现
        fluctLayer.fillColor = UIColor.greenColor().CGColor
        leftLayer.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        rightLayer.frame = CGRect(x: UIScreen.mainScreen().bounds.width - 1, y: 0, width: 1, height: 1)
        centerLayer.frame = CGRect(x: UIScreen.mainScreen().bounds.width / 2, y: 0, width: 5, height: 5)
        centerLayer.fillColor = UIColor.redColor().CGColor
        
        self.view.layer.addSublayer(leftLayer)
        self.view.layer.addSublayer(centerLayer)
        self.view.layer.addSublayer(rightLayer)
        self.view.layer.addSublayer(fluctLayer)
    }

    //MARK: - 按钮点击
    @IBAction func actionToAnimate() {
        
        let displayLink = CADisplayLink(target: self, selector: #selector(fluctAnimation(_:)))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        let move = CABasicAnimation(keyPath: "position.y")
        move.toValue = NSNumber(float: 160)
        leftLayer.position.y = 160
        rightLayer.position.y = 160
        leftLayer.addAnimation(move, forKey: nil)
        rightLayer.addAnimation(move, forKey: nil)
        
        let spring = CASpringAnimation(keyPath: "position.y")
        spring.damping = 15
        spring.initialVelocity = 40
        spring.toValue = NSNumber(float: 160)
        centerLayer.position.y = 160
        centerLayer.addAnimation(spring, forKey: "spring")
        
        //MARK: - 隐式动画绘制圆环
        if true {
            return
        }
        timer = NSTimer(timeInterval: 0.05, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        layer.path = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true).CGPath
        layer.strokeEnd = 1
    }
    
    //MARK: - 粘球动画定时器动画
    @objc private func fluctAnimation(link: CADisplayLink) {
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        
        guard let _ = centerLayer.animationForKey("spring") else {
            return
        }
        
        let offset = leftLayer.presentationLayer()!.position.y - centerLayer.presentationLayer()!.position.y
        var controlY: CGFloat = 160
        if offset < 0 {
            controlY = centerLayer.presentationLayer()!.position.y + 30
        } else if offset > 0 {
            controlY = centerLayer.presentationLayer()!.position.y - 30
        }
        
        path.addLineToPoint(leftLayer.presentationLayer()!.position)
        path.addQuadCurveToPoint(rightLayer.presentationLayer()!.position, controlPoint: CGPoint(x: centerLayer.position.x, y: controlY))
        path.addLineToPoint(CGPoint(x: UIScreen.mainScreen().bounds.width, y: 0))
        path.closePath()
        fluctLayer.path = path.CGPath
    }
    
    //MARK: - 定时器查看圆环绘边进度
    @objc private func timerCallback() {
        print("========================\nmodelLayer: \t\(layer.modelLayer().strokeEnd)\ntpresentationLayer: \t\(layer.presentationLayer()!.strokeEnd)\n")
        if fabs((layer.presentationLayer()?.strokeEnd)! - 1) < 0.01 {
            if let _ = timer {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
}

