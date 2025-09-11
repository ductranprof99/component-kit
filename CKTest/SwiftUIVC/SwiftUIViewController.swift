//
//  SwiftUIViewController.swift
//  CKTest
//
//  Created by Duc Tran  on 11/9/25.
//


import UIKit
import SwiftUI

class SwiftUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftUI"

        // Create a SwiftUI view to display
        let swiftUIView = Text("Hello from SwiftUI")
            .font(.title)
            .padding()

        // Embed it in a hosting controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        // Constrain the hosting controller’s view to fill its parent
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}