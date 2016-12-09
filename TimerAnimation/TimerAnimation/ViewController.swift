//
//  ViewController.swift
//  TimerAnimation
//
//  Created by linxinda on 2016/12/5.
//  Copyright © 2016年 Jolimark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let titles = ["NSTimer Animate", "CADisplayLink Animation"]
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = XiuXiuViewController(nibName: "\(XiuXiuViewController.classForCoder())", bundle: nil)
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = SpringViewController(nibName: "\(SpringViewController.classForCoder())", bundle: nil)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

