import UIKit

final class EmojiPickerCell: UICollectionViewCell {
    
    //MARK: - Layout Properties
    
    private let background = UIColor.clear
    private let cornerRadius = 8.0
    private let selectedEmojiCellBackground = UIColor(resource: .ypLightGray)
    
    private let emojiLabel = UILabel()
    private let emojiLabelFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    
    //MARK: - Properties
    
    static let identifier = "EmojiPickerCell"
        
    var emoji: String? {
        didSet {
            guard let emoji else { return }
            configureEmoji(with: emoji)
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
        contentView.backgroundColor = selectedEmojiCellBackground
    }
    
    func cellDidDeselect() {
        contentView.backgroundColor = background
    }
    
    //MARK: - Private Methods
    
    private func configureEmoji(with emoji: String) {
        emojiLabel.text = emoji
    }
}

//MARK: - Layout

extension EmojiPickerCell {
    
    private func configCell() {
        contentView.backgroundColor = background
        contentView.layer.cornerRadius = cornerRadius
        contentView.clipsToBounds = true
        
        configEmojiLabel()
    }
    
    private func configEmojiLabel() {
        emojiLabel.font = emojiLabelFont
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
    }
}
