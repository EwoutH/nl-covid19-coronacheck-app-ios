/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class TokenValidatorTests: XCTestCase {

	var sut = TokenValidator()

	override func setUp() {

		super.setUp()
		sut = TokenValidator()
	}

	// MARK: - Tests

	/// Test the validator with valid tokens
	func testValidatorWithValidTokens() {

		// Given
		let validTokens: [String] = [
			"ZZZ-2SX4XLGGXUB6V9-42",
			"ZZZ-YL8BSX9T6J39C7-Q2",
			"ZZZ-2FR36XSUGJY3UZ-G2",
			"ZZZ-32X4RUBC2TYBX6-U2",
			"FLA-SGF25J4TBT-X2",
			"FLA-4RRT5FRQ6L-X2",
			"FLA-QGJ6Y2SBSY-62"
		]

		for token in validTokens {

			// When
			let result = sut.validate(token)

			// Then
			XCTAssertTrue(result, "\(token) should be a valid token")
		}
	}

	/// Test the validator with invalid tokens
	func testValidatorWithInvalidTokens() {

		// Given
		let invalidTokens: [String] = [
			"ZZZ-2SX4XLGGXUB6V8-42",
			"ZZZ-YL8BSX9T6J39C7-L2",
			"FLA-SGF25J4TBT-Y2",
			"FLA-4RRT5FRQ6L",
			"FLA",
			"",
			"T-E-S-T",
			"T--T",
			"ZZZ-AAAAA-A2"
		]

		for token in invalidTokens {

			// When
			let result = sut.validate(token)

			// Then
			XCTAssertFalse(result, "\(token) should be an invalid token")
		}
	}
}
