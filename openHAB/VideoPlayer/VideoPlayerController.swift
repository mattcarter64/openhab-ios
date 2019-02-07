//
//  VideoPlayerController.swift
//  openHAB
//
//  Created by Matt Carter on 1/29/19.
//  Copyright © 2019 openHAB e.V. All rights reserved.
//

import os
import UIKit

@objc class VideoPlayerController: UIViewController {
    
    @objc var player: VideoPlayer?
    
    override func viewDidLoad() {
       
        if #available(iOS 10.0, *) {
            os_log("LifePlayerController: viewDidLoad:")
        } else {
            // Fallback on earlier versions
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 10.0, *) {
            os_log("LifePlayerController: viewWillAppear:")
        } else {
            // Fallback on earlier versions
        }
        
        super.viewWillAppear(animated)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        
        if #available(iOS 10.0, *) {
            os_log("LifePlayerController: viewDidAppear:")
        } else {
            // Fallback on earlier versions
        }
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            os_log("LifePlayerController: viewWillDisappear:")
        } else {
            // Fallback on earlier versions
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            os_log("LifePlayerController: viewDidDisappear:")
        } else {
            // Fallback on earlier versions
        }
        
        player?.stop()
        
        super.viewDidDisappear(animated)
    }
}
