//
//  PreferencesCoordinator.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/29/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Foundation
import Cocoa

protocol PreferencesCoordinatorDelegate: class {
    func preferencesCoordinatorDidDismiss()
}

class PreferencesCoordinator {
    private let wallpaperController: WallpaperController
    
    private var preferencesWindowController: PreferencesWindowController?
    private var paneControllers: [PreferencesPane: NSViewController] = [:]
    private var activePane: PreferencesPane = .general
    
    weak var delegate: PreferencesCoordinatorDelegate?
    
    init(wallpaperController: WallpaperController) {
        self.wallpaperController = wallpaperController
    }
    
    func showPreferences() {
        if preferencesWindowController == nil {
            preferencesWindowController = PreferencesWindowController()
            preferencesWindowController?.delegate = self
        }
        preferencesWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    private func activatePane(_ pane: PreferencesPane) {
        guard pane != activePane else {
            return
        }
        
        preferencesWindowController?.contentViewController = paneControllers[pane]
        activePane = pane
    }
}

extension PreferencesCoordinator: PreferencesWindowDelegate {
    func preferencesWindowDidLoad() {
        let generalVC = GeneralPreferencesViewController()
        generalVC.delegate = self
        
        paneControllers = [
            .general: generalVC,
        ]
        
        preferencesWindowController?.contentViewController = generalVC
    }
    
    func preferencesWindowDidDismiss() {
        preferencesWindowController = nil
        delegate?.preferencesCoordinatorDidDismiss()
    }
    
    func preferencesWindowDidChangePane(to pane: PreferencesPane) {
        activatePane(pane)
    }
}

extension PreferencesCoordinator: GeneralPreferencesViewDelegate {
    var wallpaper1URL: URL {
        return URL(fileURLWithPath: wallpaperController.wallpaper1Path)
    }
    
    var wallpaper2URL: URL {
        return URL(fileURLWithPath: wallpaperController.wallpaper2Path)
    }
    
    var autoSwapEnabled: NSControl.StateValue {
        return wallpaperController.autoSwapToggle
    }
    
    var startAtLoginEnabled: NSControl.StateValue {
        return wallpaperController.startAtLoginToggle
    }
    
    func generalPreferencesDidChangeWallpaper1URL(to url: URL) {
        wallpaperController.wallpaper1Path = url.path
    }
    
    func generalPreferencesDidChangeWallpaper2URL(to url: URL) {
        wallpaperController.wallpaper2Path = url.path
    }
    
    func generalPreferencesDidChangeAutoSwap(to autoSwap: NSControl.StateValue) {
        wallpaperController.autoSwapToggle = autoSwap
    }
    
    func generalPreferencesDidChangeStartAtLogin(to startAtLogin: NSControl.StateValue) {
        wallpaperController.startAtLoginToggle = startAtLogin
    }
}
