/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class ListResultView: BaseView {

	/// The display constants
	private struct ViewTraits {

		// Dimensions
		static let titleLineHeight: CGFloat = 22
		static let titleKerning: CGFloat = -0.41
		static let messageLineHeight: CGFloat = 18
		static let messageKerning: CGFloat = -0.24

		// Margins
		static let margin: CGFloat = 20.0
		static let messageTopMargin: CGFloat = 4.0
	}

	/// The select image
	let selectImageView: UIImageView = {
		let view = UIImageView(image: .radio)
		view.tintColor = Theme.colors.viewControllerBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	/// The header label
	let headerLabel: Label = {

		return Label(caption1SemiBold: nil).multiline()
	}()

	/// The title label
	let titleLabel: Label = {

		return Label(bodyMedium: nil).multiline()
	}()

	/// The message label
	let messageLabel: Label = {

		return Label(subhead: nil).multiline()
	}()

	/// The info label
	let infoLabel: Label = {

		return Label(subhead: nil).multiline()
	}()

	let disclaimerButton: UIButton = {

		let button = UIButton()
		button.setImage(.questionMark, for: .normal)
		button.titleLabel?.textColor = Theme.colors.dark
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	let selectButton: UIButton = {

		let button = UIButton()
		button.setTitle("?", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	let topLineView: UIView = {

		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Theme.colors.line
		return view
	}()

	let bottomLineView: UIView = {

		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Theme.colors.line
		return view
	}()

	override func setupViews() {

		super.setupViews()
		view?.backgroundColor = Theme.colors.viewControllerBackground
		infoLabel.textColor = Theme.colors.launchGray
		messageLabel.textColor = Theme.colors.launchGray
		disclaimerButton.addTarget(
			self,
			action: #selector(disclaimerButtonTapped),
			for: .touchUpInside
		)
		selectButton.addTarget(
			self,
			action: #selector(selectButtonTapped),
			for: .touchUpInside
		)
	}

	/// Setup the hierarchy
	override func setupViewHierarchy() {

		super.setupViewHierarchy()
		addSubview(headerLabel)
		addSubview(disclaimerButton)
		addSubview(topLineView)
		addSubview(selectImageView)
		addSubview(titleLabel)
		addSubview(messageLabel)
		addSubview(infoLabel)
		addSubview(bottomLineView)
		addSubview(selectButton)
	}

	/// Setup the constraints
	override func setupViewConstraints() {

		super.setupViewConstraints()

		NSLayoutConstraint.activate([

			// Header
			headerLabel.centerYAnchor.constraint(equalTo: disclaimerButton.centerYAnchor),
			headerLabel.leadingAnchor.constraint(
				equalTo: leadingAnchor
			),
			headerLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor
			),
			headerLabel.bottomAnchor.constraint(
				equalTo: topLineView.topAnchor,
				constant: -ViewTraits.margin
			),

			// Line
			topLineView.heightAnchor.constraint(equalToConstant: 1),
			topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
			topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),

			// Select Image
			selectImageView.leadingAnchor.constraint(
				equalTo: leadingAnchor
			),
			selectImageView.topAnchor.constraint(
				equalTo: topLineView.bottomAnchor,
				constant: 19
			),
			selectImageView.widthAnchor.constraint(equalToConstant: 20),
			selectImageView.heightAnchor.constraint(equalToConstant: 20),

			// Title
			titleLabel.topAnchor.constraint(
				equalTo: topLineView.bottomAnchor,
				constant: 16
			),
			titleLabel.leadingAnchor.constraint(
				equalTo: selectImageView.trailingAnchor,
				constant: 16
			),
			titleLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor
			),
			titleLabel.bottomAnchor.constraint(
				equalTo: messageLabel.topAnchor,
				constant: -ViewTraits.messageTopMargin
			),

			// Message
			messageLabel.leadingAnchor.constraint(
				equalTo: selectImageView.trailingAnchor,
				constant: ViewTraits.margin
			),
			messageLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor
			),
			messageLabel.bottomAnchor.constraint(
				equalTo: infoLabel.topAnchor,
				constant: -ViewTraits.messageTopMargin
			),

			// Message
			infoLabel.leadingAnchor.constraint(
				equalTo: selectImageView.trailingAnchor,
				constant: ViewTraits.margin
			),
			infoLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor
			),
			infoLabel.bottomAnchor.constraint(
				equalTo: bottomLineView.topAnchor,
				constant: -ViewTraits.margin
			),

			// Line
			bottomLineView.heightAnchor.constraint(equalToConstant: 1),
			bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
			bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
			bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),

			// Select Button
			selectButton.topAnchor.constraint(
				equalTo: topLineView.topAnchor
			),
			selectButton.leadingAnchor.constraint(
				equalTo: leadingAnchor
			),
			selectButton.trailingAnchor.constraint(
				equalTo: trailingAnchor
			),
			selectButton.bottomAnchor.constraint(
				equalTo: bottomLineView.bottomAnchor
			),

			// Disclaimer button
			disclaimerButton.topAnchor.constraint(
				equalTo: topAnchor
			),
			disclaimerButton.widthAnchor.constraint(
				equalToConstant: 50
			),
			disclaimerButton.trailingAnchor.constraint(
				equalTo: trailingAnchor
			),
			disclaimerButton.bottomAnchor.constraint(
				equalTo: topLineView.bottomAnchor
			)
		])
	}

	/// User tapped on the primary button
	@objc func selectButtonTapped() {

		selectButtonTappedCommand?()
	}

	/// User tapped on the primary button
	@objc func disclaimerButtonTapped() {

		disclaimerButtonTappedCommand?()
	}

	// MARK: Public Access

	/// The header
	var header: String? {
		didSet {
			headerLabel.text = header
		}
	}

	/// The title
	var title: String? {
		didSet {
			titleLabel.attributedText = title?.setLineHeight(
				ViewTraits.titleLineHeight,
				kerning: ViewTraits.titleKerning
			)
		}
	}

	/// The message
	var message: String? {
		didSet {
			messageLabel.attributedText = message?.setLineHeight(
				ViewTraits.messageLineHeight,
				kerning: ViewTraits.messageKerning
			)
		}
	}

	/// The info
	var info: String? {
		didSet {
			infoLabel.attributedText = info?.setLineHeight(
				ViewTraits.messageLineHeight,
				kerning: ViewTraits.messageKerning
			)
		}
	}

	/// The user tapped on the primary button
	var disclaimerButtonTappedCommand: (() -> Void)?

	/// The user tapped on the primary button
	var selectButtonTappedCommand: (() -> Void)?
}
