import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: - Layout Properties
    
    private let backgroundColor = UIColor(resource: .whiteDay)
    
    private let addNewTaskButton = UIButton()
    private let newTaskButtonImage = UIImage(systemName: "plus")?.withTintColor(.blackDay)
    private let newTaskButtonSize = CGSize(width: 42, height: 42)
    
    private let datePicker = UIDatePicker()
    private let datePickerMode = UIDatePicker.Mode.date
    private let datePickerPreferredStyle = UIDatePickerStyle.compact
    private let datePickerBackgroundColor = UIColor(resource: .datePickerBackground) //Unused
    
    private let titleLabel = UILabel()
    private let titleText = "Трекеры"
    private let titleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
    
    private let dateLabel = UILabel()
    private let dateFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    private let dateTextColor = UIColor(resource: .blackDay)
    
    private let searchField = UISearchTextField()
    private let searchFieldBackgroundColor = UIColor(resource: .searchFieldBackground)
    private let searchFieldPlaceholder = "Поиск"
    private let searchFieldHeight = 36.0
    private let searchFieldFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let minimumInteritemSpacingForSection = 9.0
    private let cellHeight = 148.0
    
    private var emptyTrackersImageView = UIImageView()
    private let emptyTrackersImage = UIImage(resource: .dizzy)
    private let emptyImageSize = CGSize(width: 80, height: 80)
    
    private let emptyTrackersLabel = UILabel()
    private let emptyTrackersLabelText = "Что будем отслеживать?"
    private let emptyTrackersLabelFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    private let emptyTrackersLabelTextColor = UIColor(resource: .blackDay)
    
    
    //MARK: - Properties
    
    private var categories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var currentDay = Date() {
        didSet {
            reloadContent()
        }
    }
    
    private var visibleTrackers: [Tracker] {
        categories
            .flatMap { $0.trackers }
            .filter { $0.isScheduled(on: currentDay) }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        
        addDatePikerTarget()
        reloadContent()
    }
    
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    
    private func addNewTaskButtonDidTap() {
        let createdNewTrackerVC = CreatedNewTrackerVC()
        
        createdNewTrackerVC.onTrackerCreated = { [weak self] category in
            self?.categories.append(category)
            self?.reloadContent()
        }
        
        ViewControllerSwitcher.shared.presentNavigationController(from: self, createdNewTrackerVC)
    }
    
    private func reloadContent() {
        let isEmpty = visibleTrackers.isEmpty
        
        if isEmpty {
            trackersCollectionView.removeFromSuperview()
            if emptyTrackersImageView.superview == nil {
                configEmptyImage()
                configEmptyLabel()
            }
        } else {
            emptyTrackersImageView.removeFromSuperview()
            emptyTrackersLabel.removeFromSuperview()
            configCollectionView()
            trackersCollectionView.reloadData()
        }
        
    }
    
    private func isTrackerCompleted(_ tracker: Tracker) -> Bool {
        completedTrackers.contains { record in
            record.TrackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: currentDay)
        }
    }
    
    private func isFutureDaySelected() -> Bool {
        Calendar.current.startOfDay(for: currentDay) >
        Calendar.current.startOfDay(for: Date())
    }
    
    private func trackerCompletedButtonDidTap(for tracker: Tracker) {
        guard !isFutureDaySelected() else { return } // TODO: - Можно показать ошибку с информацией о том что выбран день из будущего либо изменить фон кнопки на неактивный
        
        if let index = completedTrackers.firstIndex(where: {
            $0.TrackerId == tracker.id &&
            Calendar.current.isDate($0.date, inSameDayAs: currentDay)
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(TrackerId: tracker.id, date: currentDay))
        }
        trackersCollectionView.reloadData()
    }
    
    private func addDatePikerTarget() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDay = Calendar.current.startOfDay(for: sender.date)
    }
}

//MARK: - Data Source

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell

        guard let cell else { return UICollectionViewCell(frame: .zero)}
        
        let tracker = visibleTrackers[indexPath.item]

        cell.tracker = tracker
        cell.isCompleted = isTrackerCompleted(tracker)
        cell.completedDays = Set(
            completedTrackers.filter { $0.TrackerId == tracker.id }
                .map { Calendar.current.startOfDay(for: $0.date) }).count
        
        if isFutureDaySelected() {
            cell.isCompleted = false
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        cell.onToggle = { [weak self] in
            self?.trackerCompletedButtonDidTap(for: tracker)
        }
        
        return cell
    }
}

//MARK: - Delegate Flow

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2 - (minimumInteritemSpacingForSection / 2), height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        minimumInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


//MARK: - Layout

extension TrackersViewController {
    
    private func configViews() {
        view.backgroundColor = backgroundColor
        
        configNavigationBar()
        configTitleLabel()
        configSearchField()
    }
    
    private func configNavigationBar() {
        configDatePicker()
        configAddNewTaskButton()
        
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTaskButton)
        
        if #available(iOS 26.0, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
            navigationItem.rightBarButtonItem?.hidesSharedBackground = true
        }
    }
    
    private func configAddNewTaskButton() {
        addNewTaskButton.setImage(newTaskButtonImage, for: .normal)
        addNewTaskButton.tintColor = .blackDay
        
        addNewTaskButton.addAction(UIAction { [weak self] _ in
            self?.addNewTaskButtonDidTap()
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addNewTaskButton.widthAnchor.constraint(equalToConstant: newTaskButtonSize.width),
            addNewTaskButton.heightAnchor.constraint(equalToConstant: newTaskButtonSize.height)
        ])
    }
    
    private func configDatePicker() {
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = datePickerPreferredStyle
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configTitleLabel() {
        titleLabel.text = titleText
        titleLabel.font = titleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
    }
    
    private func configSearchField() {
        searchField.font = searchFieldFont
        searchField.placeholder = searchFieldPlaceholder
        searchField.textColor = .blackDay
        searchField.leftView?.tintColor = .ypGray
        searchField.tintColor = .ypGray
        searchField.backgroundColor = searchFieldBackgroundColor
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: searchFieldHeight),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7)
        ])
    }
    
    private func configCollectionView() {
        setDelegate()
        setDataSource()
        registerCell()
        
        trackersCollectionView.allowsMultipleSelection = false
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 34),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func setDelegate() {
        trackersCollectionView.delegate = self
    }
    
    private func setDataSource() {
        trackersCollectionView.dataSource = self
    }
    
    private func registerCell() {
        trackersCollectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
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
