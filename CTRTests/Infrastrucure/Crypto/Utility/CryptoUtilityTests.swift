/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/
  
@testable import CTR
import XCTest

class CryptoUtilityTests: XCTestCase {

	var sut = CryptoUtility(signatureValidator: SignatureValidator())

	override func setUp() {

		super.setUp()
		sut = CryptoUtility(signatureValidator: SignatureValidator())
	}

	/// Test the signature
	func testSignature() {

		// Given
		let data = "SomeData".data(using: .utf8)!
		let key = "SomeKey".data(using: .utf8)!

		// When
		let signature = sut.signature(forData: data, key: key)
		let hexBytes = signature.map { String(format: "%02hhx", $0) }

		// Then
		XCTAssertEqual("\(hexBytes.joined())", "a1118b1288eb8b20075f7b5d65d6809ad95f571856e3b831a43c39094f509beb")
	}

	/// Test the hash
	func testSha256() {

		// Given
		let data = "SomeString".data(using: .utf8)!

		// When
		let sha = sut.sha256(data: data)

		// Then
		XCTAssertEqual(sha, "SHA256 digest: 80ed7fe2957fa688284716753d339d019d490d4589ac4999ec8827ef3f84be29")
	}
}
