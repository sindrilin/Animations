//
//  XiuXiuViewController.swift
//  TimerAnimation
//
//  Created by linxinda on 2016/12/5.
//  Copyright © 2016年 Jolimark. All rights reserved.
//

import UIKit

let layerKey = "layerKey"
let twinkleInteval = 0.6

class XiuXiuViewController: UIViewController {
    
    var timer: Timer?
    weak var runloop: CFRunLoop?
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signIn(_ sender: UIButton) {
        
        if sender.isSelected {
            self.timer?.invalidate()
        } else {
            self.timer?.invalidate()
            if let runloop = self.runloop {
                CFRunLoopWakeUp(runloop)
            }
        
            self.timer = Timer(timeInterval: twinkleInteval, repeats: true, block: { [unowned self] (timer) in
                let frame = self.signInButton.frame
                let layer = self.roundLayer(with: frame)
                self.view.layer.insertSublayer(layer, below: self.signInButton.layer)
                self.twinkle(layer: layer)
            })
            self.runloop = CFRunLoopGetCurrent()
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
            self.timer?.fire()
        }
    }
    
    func twinkle(layer: CAShapeLayer) {
        let scale = CABasicAnimation(keyPath: "transform")
        scale.toValue = NSValue(caTransform3D: CATransform3DMakeScale(4, 4, 1))
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = NSNumber(floatLiteral: 0.75)
        opacity.toValue = NSNumber(floatLiteral: 0)
        
        let animation = CAAnimationGroup()
        animation.animations = [scale, opacity]
        animation.duration = twinkleInteval * 3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.setValue(layer, forKey: layerKey)
        animation.delegate = self
        layer.opacity = 0
        layer.add(animation, forKey: nil)
    }
    
    func roundLayer(with frame: CGRect) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: frame.height / 2).cgPath
        layer.bounds = frame
        layer.position = signInButton.center
        layer.fillColor = UIColor(colorLiteralRed: 34/255.0, green: 192/255.0, blue: 100/255.0, alpha: 1).cgColor
        return layer
    }
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }
}

extension XiuXiuViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer: CALayer = anim.value(forKey: layerKey) as? CALayer {
            layer.removeFromSuperlayer()
        }
    }
}
