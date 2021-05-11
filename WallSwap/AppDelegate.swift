//
//  AppDelegate.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/24/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Cocoa
import ServiceManagement
import LaunchAtLogin

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var menuController: MenuController!
    private var preferencesCoordinator: PreferencesCoordinator?
    
    private let wallpaperController: WallpaperController
    private let screenController: ScreenController
    
    override init() {
        screenController = ScreenController()
        wallpaperController = WallpaperController(userDefaults: UserDefaults.standard,
                                                  screenController: screenController)
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if wallpaperController.startAtLoginToggle == .on {
            LaunchAtLogin.isEnabled = true
        }
        else {
            LaunchAtLogin.isEnabled = false
        }
        
        print(LaunchAtLogin.isEnabled)
        
        let statusBar = NSStatusBar.system
        
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem.button?.image = #imageLiteral(resourceName: "statusicon")
        statusItem.button?.image?.isTemplate = true
        statusItem.menu = NSMenu(title: statusItem.button!.title)
        
        NSMenu.setMenuBarVisible(false)
        
        menuController = MenuController(menu: statusItem.menu!,
                                        wallpaperController: wallpaperController)
        menuController.delegate = self
        
        // Detect resolution changes
        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
                                               object: NSApplication.shared,
                                               queue: OperationQueue.main) { _ in
                                                    self.wallpaperController.autoSwap()
                                               }
        
        // Detect desktop changes
        // Need to wait until user changes desktops because there is no API
        //   for setting the wallpaper of other desktop spaces
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.activeSpaceDidChangeNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { _ in
                                                    self.wallpaperController.autoSwap()
                                               }
    }
    
}

extension AppDelegate: MenuControllerDelegate {
    func menuControllerDidInvokePreferences() {
        if preferencesCoordinator == nil {
            preferencesCoordinator = PreferencesCoordinator(wallpaperController: wallpaperController)
            preferencesCoordinator?.delegate = self
        }
        preferencesCoordinator?.showPreferences()
    }
}

extension AppDelegate: PreferencesCoordinatorDelegate {
    func preferencesCoordinatorDidDismiss() {
        preferencesCoordinator = nil
    }
}
