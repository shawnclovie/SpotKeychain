//
//  KeychainConstants.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

extension Keychain {
	static let Class = String(kSecClass)
	
	static let AttributeAccessible = String(kSecAttrAccessible)
	
	@available(iOS 8.0, OSX 10.10, *)
	static let AttributeAccessControl = String(kSecAttrAccessControl)
	
	static let AttributeAccessGroup = String(kSecAttrAccessGroup)
	static let AttributeSynchronizable = String(kSecAttrSynchronizable)
	static let AttributeCreationDate = String(kSecAttrCreationDate)
	static let AttributeModificationDate = String(kSecAttrModificationDate)
	static let AttributeDescription = String(kSecAttrDescription)
	static let AttributeComment = String(kSecAttrComment)
	static let AttributeCreator = String(kSecAttrCreator)
	static let AttributeType = String(kSecAttrType)
	static let AttributeLabel = String(kSecAttrLabel)
	static let AttributeIsInvisible = String(kSecAttrIsInvisible)
	static let AttributeIsNegative = String(kSecAttrIsNegative)
	static let AttributeAccount = String(kSecAttrAccount)
	static let AttributeService = String(kSecAttrService)
	static let AttributeGeneric = String(kSecAttrGeneric)
	static let AttributeSecurityDomain = String(kSecAttrSecurityDomain)
	static let AttributeServer = String(kSecAttrServer)
	static let AttributeProtocol = String(kSecAttrProtocol)
	static let AttributeAuthenticationType = String(kSecAttrAuthenticationType)
	static let AttributePort = String(kSecAttrPort)
	static let AttributePath = String(kSecAttrPath)
	
	static let SynchronizableAny = kSecAttrSynchronizableAny
	
	static let MatchLimit = String(kSecMatchLimit)
	static let MatchLimitOne = kSecMatchLimitOne
	static let MatchLimitAll = kSecMatchLimitAll
	
	static let ReturnData = String(kSecReturnData)
	static let ReturnAttributes = String(kSecReturnAttributes)
	static let ReturnRef = String(kSecReturnRef)
	static let ReturnPersistentRef = String(kSecReturnPersistentRef)
	
	static let ValueData = String(kSecValueData)
	static let ValueRef = String(kSecValueRef)
	static let ValuePersistentRef = String(kSecValuePersistentRef)
	
	@available(iOS 8.0, OSX 10.10, *)
	static let UseOperationPrompt = String(kSecUseOperationPrompt)
	
	#if os(iOS)
	@available(iOS, introduced: 8.0, deprecated: 9.0, message: "Use a UseAuthenticationUI instead.")
	static let UseNoAuthenticationUI = String(kSecUseNoAuthenticationUI)
	#endif
	
	@available(iOS 9.0, OSX 10.11, *)
	@available(watchOS, unavailable)
	static let UseAuthenticationUI = String(kSecUseAuthenticationUI)
	
	@available(iOS 9.0, OSX 10.11, *)
	@available(watchOS, unavailable)
	static let UseAuthenticationContext = String(kSecUseAuthenticationContext)
	
	@available(iOS 9.0, OSX 10.11, *)
	@available(watchOS, unavailable)
	static let UseAuthenticationUIAllow = String(kSecUseAuthenticationUIAllow)
	
	@available(iOS 9.0, OSX 10.11, *)
	@available(watchOS, unavailable)
	static let UseAuthenticationUIFail = String(kSecUseAuthenticationUIFail)
	
	@available(iOS 9.0, OSX 10.11, *)
	@available(watchOS, unavailable)
	static let UseAuthenticationUISkip = String(kSecUseAuthenticationUISkip)
	
	#if os(iOS) && !targetEnvironment(macCatalyst)
	static let SharedPassword = String(kSecSharedPassword)
	#endif
}
