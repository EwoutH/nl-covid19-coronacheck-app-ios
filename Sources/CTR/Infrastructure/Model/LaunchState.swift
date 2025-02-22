/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

/// Should the app be updated?
enum LaunchState: Equatable {

	/// The app should be updated
	case actionRequired(AppVersionInformation)

	/// The app is fine.
	case noActionNeeded

	/// The app needs internet
	case internetRequired

	// MARK: Equatable

	/// Equatable
	/// - Parameters:
	///   - lhs: the left hand side
	///   - rhs: the right hand side
	/// - Returns: True if both sides are equal
	static func == (lhs: LaunchState, rhs: LaunchState) -> Bool {
		switch (lhs, rhs) {
			case (noActionNeeded, noActionNeeded):
				return true
			case (internetRequired, internetRequired):
				return true
			case (let .actionRequired(lhsVersion), let .actionRequired(rhsVersion)):
				return lhsVersion.minimumVersion == rhsVersion.minimumVersion &&
					lhsVersion.minimumVersionMessage == rhsVersion.minimumVersionMessage &&
					lhsVersion.appStoreURL == rhsVersion.appStoreURL &&
					lhsVersion.informationURL == rhsVersion.informationURL &&
					lhsVersion.appDeactivated == rhsVersion.appDeactivated &&
					lhsVersion.configTTL == rhsVersion.configTTL &&
					lhsVersion.maxValidityHours == rhsVersion.maxValidityHours
			default:
				return false
		}
	}
}
