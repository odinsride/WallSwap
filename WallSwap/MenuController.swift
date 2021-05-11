//
//  MenuController.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/25/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Foundation
import AppKit

protocol MenuControllerDelegate: class {
    func menuControllerDidInvokePreferences()
}

class MenuController: NSObject, NSMenuDelegate {
    // dependencies
    private let menu: NSMenu
    private let wallpaperController: WallpaperController

    // state
    private var menuItems: [NSMenuItem]
    
    weak var delegate: MenuControllerDelegate?
        
    init(menu: NSMenu,
         wallpaperController: WallpaperController) {
        self.menu = menu
        self.wallpaperController = wallpaperController
        
        menuItems = []
        
        super.init()
        
        menu.delegate = self
    }
    
    private func rebuildMenu() {
        menuItems.removeAll(keepingCapacity: true)
        
        buildWallSwapMenuItems()
        menuItems.append(NSMenuItem.separator())
        
        menuItems.append(NSMenuItem(title: "Preferences...") { _ in
            self.delegate?.menuControllerDidInvokePreferences()
        })
        menuItems.append(NSMenuItem.separator())

        menuItems.append(NSMenuItem(title: "Quit WallSwap", keyEquivalent: "q") { _ in
            NSApplication.shared.terminate(nil)
        })
    }
    
    private func renderMenu() {
        menu.removeAllItems()
        for item in menuItems {
            menu.addItem(item)
        }
    }
    
    private func buildWallSwapMenuItems() {
        menuItems.append(NSMenuItem(title: "Ultrawide Wallpaper") { _ in
            self.wallpaperController.setWallpaper(wallpaperPath: self.wallpaperController.wallpaper1Path)
        })
        
        menuItems.append(NSMenuItem(title: "Standard Wallpaper") { _ in
            self.wallpaperController.setWallpaper(wallpaperPath: self.wallpaperController.wallpaper2Path)
        })
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        guard menu == self.menu else {
            return
        }
        
        rebuildMenu()
        renderMenu()
    }
    
}
