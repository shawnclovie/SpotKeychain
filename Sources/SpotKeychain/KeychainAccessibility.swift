//
//  KeychainAccessibility.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

public enum KeychainAccessibility {
	/**
	Item data can only be accessed
	while the device is unlocked. This is recommended for items that only
	need be accesible while the application is in the foreground. Items
	with this attribute will migrate to a new device when using encrypted
	backups.
	*/
	case whenUnlocked
	
	/**
	Item data can only be
	accessed once the device has been unlocked after a restart. This is
	recommended for items that need to be accesible by background
	applications. Items with this attribute will migrate to a new device
	when using encrypted backups.
	*/
	case afterFirstUnlock
	
	/**
	Item data can always be accessed
	regardless of the lock state of the device. This is not recommended
	for anything except system use. Items with this attribute will migrate
	to a new device when using encrypted backups.
	*/
	case always
	
	/**
	Item data can
	only be accessed while the device is unlocked. This class is only
	available if a passcode is set on the device. This is recommended for
	items that only need to be accessible while the application is in the
	foreground. Items with this attribute will never migrate to a new
	device, so after a backup is restored to a new device, these items
	will be missing. No items can be stored in this class on devices
	without a passcode. Disabling the device passcode will cause all
	items in this class to be deleted.
	*/
	@available(iOS 8.0, OSX 10.10, *)
	case whenPasscodeSetThisDeviceOnly
	
	/**
	Item data can only
	be accessed while the device is unlocked. This is recommended for items
	that only need be accesible while the application is in the foreground.
	Items with this attribute will never migrate to a new device, so after
	a backup is restored to a new device, these items will be missing.
	*/
	case whenUnlockedThisDeviceOnly
	
	/**
	Item data can
	only be accessed once the device has been unlocked after a restart.
	This is recommended for items that need to be accessible by background
	applications. Items with this attribute will never migrate to a new
	device, so after a backup is restored to a new device these items will
	be missing.
	*/
	case afterFirstUnlockThisDeviceOnly
	
	/**
	Item data can always
	be accessed regardless of the lock state of the device. This option
	is not recommended for anything except system use. Items with this
	attribute will never migrate to a new device, so after a backup is
	restored to a new device, these items will be missing.
	*/
	case alwaysThisDeviceOnly
}

extension KeychainAccessibility: RawRepresentable {

    public init?(rawValue: String) {
		switch rawValue {
		case String(kSecAttrAccessibleWhenUnlocked):
			self = .whenUnlocked
		case String(kSecAttrAccessibleAfterFirstUnlock):
			self = .afterFirstUnlock
		case String(kSecAttrAccessibleAlways):
			self = .always
		case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
			self = .whenUnlockedThisDeviceOnly
		case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
			self = .afterFirstUnlockThisDeviceOnly
		case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
			self = .alwaysThisDeviceOnly
		default:
			if #available(OSX 10.10, *),
				rawValue == String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly) {
					self = .whenPasscodeSetThisDeviceOnly
			} else {
				return nil
			}
        }
    }

    public var rawValue: String {
        switch self {
        case .whenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case .afterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case .always:
            return String(kSecAttrAccessibleAlways)
        case .whenPasscodeSetThisDeviceOnly:
            if #available(OSX 10.10, *) {
                return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            } else {
                fatalError("'Accessibility.WhenPasscodeSetThisDeviceOnly' is not available on this version of OS.")
            }
        case .whenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .afterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .alwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}
