//
//  ViewController.swift
//  BancaPushNotification
//
//  Created by Shanmugasundharam on 17/02/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        // Navigation Bar:
        navigationController?.navigationBar.barTintColor = .red
        // Navigation Bar Text:
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = "Banca"
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
    }
}

