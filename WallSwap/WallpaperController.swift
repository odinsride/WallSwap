//
//  WallpaperController.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/26/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

final class WallpaperController {
    private static let wallpaper1PathKey = "Wallpaper1Path"
    private static let wallpaper2PathKey = "Wallpaper2Path"
    private static let autoToggleKey = "AutoToggleEnabled"
    private static let startAtLoginKey = "StartAtLoginEnabled"

    private let userDefaults: UserDefaults
    private let screenController: ScreenController
    
    // Ultrawide Wallpaper (For External Display)
    var wallpaper1Path: String {
        get {
            return userDefaults.string(forKey: WallpaperController.wallpaper1PathKey) ?? "nil"
        }
        set {
            userDefaults.set(newValue, forKey: WallpaperController.wallpaper1PathKey)
        }
    }
    
    // Standard 16:9 Wallpaper (For Laptop Display)
    var wallpaper2Path: String {
        get {
            return userDefaults.string(forKey: WallpaperController.wallpaper2PathKey) ?? "nil"
        }
        set {
            userDefaults.set(newValue, forKey: WallpaperController.wallpaper2PathKey)
        }
    }
    
    var autoSwapToggle: NSControl.StateValue {
        get {
            return NSControl.StateValue(userDefaults.integer(forKey: WallpaperController.autoToggleKey))
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: WallpaperController.autoToggleKey)
        }
    }
    
    var startAtLoginToggle: NSControl.StateValue {
        get {
            return NSControl.StateValue(userDefaults.integer(forKey: WallpaperController.startAtLoginKey))
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: WallpaperController.startAtLoginKey)
        }
    }
    
    init(userDefaults: UserDefaults,
         screenController: ScreenController) {
        self.userDefaults = userDefaults
        self.screenController = screenController
    }
    
    func autoSwap() {
        if autoSwapToggle == .on {
            let ratio = self.screenController.getScreenRatio()
            //print(ratio)
            
            switch ratio {
            case 2.33..<2.5:
                setWallpaper(wallpaperPath: wallpaper1Path)
            default:
                setWallpaper(wallpaperPath: wallpaper2Path)
            }
        }
    }
    
    func setWallpaper(wallpaperPath: String) {
        do {
            let imgUrl = NSURL.fileURL(withPath: wallpaperPath)
            let workspace = NSWorkspace.shared
            
            if let screen = NSScreen.main {
                try workspace.setDesktopImageURL(imgUrl, for: screen, options: [:])
            }
        } catch {
            print(error)
        }
    }
}
