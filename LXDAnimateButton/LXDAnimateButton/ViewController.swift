//
//  ViewController.swift
//  LXDAnimateButton
//
//  Created by linxinda on 16/9/12.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var animateButton: UIButton!
    var layer: CAShapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateButton.animationType = .Outer
        layer.frame = UIScreen.mainScreen().bounds
        layer.fillColor = UIColor.purpleColor().CGColor
        layer.path = UIBezierPath(rect: CGRectMake(UIScreen.mainScreen().bounds.width/2 - 100, UIScreen.mainScreen().bounds.height/2 - 100, 200, 200)).CGPath
        self.view.layer.addSublayer(layer)
    }
    
    @IBAction func actionToAnimatedLayer(sender: AnyObject) {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = NSNumber(double: 1)
        opacity.toValue = NSNumber(double: 0)
        
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        scale.toValue = NSValue(CATransform3D: CATransform3DMakeScale(2, 2, 2))
        
        let group = CAAnimationGroup()
        group.animations = [opacity, scale]
        group.duration = 1
        layer.addAnimation(group, forKey: "group")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim is CABasicAnimation {
            let animation = anim as! CABasicAnimation
            if let layer = animation.valueForKey("animatedLayer") as? CALayer {
                layer.setValue(animation.toValue, forKey: animation.keyPath!)
                layer.removeAllAnimations()
            }
        }
    }
    
}


private var kAnimationTypeKey: UInt = 0
private var kAnimationColorKey: UInt = 1
extension UIButton {
    
    enum LXDAnimationType: String {
        case Inner = "Inner"
        case Outer = "Outer"
    }
    
    
    //MARK: - Dynamic property
    var animationType: LXDAnimationType? {
        get {
            if let type = (objc_getAssociatedObject(self, &kAnimationTypeKey) as? String) {
                return LXDAnimationType(rawValue: type)
            }
            return nil
        }
        set {
            guard newValue != nil else {
                return
            }
            self.clipsToBounds = (newValue == .Inner)
            objc_setAssociatedObject(self, &kAnimationTypeKey, newValue!.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var animationColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &kAnimationColorKey) {
                return color as! UIColor
            }
            return UIColor.whiteColor()
        }
        set {
            objc_setAssociatedObject(self, &kAnimationColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    //MARK: - Override
    public override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        super.sendAction(action, to: target, forEvent: event)
        
        if let type = animationType {
            var rect: CGRect?
            var radius = self.layer.cornerRadius
            
            var pos = touchPoint(event)
            print("\(pos)")
            let smallerSize = min(self.frame.width, self.frame.height)
            let longgerSize = max(self.frame.width, self.frame.height)
            var scale = longgerSize / smallerSize + 0.5
            
            switch type {
            case .Inner:
                radius = smallerSize / 2
                rect = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
                break
                
            case .Outer:
                scale = 2.5
                pos = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
                rect = CGRect(x: pos.x - self.bounds.width, y: pos.y - self.bounds.height, width: self.bounds.width, height: self.bounds.height)
                break
            }
            
            let layer = animateLayer(rect!, radius: radius, position: pos)
            let group = animateGroup(scale)
            self.layer.addSublayer(layer)
            group.setValue(layer, forKey: "animatedLayer")
            layer.addAnimation(group, forKey: "buttonAnimation")
        }
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.valueForKey("animatedLayer") as? CALayer {
            layer .removeFromSuperlayer()
        }
    }
    
    
    //MARK: - Private
    private func touchPoint(event: UIEvent?) -> CGPoint {
        if let touch = event?.allTouches()?.first {
            return touch.locationInView(self)
        } else {
            return CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        }
    }
    
    private func animateLayer(rect: CGRect, radius: CGFloat, position: CGPoint) -> CALayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.position = position
        layer.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        
        switch animationType! {
        case .Inner:
            layer.fillColor = animationColor.CGColor
            layer.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
            break
            
        case .Outer:
            layer.strokeColor = animationColor.CGColor
            layer.fillColor = UIColor.clearColor().CGColor
            break
        }
        return layer
    }
    
    private func animateGroup(scale: CGFloat) -> CAAnimationGroup {
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = NSNumber(double: 1)
        opacityAnim.toValue = NSNumber(double: 0)
        
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        scaleAnim.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(CATransform3D: CATransform3DMakeScale(scale, scale, scale))
        
        let group = CAAnimationGroup()
        group.animations = [opacityAnim, scaleAnim]
        group.duration = 0.5
        group.delegate = self
        group.fillMode = kCAFillModeBoth
        group.removedOnCompletion = false
        return group
    }
    
}

