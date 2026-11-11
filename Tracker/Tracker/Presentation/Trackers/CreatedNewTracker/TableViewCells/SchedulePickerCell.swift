import UIKit

final class SchedulePickerCell: UITableViewCell {
    
    //MARK: - Layout Properties
    
    private let background = UIColor(resource: .backgroundDay)
    
    private let titleLabel = UILabel()
    private let textFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let textColor = UIColor(resource: .blackDay)
    
    private let switcher = UISwitch()
    
    //MARK: - Properties
    
    static let reuseIdentifier = "SchedulePickerCell"
        
    private var onSwitchToggle: ((Bool) -> Void)?
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configCell()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(with weekday: Weekday, isSelected: Bool, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = weekday.displayName
        switcher.isOn = isSelected
        onSwitchToggle = onToggle
    }
    
    func configureEveryDaySetting(isSelected: Bool, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = "Каждый день"
        switcher.isOn = isSelected
        onSwitchToggle = onToggle
    }
}

//MARK: - Layout

extension SchedulePickerCell {
    private func configCell() {
        backgroundColor = background
        
        configLabel()
        configSwitcher()
    }
    
    private func configLabel() {
        titleLabel.font = textFont
        titleLabel.textColor = textColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    private func configSwitcher() {
        switcher.onTintColor = .ypBlue
        
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        switcher.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onSwitchToggle?(self.switcher.isOn)
        }, for: .valueChanged)
    }
}
