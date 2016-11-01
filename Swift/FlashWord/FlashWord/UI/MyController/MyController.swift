//
//  MyController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class MyController: DYViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnUpdate() {
        Navigator.pushURL("/vocabulary/update")
    }

}
