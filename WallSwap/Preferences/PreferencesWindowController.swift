//
//  PreferencesWindowController.swift
//  WallSwap
//
//  Created by Kevin Custer on 7/29/19.
//  Copyright © 2019 Kevin Custer. All rights reserved.
//

import Cocoa

enum PreferencesPane {
    case general
}

protocol PreferencesWindowDelegate: class {
    func preferencesWindowDidLoad()
    func preferencesWindowDidDismiss()
    func preferencesWindowDidChangePane(to pane: PreferencesPane)
}

final class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    weak var delegate: PreferencesWindowDelegate?
    @IBOutlet private weak var toolbar: NSToolbar!
    
    override var windowNibName: NSNib.Name? {
        return "PreferencesWindow"
    }
    
    init() {
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        delegate?.preferencesWindowDidLoad()
        toolbar.selectedItemIdentifier = NSToolbarItem.Identifier("generalPane")
        window?.delegate = self
    }
    
    func windowWillClose(_ notification: Notification) {
        delegate?.preferencesWindowDidDismiss()
    }
    
    @IBAction private func generalPaneClicked(_ sender: Any) {
        delegate?.preferencesWindowDidChangePane(to: .general)
    }
}
