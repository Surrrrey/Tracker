import UIKit

final class TrackerCellHeader: UICollectionReusableView { //TODO: - Реализация показа названия выбранной категории как хеддера. Должно быть сделано после реализации создания категорий
    
    let titleLabel = UILabel()
    private let titleFont = UIFont.systemFont(ofSize: 19, weight: .bold)
    private let titleColor = UIColor(resource: .blackDay)
    
    let reusableIdentifier = "TrackerHeader"
    
    var category: TrackerCategory?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configTitleLabel(with: category)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func configTitleLabel(with category: TrackerCategory?) {
        guard let category else { return }
        
        titleLabel.text = category.category.category // Поправить
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
