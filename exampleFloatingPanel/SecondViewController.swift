//
//  SecondViewController.swift
//  exampleFloatingPanel
//
//  Created by Wataru Nakanishi on 2021/04/25.
//

import UIKit
import FloatingPanel

final class SecondViewController: UIViewController, FloatingPanelControllerDelegate {
    
    private weak var fpc: FloatingPanelController?
    
    private let tableView: UITableView = {
        let view = UITableView()
        return view
    }()
       
    init(fpc: FloatingPanelController) {
        self.fpc = fpc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    static func build() -> UIViewController {
        let fpc = FloatingPanelController()
        let vc = SecondViewController(fpc: fpc)
        fpc.isRemovalInteractionEnabled = true
        fpc.delegate = vc
        fpc.set(contentViewController: vc)
        return fpc
    }
}

extension SecondViewController  {
    private func configureView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        guard let fpc = fpc else { return }
        fpc.track(scrollView: tableView)
    }
}
