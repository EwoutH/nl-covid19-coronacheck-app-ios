/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

protocol MenuDelegate: AnyObject {

	// MARK: Menu

	/// Close the menu
	func closeMenu()

	/// Open a menu item
	/// - Parameter identifier: the menu identifier
	func openMenuItem(_ identifier: MenuIdentifier)

	func getTopMenuItems() -> [MenuItem]

	func getBottomMenuItems() -> [MenuItem]
}

enum MenuIdentifier {

	case overview
	case scan
	case support
	case settings
	case privacy
	case faq
	case about
	case feedback
}

struct MenuItem {

	let identifier: MenuIdentifier
	let title: String
}

class MenuViewModel {

	/// Menu Delegate
	weak var menuDelegate: MenuDelegate?

	/// The top menu items
	@Bindable var topMenu: [MenuItem]

	/// The bottom menu items
	@Bindable var bottomMenu: [MenuItem]

	/// The version and build number
	@Bindable var version: String

	/// Initializer
	/// - Parameters:
	///   - menuDelegate: the menu delegate

	init(delegate: MenuDelegate, versionSupplier: AppVersionSupplierProtocol) {

		self.menuDelegate = delegate
		self.topMenu = delegate.getTopMenuItems()
		self.bottomMenu = delegate.getBottomMenuItems()
		self.version = String(
			format: .menuVersion,
			versionSupplier.getCurrentVersion(),
			versionSupplier.getCurrentBuild()
		)
	}

	/// The user tapped on a menu item
	/// - Parameter identifier: menu item identifier
	func menuItemTapped(_ identifier: MenuIdentifier) {

		menuDelegate?.openMenuItem(identifier)
	}

	/// Close the menu
	func clossButtonTapped() {

		menuDelegate?.closeMenu()
	}
}
