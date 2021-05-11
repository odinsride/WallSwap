//
//  ScreenController.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/30/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Foundation
import Cocoa

final class ScreenController {
    
    func getScreenRatio() -> Float {
        let screen = NSScreen.main
        let width = Float((screen?.visibleFrame.size.width)!)
        let height = Float((screen?.visibleFrame.size.height)!)
        
        let ratio = width / height
        
        return ratio
    }

}
