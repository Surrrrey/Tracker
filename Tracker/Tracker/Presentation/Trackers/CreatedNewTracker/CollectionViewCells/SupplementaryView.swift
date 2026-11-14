import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "HeaderView"
    
    let titleLabel = UILabel()
    private let titleLabelFont = UIFont.systemFont(ofSize: 19, weight: .bold)
    private let titleLabelTextColor = UIColor(resource: .blackDay)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configHeader()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func configHeader() {
        titleLabel.font = titleLabelFont
        titleLabel.textColor = titleLabelTextColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
}
