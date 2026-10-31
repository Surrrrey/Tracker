import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: - Layout Properties
    
    private let backgroundColor = UIColor(resource: .whiteDay)
    
    private let plusButton = UIButton()
    private let plusButtonImage = UIImage(systemName: "plus")?.withTintColor(.blackDay)
    private let plusButtonSize = CGSize(width: 42, height: 42)
    
    private let titleLabel = UILabel()
    private let titleText = "Трекеры"
    private let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
    
    private let dateLabel = UILabel()
    private let dateFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let dateTextColor = UIColor(resource: .blackDay)
    
    private let dateBackgroundView = UIImageView()
    private let dateBackgroundColor = UIColor(resource: .ypLightGray)
    
    private let searchField = UISearchTextField()
    private let searchFieldPlaceholder = "Поиск"
    private let searchFieldHeight = 36.0
    private let searchFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    private var emptyTrackersImageView = UIImageView()
    private let emptyTrackersImage = UIImage(resource: .dizzy)
    private let emptyImageSize = CGSize(width: 80, height: 80)
    
    private let emptyTrackersLabel = UILabel()
    private let emptyTrackersLabelText = "Что будем отслеживать?"
    private let emptyTrackersLabelFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    private let emptyTrackersLabelTextColor = UIColor(resource: .blackDay)
    
    
    //MARK: - Properties
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private var activeTrackers = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
    }
    
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    
}

//MARK: - Layout

extension TrackersViewController {
    
    private func configViews() {
        view.backgroundColor = backgroundColor
        
        configPlusButton()
        configDateLabel()
        configDateBackground()
        configTitleLabel()
        configSearchField()
        
        guard activeTrackers == 0 else { return }
        configEmptyImage()
        configEmptyLabel()
    }
    
    private func configPlusButton() {
        plusButton.setImage(plusButtonImage, for: .normal)
        plusButton.tintColor = .blackDay
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.widthAnchor.constraint(equalToConstant: plusButtonSize.width),
            plusButton.heightAnchor.constraint(equalToConstant: plusButtonSize.height)
        ])
    }
    
    private func configDateLabel() {
        dateLabel.text = TrackersViewController.dateFormatter.string(from: Date())
        dateLabel.font = dateFont
        dateLabel.textColor = dateTextColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configDateBackground() {
        dateBackgroundView.backgroundColor = .ypLightGray
        dateBackgroundView.layer.cornerRadius = 8
        dateBackgroundView.clipsToBounds = true
        dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        guard dateLabel.superview == view else { return }
        
        view.insertSubview(dateBackgroundView, belowSubview: dateLabel)
        
        NSLayoutConstraint.activate([
            dateBackgroundView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5.5),
            dateBackgroundView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5.5),
            dateBackgroundView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -6),
            dateBackgroundView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6)
        ])
    }
    
    private func configTitleLabel() {
        titleLabel.text = titleText
        titleLabel.font = titleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1)
        ])
    }
    
    private func configSearchField() {
        searchField.font = searchFieldFont
        searchField.placeholder = searchFieldPlaceholder
        searchField.textColor = .blackDay
        searchField.leftView?.tintColor = .ypGray
        searchField.tintColor = .ypGray
        searchField.backgroundColor = .ypLightGray
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: searchFieldHeight),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7)
        ])
    }
    
    private func configEmptyImage() {
        emptyTrackersImageView.image = convertToBlack(image: emptyTrackersImage)
        emptyTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyTrackersImageView)
        
        NSLayoutConstraint.activate([
            emptyTrackersImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackersImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyTrackersImageView.widthAnchor.constraint(equalToConstant: emptyImageSize.width),
            emptyTrackersImageView.heightAnchor.constraint(equalToConstant: emptyImageSize.height)
        ])
    }
    
    private func configEmptyLabel() {
        emptyTrackersLabel.text = emptyTrackersLabelText
        emptyTrackersLabel.font = emptyTrackersLabelFont
        emptyTrackersLabel.textColor = emptyTrackersLabelTextColor
        emptyTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyTrackersLabel)
        
        NSLayoutConstraint.activate([
            emptyTrackersLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func convertToBlack(image: UIImage) -> UIImage? {
        let blackImage = CIImage(image: image)?.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: 0.0])
        guard let blackImage else { return nil }
        return UIImage(ciImage: blackImage)
    }
}
