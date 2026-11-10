import UIKit

final class SettingsCell: UITableViewCell {
    
    //MARK: - Layout Properties
    
    private let background = UIColor(resource: .backgroundDay)
    
    private let text = UILabel()
    private let textFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let textColor = UIColor(resource: .blackDay)
    
    private let firstSettingsCategory = "Категория"
    private let secondSettingsCategory = "Расписание"
    
    private let pickedOptionsLabel = UILabel()
    private let pickedOptionsLabelTextFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let pickedOptionsLabelTextColor = UIColor(resource: .ypGray)
    
    private let continueImageView = UIImageView()
    private let continueImage = UIImage(systemName: "chevron.right")
    private let continueImageColor = UIColor(resource: .ypGray)
    private let continueImageWidthAndHeight = 24.0
    
    //MARK: - Properties
    
    static let reuseIdentifier = "SettingsCell"
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configCell()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    func setText(with indexPath: IndexPath) {
        if indexPath.row == 0 {
            text.text = firstSettingsCategory
        }
        if indexPath.row == 1 {
            text.text = secondSettingsCategory
        }
    }
    
    func setPickedDaysText(with text: String) {
        pickedOptionsLabel.text = text
    }
}

//MARK: - Layout

extension SettingsCell {
    
    private func configCell() {
        selectionStyle = .none
        contentView.backgroundColor = background
        contentView.layer.masksToBounds = true
        
        configContinueImage()
        configTextLabel()
        configPickedOptionsLabel()
    }
        
    private func configTextLabel() {
        text.backgroundColor = .clear
        text.font = textFont
        text.textColor = textColor
        
        text.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(text)
        
        if pickedOptionsLabel.text == "" {
            NSLayoutConstraint.activate([
                text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                text.trailingAnchor.constraint(equalTo: continueImageView.leadingAnchor, constant: -1)
            ]) } else {
                NSLayoutConstraint.activate([
                    text.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                    text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    text.trailingAnchor.constraint(equalTo: continueImageView.leadingAnchor, constant: -1)
                ])
            }
    }
    
    private func configPickedOptionsLabel() {
        pickedOptionsLabel.textColor = pickedOptionsLabelTextColor
        pickedOptionsLabel.font = pickedOptionsLabelTextFont
        
        pickedOptionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pickedOptionsLabel)
        
        NSLayoutConstraint.activate([
            pickedOptionsLabel.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 2),
            pickedOptionsLabel.leadingAnchor.constraint(equalTo: text.leadingAnchor),
            pickedOptionsLabel.trailingAnchor.constraint(equalTo: text.trailingAnchor),
            pickedOptionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
    
    private func configContinueImage() {
        continueImageView.image = continueImage
        continueImageView.tintColor = continueImageColor
        continueImageView.contentMode = .center
        continueImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(continueImageView)
        
        NSLayoutConstraint.activate([
            continueImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            continueImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            continueImageView.heightAnchor.constraint(equalToConstant: continueImageWidthAndHeight),
            continueImageView.widthAnchor.constraint(equalToConstant: continueImageWidthAndHeight)
        ])
    }
}

