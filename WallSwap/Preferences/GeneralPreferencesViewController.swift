//
//  GeneralPreferencesViewController.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/29/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Foundation
import Cocoa

protocol GeneralPreferencesViewDelegate: class {
    var wallpaper1URL: URL { get }
    var wallpaper2URL: URL { get }
    var autoSwapEnabled: NSControl.StateValue { get }
    var startAtLoginEnabled: NSControl.StateValue { get }
    func generalPreferencesDidChangeWallpaper1URL(to url: URL)
    func generalPreferencesDidChangeWallpaper2URL(to url: URL)
    func generalPreferencesDidChangeAutoSwap(to autoSwap: NSControl.StateValue)
    func generalPreferencesDidChangeStartAtLogin(to startAtLogin: NSControl.StateValue)
}

final class GeneralPreferencesViewController: NSViewController {
    

    @IBOutlet private weak var wallpaper1Label: NSTextField!
    @IBOutlet private weak var wallpaper2Label: NSTextField!
    @IBOutlet private weak var autoSwapToggle: NSButton!
    @IBOutlet private weak var startAtLoginToggle: NSButton!
    
    weak var delegate: GeneralPreferencesViewDelegate?
    
    override var nibName: NSNib.Name? {
        return "GeneralPreferencesView"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wallpaper1Label.stringValue = delegate?.wallpaper1URL.path ?? ""
        wallpaper2Label.stringValue = delegate?.wallpaper2URL.path ?? ""
        autoSwapToggle.state = delegate?.autoSwapEnabled ?? NSControl.StateValue.on
        startAtLoginToggle.state = delegate?.startAtLoginEnabled ?? NSControl.StateValue.off
    }
    
    @IBAction private func browseWallpaper1ButtonClicked(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.title = "Choose Wallpaper 1 (Ultrawide)"
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canCreateDirectories = true
        panel.prompt = "Choose"
        panel.allowedFileTypes = ["jpg", "png", "gif"]
        
        if let picturesDir = try? FileManager.default.url(for: .picturesDirectory,
                                                      in: .systemDomainMask,
                                                      appropriateFor: nil,
                                                      create: false) {
            panel.directoryURL = picturesDir
        }
        
        panel.beginSheetModal(for: view.window!) { response in
            if response == .OK {
                self.delegate?.generalPreferencesDidChangeWallpaper1URL(to: panel.url!)
                self.wallpaper1Label.stringValue = panel.url!.path
            }
        }
    }
    
    @IBAction private func browseWallpaper2ButtonClicked(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.title = "Choose Wallpaper 2 (Standard)"
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canCreateDirectories = true
        panel.prompt = "Choose"
        panel.allowedFileTypes = ["jpg", "png", "gif"]
        
        if let picturesDir = try? FileManager.default.url(for: .picturesDirectory,
                                                      in: .systemDomainMask,
                                                      appropriateFor: nil,
                                                      create: false) {
            panel.directoryURL = picturesDir
        }
        
        panel.beginSheetModal(for: view.window!) { response in
            if response == .OK {
                self.delegate?.generalPreferencesDidChangeWallpaper2URL(to: panel.url!)
                self.wallpaper2Label.stringValue = panel.url!.path
            }
        }
    }
    
    @IBAction private func autoSwapToggleButtonClicked(_ sender: NSButton) {
        self.delegate?.generalPreferencesDidChangeAutoSwap(to: self.autoSwapToggle.state)
    }
    
    @IBAction private func startAtLoginButtonClicked(_ sender: NSButton) {
        self.delegate?.generalPreferencesDidChangeStartAtLogin(to: self.startAtLoginToggle.state)
    }}
