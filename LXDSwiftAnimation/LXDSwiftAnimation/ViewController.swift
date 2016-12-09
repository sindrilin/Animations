//
//  ViewController.swift
//  LXDSwiftAnimation
//
//  Created by linxinda on 16/10/10.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

import UIKit

let baseY: CGFloat = 150
let maxScale: CGFloat = 2
let maxOffsetY: CGFloat = 60


enum DisplayState: Int {
    case normal = 0
    case expand = 1
    case tight = 2
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var state: DisplayState = .normal
    
    var tableView: UITableView = UITableView()
    var titleView: UIImageView = UIImageView(image: UIImage(named: "placeholder"))
    var contentView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: maxOffsetY, width: 36, height: 36))
    var headerView: TableViewHeaderView = TableViewHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: baseY))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleView.frame = contentView.frame
        titleView.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
        contentView.clipsToBounds = false
        contentView.addSubview(titleView)
        navigationItem.titleView = contentView
        contentView.contentSize = CGSize(width: 0, height: maxOffsetY + titleView.frame.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.superview == nil {
            tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
            tableView.delegate = self
            tableView.dataSource = self
            view.addSubview(tableView)
            view.addSubview(headerView)
            tableView.clipsToBounds = false
            tableView.separatorStyle = .none
            tableView.backgroundColor = .white
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsets(top: baseY, left: 0, bottom: 0, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "   line".appending("\(indexPath.row)")
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var base: CGFloat = baseY
        var controlY: CGFloat = baseY
        let actualOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        print("\(scrollView.contentOffset.y) -- \(scrollView.contentInset.top)")
        print(actualOffset)
        
        switch state {
        case .normal:
            if actualOffset < 0 {
                if scrollView.contentInset == .zero {
                    base = fabs(actualOffset)
                    controlY = base
                    let ratio = base / baseY
                    titleView.transform = CGAffineTransform(scaleX: (1 + ratio), y: (1 + ratio))
                    contentView.contentOffset = CGPoint(x: 0, y: maxOffsetY * (1 - ratio))
                } else {
                    state = .expand
                }
            } else {
                titleView.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                contentView.contentOffset = CGPoint(x: 0, y: 0)
                if actualOffset < baseY {
                    base = baseY - actualOffset
                    controlY = base
                    let ratio = actualOffset / baseY
                    titleView.transform = CGAffineTransform(scaleX: (maxScale - ratio), y: (maxScale - ratio))
                    contentView.contentOffset = CGPoint(x: 0, y: maxOffsetY * ratio)
                } else if scrollView.isDragging {
                    state = .tight
                    scrollViewDidScroll(scrollView)
                }
            }
            break
            
        case .expand:
            if actualOffset > 0 {
                state = .normal
            } else {
                var offset = min(baseY * 2, fabs(actualOffset))
                if offset != 0 {
                    offset *= (6 / CGFloat(sqrt(offset)))
                }
                base = baseY
                controlY = baseY + offset
            }
            break
            
        case .tight:
            base = 0
            controlY = 0
            if actualOffset < baseY && scrollView.isDragging {
                state = .normal
            } else {
                titleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                contentView.contentOffset = CGPoint(x: 0, y: maxOffsetY)
            }
            break
        }
        headerView.updateLayer(controlY: controlY, base: base)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if state == .tight {
            tableView.contentInset = .zero
            tableView.setContentOffset(.zero, animated: true)
        } else {
            tableView.contentInset = UIEdgeInsets(top: baseY, left: 0, bottom: 0, right: 0)
            tableView.setContentOffset(.zero, animated: true)
        }
    }
    
}

