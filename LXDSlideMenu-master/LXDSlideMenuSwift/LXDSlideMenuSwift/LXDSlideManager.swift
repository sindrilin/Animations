//
//  LXDSlideManager.swift
//  LXDSlideMenuSwift
//
//  Created by linxinda on 15/11/29.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

import UIKit

public enum LXDSlideMenuType: Int {
    case BothMove           //主界面跟侧滑界面共同移动
    case MenuMove          //只移动侧滑菜单界面
}

public enum LXDDemoType: Int {
    case OnWindow          //加在keyWindow上，如果不是从AppDelegate进行rootViewController的初始化，此选项无效
    case OnMainView       //加在主视图上
}


let maxOpenRatio: CGFloat = 0.7             //最大滑动屏幕宽度比例
let kWidth: CGFloat = UIScreen.mainScreen().bounds.size.width

var kMainController: UIViewController?  //主视图控制器
var kMenuController: UIViewController? //边栏视图控制器

class LXDSlideManager: NSObject {
    
    private var isOpen: Bool?
    var slideType: LXDSlideMenuType! = .BothMove
    private var demoType: LXDDemoType! = .OnMainView
    private var snapView: UIView?
    
    lazy private var tap: UITapGestureRecognizer? = {
        return UITapGestureRecognizer(target: self, action: "openOrClose")
    }()
    
    
    /** 单例*/
    private static let let_sharedManager: LXDSlideManager = LXDSlideManager()
    class func sharedManager() -> LXDSlideManager {
        return let_sharedManager
    }
    
    /** 让构造器私有化无法使用*/
    private override init() {
        super.init()
    }
    
    deinit {
        kMainController = nil
        kMenuController = nil
    }
}


extension LXDSlideManager {
    
    func setMainController(mainController: UIViewController!) {
        kMainController?.view.removeGestureRecognizer(self.tap!)
        kMainController?.view.removeFromSuperview()
        kMainController = mainController
        
        if kMenuController != nil {
            kMenuController?.view.removeFromSuperview()
            
            if demoType == .OnMainView {
                mainController.view.addSubview((kMenuController?.view)!)
            }
        }
    }
    
    func setMenuController(menuController: UIViewController!) {
        kMenuController?.view.removeFromSuperview()
        kMenuController = menuController
        let menuFrame: CGRect = CGRectOffset(UIScreen.mainScreen().bounds, kWidth, 0)
        menuController.view.frame = menuFrame
        
        if kMainController != nil && demoType == .OnMainView {
            kMainController?.view.addSubview((menuController.view)!)
        } else if demoType == .OnWindow {
            AppDelegate.getDelegate().window?.addSubview(menuController.view)
        }
    }
    
    func setDemoType(demoType: LXDDemoType) {
        self.demoType = demoType
        kMenuController?.view.removeFromSuperview()
        
        if demoType == .OnWindow {
            if kMenuController != nil {
                AppDelegate.getDelegate().window?.addSubview((kMenuController?.view)!)
            }
        } else if demoType == .OnMainView {
            if kMainController != nil && kMenuController != nil {
                kMainController?.view.addSubview((kMenuController?.view)!)
            }
        }
    }
}


extension LXDSlideManager {
    
    func openOrClose() {
        if isOpen == true {
            self.close()
        } else {
            self.open()
        }
    }
    
    private func useSnap() -> Bool {
        return slideType == .BothMove && demoType == .OnMainView
    }
    
    private func open() {
        isOpen = true
        
        if kMenuController == nil || kMainController == nil {
            fatalError("you can not slide view when one or more of menu view and main view is nil")
        }
        
        var menuFrame: CGRect = (kMenuController?.view.frame)!
        var mainFrame: CGRect = (kMainController?.view.frame)!
        snapView = (kMainController?.view.snapshotViewAfterScreenUpdates(false))!
        
        if slideType == .MenuMove || self.demoType == .OnWindow {
            menuFrame.origin.x = (1 - maxOpenRatio) * kWidth
        }
        if slideType == .BothMove {
            if self.useSnap() {
                snapView!.frame = (kMainController?.view.frame)!
                kMainController?.view.addSubview(snapView!)
                menuFrame.origin.x = (1 - maxOpenRatio) * kWidth
            }
            mainFrame.origin.x = -kWidth * maxOpenRatio
        }
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            if self.useSnap() {
                self.snapView?.frame = mainFrame
            } else {
                kMainController?.view.frame = mainFrame
            }
            kMenuController?.view.frame = menuFrame
            },  completion: { (finished: Bool) -> Void in
                if finished == true {
                    if self.useSnap() {
                        self.snapView?.addGestureRecognizer(self.tap!)
                    } else {
                        kMainController?.view.addGestureRecognizer(self.tap!)
                    }
                }
        })
    }
    
    private func close() {
        isOpen = false
        kMenuController?.view.endEditing(true)
        kMainController?.view.removeGestureRecognizer(self.tap!)
        var menuFrame: CGRect = (kMenuController?.view.frame)!
        var mainFrame: CGRect = (kMainController?.view.frame)!
        mainFrame.origin.x = 0
        
        if slideType == .MenuMove || demoType == .OnWindow {
            menuFrame.origin.x = kWidth
        }
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            if self.useSnap() {
                self.snapView?.frame = mainFrame
                menuFrame.origin.x = kWidth
                kMenuController?.view.frame = menuFrame
            } else {
                kMainController?.view.frame = mainFrame
            }
            kMenuController?.view.frame = menuFrame
            }, completion:  { (finished: Bool) -> Void in
                if finished {
                    self.snapView?.removeFromSuperview()
                }
        })
    }
}

