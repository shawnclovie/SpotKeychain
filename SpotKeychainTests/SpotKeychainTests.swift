//
//  SpotKeychainTests.swift
//  SpotKeychainTests
//
//  Created by Shawn Clovie on 18/8/2019.
//  Copyright © 2019 Spotlit.club. All rights reserved.
//

import XCTest
@testable import SpotKeychain

class SpotKeychainTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
	
	func testKeychain() {
		let chain = Keychain.bundleDefault
		let key = "test_key_last_time"
		print("last time: \(try! chain.string(forKey: key) ?? "(none)")")
		try! chain.set("\(Date().timeIntervalSince1970)", key: key)
		let items = chain.quaryItems(includeData: true)
		for item in items {
			print("\(item)")
		}
	}
}
