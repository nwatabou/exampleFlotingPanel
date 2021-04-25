//
//  ViewController.swift
//  exampleFloatingPanel
//
//  Created by Wataru Nakanishi on 2021/04/25.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("テスト", for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40.0),
            button.widthAnchor.constraint(equalToConstant: 80.0)
        ])
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension ViewController {
    private func configureView() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc
    private func tappedButton() {
        let vc = SecondViewController.build()
        present(vc, animated: true, completion: nil)
    }
}
