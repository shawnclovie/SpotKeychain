//
//  KeychainAuthenticationPolicy.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

public struct KeychainAuthenticationPolicy: OptionSet {
	/**
	User presence policy using Touch ID or Passcode. Touch ID does not
	have to be available or enrolled. Item is still accessible by Touch ID
	even if fingers are added or removed.
	*/
	@available(iOS 8.0, OSX 10.10, *)
	@available(watchOS, unavailable)
	public static let userPresence = KeychainAuthenticationPolicy(rawValue: 1 << 0)
	
	/**
	Constraint: Touch ID (any finger). Touch ID must be available and
	at least one finger must be enrolled. Item is still accessible by
	Touch ID even if fingers are added or removed.
	*/
	@available(iOS 9.0, *)
	@available(OSX, unavailable)
	@available(watchOS, unavailable)
	public static let touchIDAny = KeychainAuthenticationPolicy(rawValue: 1 << 1)
	
	/**
	Constraint: Touch ID from the set of currently enrolled fingers.
	Touch ID must be available and at least one finger must be enrolled.
	When fingers are added or removed, the item is invalidated.
	*/
	@available(iOS 9.0, *)
	@available(OSX, unavailable)
	@available(watchOS, unavailable)
	public static let touchIDCurrentSet = KeychainAuthenticationPolicy(rawValue: 1 << 3)
	
	/**
	Constraint: Device passcode
	*/
	@available(iOS 9.0, OSX 10.11, *)
	@available(watchOS, unavailable)
	public static let devicePasscode = KeychainAuthenticationPolicy(rawValue: 1 << 4)
	
	/**
	Constraint logic operation: when using more than one constraint,
	at least one of them must be satisfied.
	*/
	@available(iOS 9.0, *)
	@available(OSX, unavailable)
	@available(watchOS, unavailable)
	public static let or = KeychainAuthenticationPolicy(rawValue: 1 << 14)
	
	/**
	Constraint logic operation: when using more than one constraint,
	all must be satisfied.
	*/
	@available(iOS 9.0, *)
	@available(OSX, unavailable)
	@available(watchOS, unavailable)
	public static let and = KeychainAuthenticationPolicy(rawValue: 1 << 15)
	
	/**
	Create access control for private key operations (i.e. sign operation)
	*/
	@available(iOS 9.0, *)
	@available(OSX, unavailable)
	@available(watchOS, unavailable)
	public static let privateKeyUsage = KeychainAuthenticationPolicy(rawValue: 1 << 30)
	
	/**
	Security: Application provided password for data encryption key generation.
	This is not a constraint but additional item encryption mechanism.
	*/
	@available(iOS 9.0, *)
	@available(OSX, unavailable)
	@available(watchOS, unavailable)
	public static let applicationPassword = KeychainAuthenticationPolicy(rawValue: 1 << 31)
	
	#if swift(>=2.3)
	public let rawValue: UInt
	
	public init(rawValue: UInt) {
		self.rawValue = rawValue
	}
	#else
	public let rawValue: Int
	
	public init(rawValue: Int) {
	self.rawValue = rawValue
	}
	#endif
}
