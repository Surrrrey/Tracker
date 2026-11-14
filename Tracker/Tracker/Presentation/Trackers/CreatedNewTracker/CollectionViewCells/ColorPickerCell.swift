import UIKit

final class ColorPickerCell: UICollectionViewCell {
    
    //MARK: - Layout Properties
    
    private let background = UIColor.clear
    private let cornerRadius = 8.0
    private let borderWidth = 3.0
    
    private let colorView = UIImageView()
    private let selectedColorBorderAlpha = 0.3

    
    //MARK: - Properties
    
    static let identifier = "ColorPickerCell"
        
    var color: UIColor? {
        didSet {
            guard let color else { return }
            configureColor(with: color)
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configCell()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Public Methods
    func cellDidSelected() {
        addBorder()
    }
    
    func cellDidDeselect() {
        contentView.layer.borderWidth = 0
    }
    
    //MARK: - Private Methods
    
    private func configureColor(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    private func addBorder() {
        guard let color else { return }
        contentView.layer.borderColor = color.withAlphaComponent(selectedColorBorderAlpha).cgColor
        contentView.layer.borderWidth = borderWidth
    }
}

//MARK: - Layout

extension ColorPickerCell {
    
    private func configCell() {
        contentView.backgroundColor = background
        contentView.layer.cornerRadius = cornerRadius
        contentView.clipsToBounds = true
        
        configColorView()
    }
    
    private func configColorView() {
        colorView.layer.cornerRadius = cornerRadius
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
