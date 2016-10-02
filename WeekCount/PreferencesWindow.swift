//
//  PreferencesWindow.swift
//  WeekCount
//
//  Created by Li on 16/6/13.
//  Copyright © 2016 Jinli Wang. All rights reserved.
//

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

import Cocoa

class PreferencesWindow: NSWindowController, NSWindowDelegate, NSTextFieldDelegate {

    @IBOutlet var startDatePicker: NSDatePicker!
    @IBOutlet var lastCountField: NSTextField!
    @IBOutlet var lastStepper: NSStepper!
    @IBAction func stepperClicked(sender: NSStepper) {
        lastCountField.stringValue = "\(sender.intValue)"
    }
    @IBOutlet var displayFormatField: NSTextField!
    @IBOutlet var fontSizeStepper: NSStepper!
    @IBAction func fontSizeStepperClicked(sender: NSStepper) {
        fontSizeField.stringValue = "\(sender.floatValue)"
        UserDefaults.standard.setValue(fontSizeField.stringValue, forKey: "fontSize")
        delegate?.preferencesDidUpdate()
    }
    @IBOutlet var fontSizeField: NSTextField!
    
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName: String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        NSApp.activate(ignoringOtherApps: true)
        
        lastCountField.delegate = self
        fontSizeField.delegate = self
        displayFormatField.delegate = self
        
        displayPreferences()
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        displayPreferences()
    }
    
    func displayPreferences() {
        let defaults = UserDefaults.standard
        startDatePicker.dateValue = defaults.value(forKey: "startDate") as? Date ?? DEFAULT_STARTDATE
        lastCountField.stringValue = defaults.string(forKey: "lastCount") ?? String(DEFAULT_LASTCOUNT)
        displayFormatField.stringValue = defaults.string(forKey: "displayFormat") ?? DEFAULT_DISPLAYFORMAT
        fontSizeField.stringValue = defaults.string(forKey: "fontSize") ?? String(DEFAULT_FONTSIZE)
        
        lastStepper.intValue = lastCountField.intValue
        fontSizeStepper.floatValue = fontSizeField.floatValue
    }
    
    
    override func controlTextDidChange(notification: NSNotification) {
        let object = notification.object as! NSTextField
        if object.tag == 15 {
            fontSizeStepper.floatValue = object.floatValue
        }
        updatePreferences()
    }
    
    func windowWillClose(notification: NSNotification) {
        updatePreferences()
    }
    
    func updatePreferences() {
        let defaults = UserDefaults.standard
        defaults.setValue(startDatePicker.dateValue, forKey: "startDate")
        if Int(lastCountField.stringValue) != nil {
            defaults.setValue(lastCountField.stringValue, forKey: "lastCount")
        }
        defaults.setValue(displayFormatField.stringValue, forKey: "displayFormat")
        if Float(fontSizeField.stringValue) != nil {
            defaults.setValue(fontSizeField.stringValue, forKey: "fontSize")
        }
        defaults.synchronize()
        
        delegate?.preferencesDidUpdate()
    }
    
}
