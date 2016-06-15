//
//  ViewController.swift
//  Live2DDemo
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Custom - Haru"
        case 1:
            cell.textLabel?.text = "Custom - Wanko"
        case 2:
            cell.textLabel?.text = "Custom - Miku"
        case 3:
            cell.textLabel?.text = "Offical - Haru"
        case 4:
            cell.textLabel?.text = "Offical - Haru01"
        case 5:
            cell.textLabel?.text = "Offical - Haru02"
        case 6:
            cell.textLabel?.text = "Offical - Wanko"
        case 7:
            cell.textLabel?.text = "Offical - Shizuku"
        default:
            break
        }
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let customViewController = CustomViewController()
            customViewController.type = .Haru
            self.navigationController?.pushViewController(customViewController, animated: true)
        default:
            break
        }
    }
}

