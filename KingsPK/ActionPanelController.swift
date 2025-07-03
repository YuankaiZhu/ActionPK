//
//  ActionPanelController.swift
//  KingsPK
//
//  Created by YuankaiZhu on 7/3/25.
//

import UIKit
import SwiftUI

class MyUIKitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SwiftUI view
        let swiftUIView = PKControlPanel()

        // Wrap it in a UIHostingController
        let hostingController = UIHostingController(rootView: swiftUIView)

        // Add as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set constraints or frame
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
