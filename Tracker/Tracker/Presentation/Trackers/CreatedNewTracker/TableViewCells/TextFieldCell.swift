import UIKit

//MARK: - Delegate

protocol TextFieldCellDelegate: AnyObject {
    func textFieldCell(_ cell: TextFieldCell, didChangeText text: String)
}

final class TextFieldCell: UITableViewCell {
    
    //MARK: - Layout Properties
    
    private let cornerRadius = 16.0
    private let background = UIColor(resource: .backgroundDay)
    
    let textField = UITextField()
    private let textFieldPlaceholder = "Введите название трекера"
    
    private let clearTextFieldButton = UIButton()
    private let clearButtonImage = UIImage(systemName: "xmark.circle")
    
    
    //MARK: - Properties
    
    weak var delegate: TextFieldCellDelegate?
    
    static let reuseIdentifier = "TextFieldCell"
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configCell()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Private Methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldCell(self, didChangeText: textField.text ?? "")
    }
}

//MARK: - Layout

extension TextFieldCell {
    
    private func configCell() {
        selectionStyle = .none
        contentView.backgroundColor = background
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        configTextField()
    }
        
    private func configTextField() {
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.placeholder = textFieldPlaceholder
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
