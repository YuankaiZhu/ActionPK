//
//  BattleGameViewController.swift
//  KingsPK
//
//  Created by YuankaiZhu on 7/3/25.
//
import UIKit

extension BattleGameViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return HalfHeightPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            heightRatio: 0.3
        )
    }
}

// MARK: - Custom UIPresentationController

class HalfHeightPresentationController: UIPresentationController {

    private let heightRatio: CGFloat
    private let dimmingView = UIView()

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, heightRatio: CGFloat) {
        self.heightRatio = heightRatio
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let height = container.bounds.height * heightRatio
        return CGRect(x: 0, y: container.bounds.height - height, width: container.bounds.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }

        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.frame = container.bounds

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.4
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPresented))
        dimmingView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissPresented() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
