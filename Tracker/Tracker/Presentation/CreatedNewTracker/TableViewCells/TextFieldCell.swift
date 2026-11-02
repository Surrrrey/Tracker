import UIKit

final class TextFieldCell: UITableViewCell {
    
    //MARK: - Layout Properties
    
    private let cornerRadius = 16.0
    private let background = UIColor(resource: .backgroundDay)
    
    private let textField = UITextField()
    private let textFieldPlaceholder = "Введите название трекера"
    
    private let clearTextFieldButton = UIButton()
    private let clearButtonImage = UIImage(systemName: "xmark.circle")
    
    
    //MARK: - Properties
    
    static let reuseIdentifier = "TextFieldCell"
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configCell()
    }
    
    required init?(coder: NSCoder) {
        nil
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
        textField.placeholder = textFieldPlaceholder
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            
        ])
    }
    
    private func showTextFieldButton() {
        
    }
}
