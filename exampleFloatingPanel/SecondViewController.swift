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
        fpc.layout = CustomFloatingPanelLayout()
        fpc.behavior = CustomFloatingPanelBehavior()
        fpc.set(contentViewController: vc)
        return fpc
    }

    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        guard !fpc.isAttracting else { return }
        // 上スクロールできないように
        if fpc.surfaceLocation.y < 184.5 {
            fpc.surfaceLocation = .init(x: fpc.surfaceLocation.x, y: 184.5)
        }
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

extension SecondViewController {
    class CustomFloatingPanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition = .bottom

        var initialState: FloatingPanelState = .half

        var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] = [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.7, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    class CustomFloatingPanelBehavior: FloatingPanelBehavior {
        func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
            return false
        }

        func shouldProjectMomentum(_ fpc: FloatingPanelController, to proposedTargetPosition: FloatingPanelState) -> Bool {
            return true
        }
    }
}
