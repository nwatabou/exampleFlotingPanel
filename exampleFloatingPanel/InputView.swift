//
//  InputView.swift
//  exampleFloatingPanel
//
//  Created by Wataru Nakanishi on 2021/04/25.
//

import UIKit

final class InputView: UIView {
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        return view
    }()

    private let textFiled: UITextField = {
        let view = UITextField()
        view.placeholder = "ぷれーすほるだー"
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        return view
    }()

    var isKeyboardShown: Bool {
        textFiled.isFirstResponder
    }

    func hideKeyboard() {
        textFiled.resignFirstResponder()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func getHeight() -> CGFloat {
        return 20.0 + 16.0
    }
}

extension InputView {
    private func commonInit() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        addSubview(textFiled)
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),

            textFiled.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            textFiled.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            textFiled.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            textFiled.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ])
    }
}
