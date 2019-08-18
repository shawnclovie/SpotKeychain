//
//  Keychain.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation
import Security
#if os(iOS) || os(macOS)
	import LocalAuthentication
#endif

public final class Keychain {
	public static let bundleDefault = Keychain()
	
	public let options: KeychainOptions
	
	/// Initialize KeyChain
	///
	/// - Parameters:
	///   - service: Service name, BundleID by default.
	///   - accessGroup: Access Group name, nil by default.
	public init(service: String? = Bundle.main.bundleIdentifier, accessGroup: String? = nil) {
		var options = KeychainOptions(service: service)
		options.accessGroup = accessGroup
		self.options = options
	}
	
	public init(server: URL, protocolType: KeychainProtocolType, authenticationType: KeychainAuthenticationType = .default) {
		var options = KeychainOptions()
		options.itemClass = .internetPassword
		options.server = server
		options.protocolType = protocolType
		options.authenticationType = authenticationType
		self.options = options
	}
	
	public init(_ opts: KeychainOptions) {
		options = opts
	}
	
	// MARK: - Content query
	
	public func string(forKey key: String, encoding: String.Encoding = .utf8) throws -> String? {
		guard let data = try data(forKey: key) else  {
			return nil
		}
		guard let string = String(data: data, encoding: encoding) else {
			throw KeychainStatus.conversionError
		}
		return string
	}
	
	public func data(forKey key: String) throws -> Data? {
		var query = options.query()
		query[Keychain.MatchLimit] = Keychain.MatchLimitOne
		query[Keychain.ReturnData] = kCFBooleanTrue
		query[Keychain.AttributeAccount] = key
		
		var result: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &result)
		
