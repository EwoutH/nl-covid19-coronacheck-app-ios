/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class InformationViewController: BaseViewController {

	/// The model
	private let viewModel: InformationViewModel

	/// The view
	let sceneView = InformationView()

	/// Initializer
	/// - Parameter viewModel: view model
	init(viewModel: InformationViewModel) {

		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	/// Required initialzer
	/// - Parameter coder: the code
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Show always in portrait
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}

	// MARK: View lifecycle
	override func loadView() {

		view = sceneView
	}

	override func viewDidLoad() {

		super.viewDidLoad()

		viewModel.$title.binding = { [weak self] in self?.sceneView.title = $0 }
		viewModel.$message.binding = { [weak self] in self?.sceneView.message = $0 }
		viewModel.$showBottomCloseButton.binding = { [weak self] in self?.sceneView.closeButtonIsHidden = !$0 }

		addCloseButton(action: #selector(closeButtonTapped))
		sceneView.closeButton.touchUpInside(self, action: #selector(closeButtonTapped))
	}

	/// User tapped on the button
	@objc private func closeButtonTapped() {

		viewModel.dismiss()
	}
}
