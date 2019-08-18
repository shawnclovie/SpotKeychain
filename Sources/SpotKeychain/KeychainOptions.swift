//
//  KeychainOptions.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

public struct KeychainOptions {
	public var itemClass: KeychainItemClass = .genericPassword
	
	public var service = ""
	public var accessGroup: String?
	
	public var server: URL?
	public var protocolType: KeychainProtocolType?
	public var authenticationType: KeychainAuthenticationType = .default
	
	public var accessibility: KeychainAccessibility = .afterFirstUnlock
	public var authenticationPolicy: KeychainAuthenticationPolicy?
	
	public var synchronizable = false
	
	public var label: String?
	public var comment: String?
	
	public var authenticationPrompt: String?
	/// since iOS9, OSX10.11
	public var authenticationContext: AnyObject?
	
	public var attributes = [String: Any]()
	
	public init(service: String? = nil) {
		if let value = service {
			self.service = value
		}
	}
}

extension KeychainOptions {
	
	func query() -> [String: Any] {
		var query: [String: Any] = [
			Keychain.Class: itemClass.rawValue,
			Keychain.AttributeSynchronizable: Keychain.SynchronizableAny,
		]
		switch itemClass {
		case .genericPassword:
			query[Keychain.AttributeService] = service
			// Access group is not supported on any simulators.
			#if (!arch(i386) && !arch(x86_64)) || (!os(iOS) && !os(watchOS) && !os(tvOS))
				if let accessGroup = self.accessGroup {
					query[Keychain.AttributeAccessGroup] = accessGroup
				}
			#endif
		case .internetPassword:
			if let server = server {
				query[Keychain.AttributeServer] = server.host
				query[Keychain.AttributePort] = server.port
			}
			if let type = protocolType {
				query[Keychain.AttributeProtocol] = type.rawValue
			}
			query[Keychain.AttributeAuthenticationType] = authenticationType.rawValue
		}
		if #available(OSX 10.10, *) {
			if authenticationPrompt != nil {
				query[Keychain.UseOperationPrompt] = authenticationPrompt
			}
		}
		#if !os(watchOS)
			if #available(iOS 9.0, OSX 10.11, *) {
				if authenticationContext != nil {
					query[Keychain.UseAuthenticationContext] = authenticationContext
				}
			}
		#endif
		return query
	}
	
	func attributes(key: String?, value: Data) -> ([String: Any], Error?) {
		var attributes: [String: Any]
		if let key = key {
			attributes = query()
			attributes[Keychain.AttributeAccount] = key
		} else {
			attributes = [:]
		}
		attributes[Keychain.ValueData] = value
		if label != nil {
			attributes[Keychain.AttributeLabel] = label
		}
		if comment != nil {
			attributes[Keychain.AttributeComment] = comment
		}
		if let policy = authenticationPolicy {
			if #available(OSX 10.10, *) {
				var error: Unmanaged<CFError>?
				guard let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, SecAccessControlCreateFlags(rawValue: CFOptionFlags(policy.rawValue)), &error) else {
					if let error = error?.takeUnretainedValue() {
						return (attributes, error.error)
					}
					return (attributes, KeychainStatus.unexpectedError)
				}
				attributes[Keychain.AttributeAccessControl] = accessControl
			} else {
				print("Unavailable 'Touch ID integration' on OS X versions prior to 10.10.")
			}
		} else {
			attributes[Keychain.AttributeAccessible] = accessibility.rawValue
		}
		attributes[Keychain.AttributeSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
		return (attributes, nil)
	}
}
