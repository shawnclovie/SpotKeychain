//
//  KeychainAttributes.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

public struct KeychainAttributes {
	public var `class`: String? {
		attributes[Keychain.Class] as? String
	}
	public var data: Data? {
		attributes[Keychain.ValueData] as? Data
	}
	public var ref: Data? {
		attributes[Keychain.ValueRef] as? Data
	}
	public var persistentRef: Data? {
		attributes[Keychain.ValuePersistentRef] as? Data
	}
	
	public var accessible: String? {
		attributes[Keychain.AttributeAccessible] as? String
	}
	
	public var accessControl: SecAccessControl? {
		if #available(OSX 10.10, *),
			let accessControl = attributes[Keychain.AttributeAccessControl] {
			return (accessControl as! SecAccessControl)
		}
		return nil
	}
	public var accessGroup: String? {
		attributes[Keychain.AttributeAccessGroup] as? String
	}
	public var synchronizable: Bool? {
		attributes[Keychain.AttributeSynchronizable] as? Bool
	}
	public var creationDate: Date? {
		attributes[Keychain.AttributeCreationDate] as? Date
	}
	public var modificationDate: Date? {
		attributes[Keychain.AttributeModificationDate] as? Date
	}
	public var attributeDescription: String? {
		attributes[Keychain.AttributeDescription] as? String
	}
	public var comment: String? {
		attributes[Keychain.AttributeComment] as? String
	}
	public var creator: String? {
		attributes[Keychain.AttributeCreator] as? String
	}
	public var type: String? {
		attributes[Keychain.AttributeType] as? String
	}
	public var label: String? {
		attributes[Keychain.AttributeLabel] as? String
	}
	public var isInvisible: Bool? {
		attributes[Keychain.AttributeIsInvisible] as? Bool
	}
	public var isNegative: Bool? {
		attributes[Keychain.AttributeIsNegative] as? Bool
	}
	public var account: String? {
		attributes[Keychain.AttributeAccount] as? String
	}
	public var service: String? {
		attributes[Keychain.AttributeService] as? String
	}
	public var generic: Data? {
		attributes[Keychain.AttributeGeneric] as? Data
	}
	public var securityDomain: String? {
		attributes[Keychain.AttributeSecurityDomain] as? String
	}
	public var server: String? {
		attributes[Keychain.AttributeServer] as? String
	}
	public var `protocol`: KeychainProtocolType? {
		if let proto = attributes[Keychain.AttributeProtocol] as? String {
			return KeychainProtocolType(rawValue: proto)
		}
		return nil
	}
	
	public var authenticationType: KeychainAuthenticationType? {
		if let auth = attributes[Keychain.AttributeAuthenticationType] as? String {
			return KeychainAuthenticationType(rawValue: auth)
		}
		return nil
	}
	
	public var port: Int? {
		attributes[Keychain.AttributePort] as? Int
	}
	public var path: String? {
		attributes[Keychain.AttributePath] as? String
	}
	
	private let attributes: [String: Any]
	
	init(attributes: [String: Any]) {
		self.attributes = attributes
	}
	
	public subscript(key: String) -> Any? {
		attributes[key]
	}
}
