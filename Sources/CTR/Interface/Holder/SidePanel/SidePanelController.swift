/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

open class SidePanelController: UIViewController, UIGestureRecognizerDelegate {

	open var selectedViewController: UIViewController? {
		didSet {
			guard oldValue != self.selectedViewController else {
				hideSidePanel()
				return
			}
			oldValue?.view.removeFromSuperview()
			oldValue?.willMove(toParent: nil)
			oldValue?.removeFromParent()
			updateSelectedViewcontroller()
		}
	}

	let sideController: UIViewController
	open var sidePanelWidth: CGFloat = 320.0
	open var animationSpeed: Double = 0.4

	internal weak var sidePanelView: UIView!
	fileprivate weak var mainView: UIView?
	fileprivate weak var overlayMainView: UIView!
	fileprivate var hasLeftSwipeGestureStarted = false
	fileprivate var shouldHideSidePanel = false

	func updateSelectedViewcontroller() {
		
		let mainViewController = (selectedViewController as? UINavigationController)?.topViewController ?? selectedViewController
		if let navItem = mainViewController?.navigationItem,
		   navItem.leftBarButtonItem == nil {
			let button = self.leftButton()
			button.addTarget(self, action: #selector(showSidePanel), for: .touchUpInside)
			navItem.leftBarButtonItem = UIBarButtonItem(customView: button)
		}

		if let svc = selectedViewController,
		   let mainView = self.mainView {
			addChild(svc)
			mainView.addSubview(svc.view)
			svc.didMove(toParent: self)
			hideSidePanel()
		}
	}

	open func leftButton() -> UIButton {

		let button = UIButton(type: .system)
		button.setTitle("Menu", for: UIControl.State())
		return button
	}

	override open func viewDidLoad() {

		super.viewDidLoad()
		updateSelectedViewcontroller()

		addChild(sideController)
		sideController.view.autoresizingMask = UIView.AutoresizingMask()
		sideController.view.frame = sidePanelView.bounds
		sidePanelView.addSubview(sideController.view)
		sideController.didMove(toParent: self)

		let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
		leftSwipeGesture.direction = .left
		self.view.addGestureRecognizer(leftSwipeGesture)

		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		panGesture.delegate = self
		self.view.addGestureRecognizer(panGesture)
	}

	open func gestureRecognizer(
		_ gestureRecognizer: UIGestureRecognizer,
		shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

		if otherGestureRecognizer is UISwipeGestureRecognizer {
			return true
		} else {
			return false
		}
	}

	@objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {

		guard hasLeftSwipeGestureStarted else {
			return
		}

		let frame = sidePanelView.frame
		switch panGestureRecognizer.state {
			case .changed:
				let panTranslation = panGestureRecognizer.translation(in: self.view)
				let speed = panGestureRecognizer.velocity(in: self.view).x
				if panTranslation.x <= 0 && abs(panTranslation.x) < frame.width {
					sidePanelView.frame = CGRect(x: panTranslation.x, y: frame.minY, width: frame.width, height: frame.height)
				}
				shouldHideSidePanel = abs(panTranslation.x) > sidePanelWidth / 2 || speed < -75.0
				let alpha = 0.1 * (frame.width + frame.minX) / frame.width
				overlayMainView.alpha = alpha
			case .ended:
				hasLeftSwipeGestureStarted = false
				shouldHideSidePanel ? hideSidePanel() : showSidePanel()
			default:
				break
		}
	}

	@objc func hideSidePanel() {

		let frame = sidePanelView.frame
		UIView.animate(withDuration: animationSpeed, animations: {
			self.sidePanelView.frame = CGRect(x: 0 - frame.width, y: frame.minY, width: frame.width, height: frame.height)
			self.overlayMainView.alpha = 0
		}, completion: { finished  in
			self.overlayMainView.isHidden = true
		})
	}

	@objc func showSidePanel() {

		let frame = sidePanelView.frame
		overlayMainView.isHidden = false
		UIView.animate(withDuration: animationSpeed, animations: {
			self.sidePanelView.frame = CGRect(x: 0, y: frame.minY, width: frame.width, height: frame.height)
			self.overlayMainView.alpha = 0.1
		})
	}

	@objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {

		if gestureRecognizer.direction == .left {
			hasLeftSwipeGestureStarted = true
			return
		} else {
			showSidePanel()
		}
	}

	public init(sideController: UIViewController) {

		self.sideController = sideController
		super.init(nibName: nil, bundle: Bundle.main)
	}

	override open func loadView() {

		let view = UIView(frame: UIScreen.main.bounds)
		view.backgroundColor = UIColor.white

		let mainView = UIView(frame: view.bounds)
		mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(mainView)

		let overlayView = UIView(frame: view.bounds)
		overlayView.backgroundColor = UIColor.black
		overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		overlayView.isHidden = true
		view.addSubview(overlayView)

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSidePanel))
		overlayView.addGestureRecognizer(tapGesture)

		let sideView = UIView(frame: CGRect(x: 0 - sidePanelWidth, y: 0, width: sidePanelWidth, height: view.bounds.height))
		view.addSubview(sideView)

		self.mainView = mainView
		self.overlayMainView = overlayView
		sidePanelView = sideView
		self.view = view
	}

	required public init?(coder aDecoder: NSCoder) {

		fatalError("init(coder:) has not been implemented")
	}
}