		switch status {
		case errSecSuccess:
			guard let data = result as? Data else {
				throw KeychainStatus.unexpectedError
			}
			return data
		case errSecItemNotFound:
			return nil
		default:
			throw KeychainStatus(status: status)
		}
	}
	
	/// Copy items
	///
	/// - Parameters:
	///   - type: Appoint class by the type if non-nil.
	///   - synchronizableOnly: should copy synchronizable item only
	///   - includeData: include data in each item, only work on iOS / watchOS / tvOS
	/// - Returns: item array
	public func quaryItems(of type: KeychainItemClass? = nil,
						   synchronizableOnly: Bool = false,
						   includeData: Bool = false) -> [KeychainAttributes] {
		var query = options.query()
		if let type = type {
			query[Keychain.Class] = type.rawValue
		}
		if !synchronizableOnly {
			query[Keychain.AttributeSynchronizable] = Keychain.SynchronizableAny
		}
		query[Keychain.MatchLimit] = Keychain.MatchLimitAll
		query[Keychain.ReturnAttributes] = kCFBooleanTrue
		#if os(iOS) || os(watchOS) || os(tvOS)
			if includeData {
				query[Keychain.ReturnData] = kCFBooleanTrue
			}
		#endif
		
		var result: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &result)
		var items: [KeychainAttributes] = []
		if status == errSecSuccess, let values = result as? [[String: Any]] {
			for value in values {
				items.append(KeychainAttributes(attributes: value))
			}
		}
		return items
	}
	
	public func attributes(forKey key: String) throws -> KeychainAttributes? {
		var query = options.query()
		query[Keychain.MatchLimit] = Keychain.MatchLimitOne
		query[Keychain.ReturnData] = kCFBooleanTrue
		query[Keychain.ReturnAttributes] = kCFBooleanTrue
		query[Keychain.ReturnRef] = kCFBooleanTrue
		query[Keychain.ReturnPersistentRef] = kCFBooleanTrue
		query[Keychain.AttributeAccount] = key
		
		var result: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &result)
		
		switch status {
		case errSecSuccess:
			guard let attributes = result as? [String: Any] else {
				throw KeychainStatus.unexpectedError
			}
			return KeychainAttributes(attributes: attributes)
		case errSecItemNotFound:
			return nil
		default:
			throw KeychainStatus(status: status)
		}
	}
	
	// MARK: - Content setter
	
	public func set(_ value: String, key: String) throws {
		guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
			throw KeychainStatus.conversionError
		}
		try set(data, key: key)
	}
	
	public func set(_ value: Data, key: String) throws {
		var query = options.query()
		query[Keychain.AttributeAccount] = key
		#if os(iOS)
			if #available(iOS 9.0, *) {
				query[Keychain.UseAuthenticationUI] = Keychain.UseAuthenticationUIFail
			} else {
				query[Keychain.UseNoAuthenticationUI] = kCFBooleanTrue
			}
		#elseif os(macOS)
			query[Keychain.ReturnData] = kCFBooleanTrue
			if #available(OSX 10.11, *) {
				query[Keychain.UseAuthenticationUI] = Keychain.UseAuthenticationUIFail
			}
		#endif
		
		var status = SecItemCopyMatching(query as CFDictionary, nil)
		switch status {
		case errSecSuccess, errSecInteractionNotAllowed:
			var (attributes, error) = options.attributes(key: nil, value: value)
			if let error = error {
				throw error
			}
			for (key, value) in options.attributes {
				attributes.updateValue(value, forKey: key)
			}
			#if os(iOS)
				if status == errSecInteractionNotAllowed && floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_8_0) {
					try remove(key)
					try set(value, key: key)
				} else {
					var query = options.query()
					query[Keychain.AttributeAccount] = key
					status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
					if status != errSecSuccess {
						throw KeychainStatus(status: status)
					}
				}
			#else
				status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
				if status != errSecSuccess {
					throw KeychainStatus(status: status)
				}
			#endif
		case errSecItemNotFound:
			var (attributes, error) = options.attributes(key: key, value: value)
			if let error = error {
				throw error
			}
			for (key, value) in options.attributes {
				attributes.updateValue(value, forKey: key)
			}
			status = SecItemAdd(attributes as CFDictionary, nil)
			if status != errSecSuccess {
				throw KeychainStatus(status: status)
			}
		default:
			throw KeychainStatus(status: status)
		}
	}
	
	// MARK: - Content remove
	
	public func remove(_ key: String) throws {
		var query = options.query()
		query[Keychain.AttributeAccount] = key
		
		let status = SecItemDelete(query as CFDictionary)
		if status != errSecSuccess && status != errSecItemNotFound {
			throw KeychainStatus(status: status)
		}
	}
	
	public func removeAll() throws {
		var query = options.query()
		#if !os(iOS) && !os(watchOS) && !os(tvOS)
			query[Keychain.MatchLimit] = Keychain.MatchLimitAll
		#endif
		
		let status = SecItemDelete(query as CFDictionary)
		if status != errSecSuccess && status != errSecItemNotFound {
			throw KeychainStatus(status: status)
		}
	}
	
	// MARK: - Content check
	
	public func contains(_ key: String) throws -> Bool {
		var query = options.query()
		query[Keychain.AttributeAccount] = key
		
		let status = SecItemCopyMatching(query as CFDictionary, nil)
		switch status {
		case errSecSuccess:
			return true
		case errSecItemNotFound:
			return false
		default:
			throw KeychainStatus(status: status)
		}
	}
	
	// MARK: -
	
	#if os(iOS)
	public func requestSharedPassword(_ completion: @escaping (_ account: String?, _ password: String?, Error?)->Void) {
		if let domain = options.server?.host {
			type(of: self).requestSharedWebCredential(domain: domain, account: nil) { (credentials, error) -> () in
				if let credential = credentials.first {
					let account = credential["account"]
					let password = credential["password"]
					completion(account, password, error)
				} else {
					completion(nil, nil, error)
				}
			}
		} else {
			completion(nil, nil, KeychainStatus.param)
		}
	}
	
	public func requestSharedPassword(account: String, completion: @escaping (_ password: String?, _ error: Error?)->Void) {
		if let domain = options.server?.host {
			type(of: self).requestSharedWebCredential(domain: domain, account: account) { (credentials, error) -> () in
				completion(credentials.first?["password"], error)
			}
		} else {
			completion(nil, KeychainStatus.param)
		}
	}
	
	public class func requestSharedWebCredential(domain: String? = nil, account: String? = nil, completion: @escaping ([[String: String]], Error?)->Void) {
		SecRequestSharedWebCredential(domain as CFString?, account as CFString?) { credentials, error in
			var remoteError: NSError?
			if let error = error?.error {
				remoteError = error
				if error.code != Int(errSecItemNotFound) {
					print("error:[\(error.code)] \(error.localizedDescription)")
				}
			}
			var result: [[String: String]] = []
			if let credentials = credentials as NSArray? {
				for credentials in credentials {
					var credential: [String: String] = [:]
					if let credentials = credentials as? [String: String] {
						if let server = credentials[Keychain.AttributeServer] {
							credential["server"] = server
						}
						if let account = credentials[Keychain.AttributeAccount] {
							credential["account"] = account
						}
						if let password = credentials[Keychain.SharedPassword] {
							credential["password"] = password
						}
					}
					result.append(credential)
				}
			}
			completion(result, remoteError)
		}
	}
	#endif
	
	#if os(iOS)
	private func setSharedPassword(_ password: String?, account: String, completion: ((Error?)->Void)? = nil) {
		if let domain = options.server?.host {
			SecAddSharedWebCredential(domain as CFString, account as CFString, password as CFString?) { error in
				completion?(error?.error)
			}
		} else {
			completion?(KeychainStatus.param)
		}
	}
	
	public func removeSharedPassword(account: String, completion: ((Error?)->Void)? = nil) {
		setSharedPassword(nil, account: account, completion: completion)
	}
	#endif
	
	#if os(iOS)
	/// Returns a randomly generated password.
	/// - Returns: password in the form xxx-xxx-xxx-xxx where x is taken from the sets "abcdefghkmnopqrstuvwxy", "ABCDEFGHJKLMNPQRSTUVWXYZ", "3456789" with at least one character from each set being present.
	public static func generatePassword() -> String {
		SecCreateSharedWebCredentialPassword()! as String
	}
	#endif
}

extension CFError {
	var error: NSError {
		let domain = CFErrorGetDomain(self) as String
		let code = CFErrorGetCode(self)
		let userInfo = CFErrorCopyUserInfo(self) as! [String: Any]
		return NSError(domain: domain, code: code, userInfo: userInfo)
	}
}
