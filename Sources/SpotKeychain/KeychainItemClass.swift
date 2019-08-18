//
//  KeychainItemClass.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

public enum KeychainItemClass: RawRepresentable {
	case genericPassword
	case internetPassword
	
	public typealias RawValue = String
	
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = .genericPassword
        case String(kSecClassInternetPassword):
            self = .internetPassword
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .genericPassword:
            return String(kSecClassGenericPassword)
        case .internetPassword:
            return String(kSecClassInternetPassword)
        }
    }
}
