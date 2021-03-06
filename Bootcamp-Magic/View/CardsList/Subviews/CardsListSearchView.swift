//
//  CardListSearchView.swift
//  Bootcamp-Magic
//
//  Created by lucas.henrique.costa on 17/02/21.
//

import UIKit
import SnapKit

protocol CardsListSearchViewDelegate: AnyObject {
    func textDidChange(_ text: String)
    func didCancelSearch()
}

final class CardsListSearchView: UIView {
    
    weak var delegate: CardsListSearchViewDelegate?
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
            textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "Search",
                                                                 attributes: [.foregroundColor: UIColor.white,
                                                                              .font: Fonts.robotoBold(size: 14).font])
        }
    }
    
    private(set) lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(searchCards(_:)), for: .editingChanged)
        textField.font = Fonts.robotoBold(size: 14).font
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.delegate = self
        return textField
    }()
        
    private let searchButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = Fonts.robotoBold(size: 14).font
        button.tintColor = .white
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        return button
    }()
    
    private let stackViewTextFieldSearchButton: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.addBorder(color: .white, width: 1, cornerRadius: 4)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10,
                                                                     leading: 15,
                                                                     bottom: 10,
                                                                     trailing: 15)
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancelButton.removeTarget(self, action: nil, for: .touchUpInside)
        textField.removeTarget(self, action: nil, for: .editingChanged)
    }
    
}

// MARK: ViewCodable
extension CardsListSearchView: ViewCodable {
    
    func buildViewHierarchy() {
        stackViewTextFieldSearchButton.addArrangedSubview(textField)
        stackViewTextFieldSearchButton.addArrangedSubview(searchButton)
        
        mainStackView.addArrangedSubview(stackViewTextFieldSearchButton)
        mainStackView.addArrangedSubview(cancelButton)
        addSubview(mainStackView)
    }
    
    func setupConstraints() {
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: Actions
private extension CardsListSearchView {
    
    @objc func searchCards(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.textDidChange(text)
        }
    }
    
    @objc func cancelSearch() {
        
        textField.resignFirstResponder()
        
        if !(textField.text?.isEmpty ?? false) {
            textField.text = ""
            delegate?.didCancelSearch()
        }
    }
}
