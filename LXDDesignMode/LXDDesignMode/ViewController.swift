//
//  ViewController.swift
//  LXDDesignMode
//
//  Created by linxinda on 16/10/8.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

import UIKit


class DataManager {
    private static var shareStorage = [String: AnyObject]()
    private var storeKey = "DefaultKey"
    private var storeData = [AnyObject]()
    
    var data: [AnyObject] {
        get {
            return storeData
        }
    }
    
    //MARK: - Initializer
    init() {
        initalizeData()
    }
    
    init(storeKey: String) {
        self.storeKey = storeKey
        initalizeData()
    }
    
    deinit {
        save()
        let count = DataManager.shareStorage[countKey()] as! Int
        if count == 1 {
            DataManager.shareStorage[storeKey] = nil
        } else {
            DataManager.shareStorage[countKey()] = (count - 1) as AnyObject?
        }
    }
    
    //MARK: - Private
    private func initalizeData() {
        if let data = DataManager.shareStorage[storeKey] {
            let count = DataManager.shareStorage[countKey()] as! Int
            DataManager.shareStorage[countKey()] = (count + 1) as AnyObject?
            storeData = data as! [AnyObject]
        } else {
            loadData()
            DataManager.shareStorage[countKey()] = 1 as AnyObject
            DataManager.shareStorage[storeKey] = storeData as AnyObject?
        }
    }
    
    private func countKey() -> String {
        return "\(storeKey)Count"
    }
    
    private func loadData() {
        //  load data from local path
    }
    
    //MARK: - Operate
    func insert(data: AnyObject) { }
    func delete(at index: Int) { }
    func save() { }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

