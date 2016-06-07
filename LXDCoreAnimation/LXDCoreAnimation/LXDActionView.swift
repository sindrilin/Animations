//
//  LXDActionView.swift
//  LXDCoreAnimation
//
//  Created by 林欣达 on 16/6/7.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

import UIKit

class LXDActionLayer: CALayer {
    override func addAnimation(anim: CAAnimation, forKey key: String?) {
        print("***********************************************")
        print("Layer will add an animation: \(anim)")
        super.addAnimation(anim, forKey: key)
    }
}

class LXDActionView: UIView {

    override class func layerClass() -> AnyClass {
        return LXDActionLayer.classForCoder()
    }
}
