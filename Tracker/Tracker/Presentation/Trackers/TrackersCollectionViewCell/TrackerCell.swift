import UIKit

final class TrackerCell: UICollectionViewCell {
    
    //MARK: - Layout
    
    private let cornerRadius = 16.0
    
    private let colorView = UIView()
    private let colorViewHeight = 90.0
    
    private let emojiLabel = UILabel()
    private let emojiWidthAndHeight = 24.0
    
    private let titleLabel = UILabel()
    private let titleFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    private let titleTextColor = UIColor(resource: .whiteDay)
    
    private let dayCompletedLabel = UILabel()
    private let dayCompletedFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    private let dayCompletedTextColor = UIColor(resource: .blackDay)
    
    private let completeButton = UIButton()
    private let completeButtonImage = UIImage(systemName: "plus")
    private let completeButtonTintColor = UIColor(resource: .whiteDay)
    private let completeButtonWidthAndHeight = 34.0
    
    private let completedButtonImage = UIImage(systemName: "checkmark")
    private let completedButtonAlpha = 0.3

    //MARK: - Properties
    
    static let reuseIdentifier = "TrackerCell"
    
    var onToggle: (() -> Void)?
    
    var isCompleted = false {
        didSet { updateCompleteButton() }
    }
    
    var completedDays = 0 {
        didSet { dayCompletedLabel.text = daysPluralized(completedDays) }
    }
    
    var tracker: Tracker? {
        didSet {
            guard let tracker else { return }
            configCell(with: tracker)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Public Methods
        
    //MARK: - Private Methods
    
    private func updateCompleteButton() {
        let image = isCompleted ? completedButtonImage : completeButtonImage
        completeButton.setImage(image, for: .normal)
        completeButton.alpha = isCompleted
        ? completedButtonAlpha
        : 1
    }
    
    private func daysPluralized(_ count: Int) -> String {
        let last = count % 10
        let tens = count % 100
        let form: String
        if (11...14).contains(tens) {
            form = "дней"
        } else if last == 1 {
            form = "день"
        } else if (2...4).contains(last) {
            form = "дня"
        } else {
            form = "дней"
        }
        return "\(count) \(form)"
    }
    
    private func configCell(with tracker: Tracker) {
        colorView.backgroundColor = tracker.color
        
        emojiLabel.text = tracker.emoji
        
        titleLabel.text = tracker.name
        
        completeButton.backgroundColor = tracker.color
    }
}

//MARK: - Layout

extension TrackerCell {
    
    private func configView() {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        configColorView()
        configEmojiLabel()
        configTitleLabel()
        configCompletedButton()
        configDayCompletedLabel()
    }
    
    private func configColorView() {
        colorView.layer.cornerRadius = cornerRadius
        colorView.layer.masksToBounds = true
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: colorViewHeight)
        ])
    }
    
    private func configEmojiLabel() {
        emojiLabel.layer.cornerRadius = emojiWidthAndHeight / 2
        emojiLabel.clipsToBounds = true

        emojiLabel.backgroundColor = UIColor(resource: .whiteDay).withAlphaComponent(0.3)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: emojiWidthAndHeight),
            emojiLabel.heightAnchor.constraint(equalToConstant: emojiWidthAndHeight)
        ])
    }
    
    private func configTitleLabel() {
        titleLabel.font = titleFont
        titleLabel.textColor = titleTextColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
    }
    
    private func configDayCompletedLabel() {
        dayCompletedLabel.text = "0 дней" //TODO: - Реализовать подсчёт дней
        dayCompletedLabel.font = dayCompletedFont
        dayCompletedLabel.textColor = dayCompletedTextColor
        
        dayCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dayCompletedLabel)
        
        NSLayoutConstraint.activate([
            dayCompletedLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dayCompletedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCompletedLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -12),
            dayCompletedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func configCompletedButton() {
        completeButton.layer.cornerRadius = completeButtonWidthAndHeight / 2
        completeButton.clipsToBounds = true

        completeButton.setImage(completeButtonImage, for: .normal)
        completeButton.tintColor = completeButtonTintColor

        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: completeButtonWidthAndHeight),
            completeButton.heightAnchor.constraint(equalToConstant: completeButtonWidthAndHeight)
        ])
        
        completeButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            self.onToggle?()
        }, for: .touchUpInside)
    }
}
