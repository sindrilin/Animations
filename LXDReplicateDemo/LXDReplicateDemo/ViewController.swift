//
//  ViewController.swift
//  LXDReplicateDemo
//
//  Created by 林欣达 on 16/6/3.
//  Copyright © 2016年 CNPay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = LXDTimer(executeQueue: LXDQueue.mainQueue())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let width = view.frame.width
        let height = view.frame.height
        let offset = 10
        let animateDuration = 0.5
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = self.view.frame
        replicatorLayer.position = self.view.center
        replicatorLayer.instanceCount = Int(width) / offset
        replicatorLayer.instanceDelay = animateDuration
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(-CGFloat(offset), 0, 0)
        view.layer.addSublayer(replicatorLayer)
        replicatorLayer.masksToBounds = true
        
        let displayLayer = CALayer()
        displayLayer.frame = CGRectMake(width - CGFloat(offset) / 2, height, CGFloat(offset) / 2, height)
        displayLayer.cornerRadius = 2
        replicatorLayer.addSublayer(displayLayer)
        
        timer.execute({
            let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
            colorAnimation.toValue = self.randomColor().CGColor
            
            let offsetAnimation = CABasicAnimation(keyPath: "position.y")
            offsetAnimation.toValue = NSNumber(integer: Int(UInt32(displayLayer.position.y) - arc4random() % UInt32(height / 2)))
            
            let group = CAAnimationGroup()
            group.duration = 1
            group.autoreverses = true
            group.repeatCount = 20
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.animations = [colorAnimation, offsetAnimation]
            displayLayer.addAnimation(group, forKey: nil)
            
            }, interval: 1, delay: 1)
        timer.start()
    }
    
    private func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1)
    }

}

