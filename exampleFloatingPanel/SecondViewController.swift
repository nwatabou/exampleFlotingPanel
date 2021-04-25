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

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textView: InputView = {
        let view = InputView()
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: InputView.getHeight())
        ])
        return view
    }()

    private let dropShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textViewBottomAnchor: NSLayoutConstraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

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
        subscribeKeyboardNotification()
    }

    static func build() -> UIViewController {
        let fpc = FloatingPanelController()
        let vc = SecondViewController(fpc: fpc)
        fpc.isRemovalInteractionEnabled = true
        fpc.delegate = vc
        fpc.layout = CustomFloatingPanelLayout()
        fpc.behavior = CustomFloatingPanelBehavior()
        fpc.surfaceView.grabberHandle.isHidden = true
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textViewBottomAnchor
        ])

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tapKeyboardOutside))
        dropShadowView.addGestureRecognizer(tapGesture)

        guard let fpc = fpc else { return }
        fpc.track(scrollView: tableView)

        let tapGestureForBackDropView = UITapGestureRecognizer()
        tapGestureForBackDropView.addTarget(self, action: #selector(tappedBackDropView))
        fpc.backdropView.addGestureRecognizer(tapGestureForBackDropView)

        fpc.view.addSubview(dropShadowView)
        NSLayoutConstraint.activate([
            dropShadowView.topAnchor.constraint(equalTo: fpc.view.topAnchor),
            dropShadowView.leadingAnchor.constraint(equalTo: fpc.view.leadingAnchor),
            dropShadowView.trailingAnchor.constraint(equalTo: fpc.view.trailingAnchor),
            dropShadowView.bottomAnchor.constraint(equalTo: fpc.view.bottomAnchor),
        ])
    }

    private func subscribeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShowNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        textViewBottomAnchor.constant = -keyboardHeight
        dropShadowView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

    @objc
    private func keyboardWillHideNotification(notification: NSNotification) {
        textViewBottomAnchor.constant = 0.0
        dropShadowView.isHidden = true
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

    @objc
    private func tapKeyboardOutside() {
        textView.hideKeyboard()
    }

    @objc
    private func tappedBackDropView() {
        dismiss(animated: true, completion: nil)
    }
}

extension SecondViewController {
    class CustomFloatingPanelLayout: FloatingPanelLayout {
        var position: FloatingPanelPosition = .bottom

        var initialState: FloatingPanelState = .half

        var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] = [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.7, edge: .bottom, referenceGuide: .safeArea)
        ]

        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            switch state {
            case .half:
                return 0.1
            default:
                return 0.7
            }
        }
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
