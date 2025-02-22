/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class ListResultsViewModelTests: XCTestCase {

	/// Subject under test
	var sut: ListResultsViewModel?

	/// The coordinator spy
	var holderCoordinatorDelegateSpy = HolderCoordinatorDelegateSpy()

	/// The proof manager spy
	var proofManagingSpy = ProofManagingSpy()

	/// Date parser
	private lazy var parseDateFormatter: ISO8601DateFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		return dateFormatter
	}()

	override func setUp() {

		super.setUp()
		holderCoordinatorDelegateSpy = HolderCoordinatorDelegateSpy()
		proofManagingSpy = ProofManagingSpy()
		sut = ListResultsViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			proofManager: proofManagingSpy,
			maxValidity: 48
		)
	}

	// MARK: - Tests

	/// Test the check result method with a pending test result
	func testCheckResultPending() {

		// Given
		let pendingWrapper = TestResultWrapper(
			providerIdentifier: "testCheckResultPending",
			protocolVersion: "1.0",
			result: nil,
			status: .pending
		)
		proofManagingSpy.testResultWrapper = pendingWrapper

		// When
		sut?.checkResult()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsPendingTitle, "Title should match")
		XCTAssertEqual(sut?.message, .holderTestResultsPendingText, "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test the check result method with a not negative test result
	func testCheckResultNotNegative() {

		// Given
		let notNegativeWrapper = TestResultWrapper(
			providerIdentifier: "testCheckResultNotNegative",
			protocolVersion: "1.0",
			result: TestResult(
				unique: "testCheckResultNotNegative",
				sampleDate: "now",
				testType: "test",
				negativeResult: false,
				holder: nil,
				checksum: nil
			),
			status: .complete
		)
		proofManagingSpy.testResultWrapper = notNegativeWrapper

		// When
		sut?.checkResult()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsNoResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, String(format: .holderTestResultsNoResultsText, "48"), "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test the check result method with a too old test result
	func testCheckResultTooOld() {

		// Given
		let tooOldWrapper = TestResultWrapper(
			providerIdentifier: "testCheckResultTooOld",
			protocolVersion: "1.0",
			result: TestResult(
				unique: "testCheckResultTooOld",
				sampleDate: "2021-02-01T00:00:00+00:00",
				testType: "test",
				negativeResult: true,
				holder: nil,
				checksum: nil
			),
			status: .complete
		)
		proofManagingSpy.testResultWrapper = tooOldWrapper

		// When
		sut?.checkResult()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsNoResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, String(format: .holderTestResultsNoResultsText, "48"), "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test the check result method with a too new test result
	func testCheckResultTooNew() {

		// Given
		let now = Date().timeIntervalSince1970 + 200

		let tooNewWrapper = TestResultWrapper(
			providerIdentifier: "testCheckResultTooNew",
			protocolVersion: "1.0",
			result: TestResult(
				unique: "testCheckResultTooNew",
				sampleDate: parseDateFormatter.string(from: Date(timeIntervalSince1970: now)),
				testType: "test",
				negativeResult: true,
				holder: nil,
				checksum: nil
			),
			status: .complete
		)
		proofManagingSpy.testResultWrapper = tooNewWrapper

		// When
		sut?.checkResult()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsNoResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, String(format: .holderTestResultsNoResultsText, "48"), "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test the check result method with a valid test result
	func testCheckResultValidProtocolVersionOne() {

		// Given
		let now = Date().timeIntervalSince1970 - 200

		let validProtocolOne = TestResultWrapper(
			providerIdentifier: "testCheckResultValid",
			protocolVersion: "1.0",
			result: TestResult(
				unique: "testCheckResultValid",
				sampleDate: parseDateFormatter.string(from: Date(timeIntervalSince1970: now)),
				testType: "test",
				negativeResult: true,
				holder: nil,
				checksum: nil
			),
			status: .complete
		)
		proofManagingSpy.testResultWrapper = validProtocolOne

		// When
		sut?.checkResult()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, .holderTestResultsResultsText, "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsResultsButton, "Button should match")
		XCTAssertNotNil(sut?.listItem, "Selected item should NOT be nil")
		XCTAssertEqual(sut?.listItem?.identifier, "testCheckResultValid", "Identifier should match")
	}

	/// Test the check result method with a valid test result
	func testCheckResultValidProtocolVersionTwo() {

		// Given
		let now = Date().timeIntervalSince1970 - 200

		let validProtocolTwo = TestResultWrapper(
			providerIdentifier: "testCheckResultValid",
			protocolVersion: "2.0",
			result: TestResult(
				unique: "testCheckResultValid",
				sampleDate: parseDateFormatter.string(from: Date(timeIntervalSince1970: now)),
				testType: "test",
				negativeResult: true,
				holder: HolderTestCredentials(
					firstNameInitial: "T",
					lastNameInitial: "T",
					birthDay: "1",
					birthMonth: "1"
				),
				checksum: nil
			),
			status: .complete
		)
		proofManagingSpy.testResultWrapper = validProtocolTwo

		// When
		sut?.checkResult()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, .holderTestResultsResultsText, "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsResultsButton, "Button should match")
		XCTAssertNotNil(sut?.listItem, "Selected item should NOT be nil")
		XCTAssertEqual(sut?.listItem?.identifier, "testCheckResultValid", "Identifier should match")
	}

	/// Test tap on the next button with an item selected
	func testButtonTappedListItemNotNil() {

		// Given
		sut?.listItem = ListResultItem(identifier: "test", date: "test", holder: "CC 10 MAR")

		// When
		sut?.buttonTapped()

		// Then
		XCTAssertTrue(proofManagingSpy.fetchIssuerPublicKeysCalled, "Step 1 should be executed")
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}
		XCTAssertFalse(strongSut.showAlert, "Alert should not be shown")
	}

	/// Test tap on the next button with no item selected
	func testButtonTappedListItemNil() {

		// Given
		sut?.listItem = nil

		// When
		sut?.buttonTapped()

		// Then
		XCTAssertTrue(holderCoordinatorDelegateSpy.navigateBackToStartCalled, "Delegate method should be called")
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}
		XCTAssertFalse(strongSut.showAlert, "Alert should not be shown")
	}

	/// Test tap on the close button with an item selected
	func testDismissListItemNotNil() {

		// Given
		sut?.listItem = ListResultItem(identifier: "test", date: "test", holder: "CC 10 MAR")

		// When
		sut?.dismiss()

		// Then
		XCTAssertFalse(proofManagingSpy.fetchNonceCalled, "Step 1 should be not executed")
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}
		XCTAssertTrue(strongSut.showAlert, "Alert should be shown")
	}

	/// Test tap on the close button with no item selected
	func testDismissListItemNil() {

		// Given
		sut?.listItem = nil

		// When
		sut?.dismiss()

		// Then
		XCTAssertTrue(holderCoordinatorDelegateSpy.navigateBackToStartCalled, "Delegate method should be called")
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}
		XCTAssertFalse(strongSut.showAlert, "Alert should not be shown")
	}

	/// Test step one with an error
	func testStepOneIssuerPublicKeysError() {

		// Given
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.notConnectedToInternet.rawValue
		)
		proofManagingSpy.issuerPublicKeyError = error

		// When
		sut?.createProofStepOne()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}

		XCTAssertTrue(strongSut.showError, "Error should not be nil")
		XCTAssertFalse(strongSut.showProgress, "Progress should not be shown")
	}

	/// Test step one without an error
	func testStepOneIssuerPublicKeysNoError() {

		// Given
		proofManagingSpy.shouldIssuerPublicKeyComplete = true

		// When
		sut?.createProofStepOne()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}

		XCTAssertTrue(proofManagingSpy.fetchNonceCalled, "Step 2 should be called")
		XCTAssertTrue(strongSut.showProgress, "Progress should be shown")
	}

	/// Test step two with an error
	func testStepTwoNonceError() {

		// Given
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.notConnectedToInternet.rawValue
		)
		proofManagingSpy.nonceError = error

		// When
		sut?.createProofStepTwo()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}

		XCTAssertTrue(strongSut.showError, "Error should not be nil")
		XCTAssertFalse(strongSut.showProgress, "Progress should not be shown")
	}

	/// Test step one without an error
	func testStepTwoNonceNoError() {

		// Given
		proofManagingSpy.shouldNonceComplete = true

		// When
		sut?.createProofStepTwo()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}

		XCTAssertTrue(proofManagingSpy.fetchSignedTestResultCalled, "Step 2 should be called")
		XCTAssertTrue(strongSut.showProgress, "Progress should be shown")
	}

	/// Test step three with an error
	func testStepThreeWithError() {

		// Given
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.notConnectedToInternet.rawValue
		)
		proofManagingSpy.signedTestResultError = error

		// When
		sut?.createProofStepThree()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}

		XCTAssertTrue(strongSut.showError, "Error should not be nil")
		XCTAssertFalse(strongSut.showProgress, "Progress should not be shown")
	}

	/// Test step three with a valid result
	func testStepThreeWithValidResult() {

		// Given
		proofManagingSpy.shouldSignedTestResultComplete = true
		proofManagingSpy.signedTestResultState = .valid

		// When
		sut?.createProofStepThree()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}

		XCTAssertFalse(strongSut.showError, "Error should be false")
		XCTAssertFalse(strongSut.showProgress, "Progress should not be shown")
		XCTAssertTrue(holderCoordinatorDelegateSpy.navigateBackToStartCalled, "Delegate method should be called")
	}

	/// Test step two with an already signed result
	func testStepThreeWithAlreadySignedResult() {

		// Given
		proofManagingSpy.shouldSignedTestResultComplete = true
		proofManagingSpy.signedTestResultState = .alreadySigned

		// When
		sut?.createProofStepThree()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsAlreadyHandledTitle, "Title should match")
		XCTAssertEqual(sut?.message, .holderTestResultsAlreadyHandledText, "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test step two with a not negative  result
	func testStepThreeWithNotNegativeResult() {

		// Given
		proofManagingSpy.shouldSignedTestResultComplete = true
		proofManagingSpy.signedTestResultState = .notNegative

		// When
		sut?.createProofStepThree()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsNoResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, String(format: .holderTestResultsNoResultsText, "48"), "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test step two with a too new  result
	func testStepThreeWithTooNewResult() {

		// Given
		proofManagingSpy.shouldSignedTestResultComplete = true
		proofManagingSpy.signedTestResultState = .tooNew

		// When
		sut?.createProofStepThree()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsNoResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, String(format: .holderTestResultsNoResultsText, "48"), "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test step two with a too old  result
	func testStepThreeWithTooOldResult() {

		// Given
		proofManagingSpy.shouldSignedTestResultComplete = true
		proofManagingSpy.signedTestResultState = .tooOld

		// When
		sut?.createProofStepThree()

		// Then
		XCTAssertEqual(sut?.title, .holderTestResultsNoResultsTitle, "Title should match")
		XCTAssertEqual(sut?.message, String(format: .holderTestResultsNoResultsText, "48"), "Message should match")
		XCTAssertEqual(sut?.buttonTitle, .holderTestResultsBackToMenuButton, "Button should match")
		XCTAssertNil(sut?.listItem, "Selected item should be nil")
	}

	/// Test step two with a too old  result
	func testStepThreeWithUnknownError() {

		// Given
		proofManagingSpy.shouldSignedTestResultComplete = true
		proofManagingSpy.signedTestResultState = .unknown(nil)

		// When
		sut?.createProofStepThree()

		// Then
		guard let strongSut = sut else {
			XCTFail("Can't unwrap sut")
			return
		}
		XCTAssertTrue(strongSut.showError, "Error should be true")
	}

	/// Test the display of the identity
	func testIdentity() {

		// Given
		let examples: [String: HolderTestCredentials] = [
			"R P 27 JAN": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "1"),
			"R P 27 FEB": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "2"),
			"R P 27 MAR": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "3"),
			"R P 27 APR": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "4"),
			"R P 27 MEI": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "5"),
			"R P 27 JUN": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "6"),
			"R P 27 JUL": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "7"),
			"R P 27 AUG": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "8"),
			"R P 27 SEP": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "9"),
			"R P 27 OKT": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "10"),
			"R P 27 NOV": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "11"),
			"R P 27 DEC": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "12"),
			"R P 05 MEI": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "5", birthMonth: "5"),
			"R P X MEI": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "X", birthMonth: "5"),
			"R P X X": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "X", birthMonth: "X"),
			"R P 27 X": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "X"),
			"R P 27 0": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "27", birthMonth: "0"),
			"R P 0 0": HolderTestCredentials(firstNameInitial: "R", lastNameInitial: "P", birthDay: "0", birthMonth: "0")
		]

		examples.forEach { expectedResult, holder in

			// When
			let result = sut?.getDisplayIdentity(holder)

			// Then
			XCTAssertEqual(expectedResult, result, "Display Indentity should match")
		}
	}
}
