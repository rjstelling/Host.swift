//
//  ViewController.swift
//  iOS Example
//
//  Created by Richard Stelling on 31/05/2016.
//  Copyright © 2016 Richard Stelling. All rights reserved.
//

import UIKit
import Host

class ViewController: UIViewController {

    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var addresses: UILabel!
    @IBOutlet weak var ssid: UILabel!
    
    let host = Host()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostname.text = host.name
        addresses.text = host.addresses.reduce("") {
            return "\($0!)\($1)\n"
        }
        ssid.text = host.ssid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
