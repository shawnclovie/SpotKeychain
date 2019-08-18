//
//  KeychainAuthenticationType.swift
//  Spot
//
//  Created by Shawn Clovie on 4/1/2018.
//  Copyright © 2018 Shawn Clovie. All rights reserved.
//

import Foundation

public enum KeychainAuthenticationType {
	case ntlm
	case msn
	case dpa
	case rpa
	case httpBasic
	case httpDigest
	case htmlForm
	case `default`
}

extension KeychainAuthenticationType: RawRepresentable {

    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAuthenticationTypeNTLM):
            self = .ntlm
        case String(kSecAttrAuthenticationTypeMSN):
            self = .msn
        case String(kSecAttrAuthenticationTypeDPA):
            self = .dpa
        case String(kSecAttrAuthenticationTypeRPA):
            self = .rpa
        case String(kSecAttrAuthenticationTypeHTTPBasic):
            self = .httpBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
            self = .httpDigest
        case String(kSecAttrAuthenticationTypeHTMLForm):
            self = .htmlForm
        case String(kSecAttrAuthenticationTypeDefault):
            self = .`default`
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .ntlm:
            return String(kSecAttrAuthenticationTypeNTLM)
        case .msn:
            return String(kSecAttrAuthenticationTypeMSN)
        case .dpa:
            return String(kSecAttrAuthenticationTypeDPA)
        case .rpa:
            return String(kSecAttrAuthenticationTypeRPA)
        case .httpBasic:
            return String(kSecAttrAuthenticationTypeHTTPBasic)
        case .httpDigest:
            return String(kSecAttrAuthenticationTypeHTTPDigest)
        case .htmlForm:
            return String(kSecAttrAuthenticationTypeHTMLForm)
        case .`default`:
            return String(kSecAttrAuthenticationTypeDefault)
        }
    }
}
