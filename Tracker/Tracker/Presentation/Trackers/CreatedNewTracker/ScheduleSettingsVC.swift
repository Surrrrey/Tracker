import UIKit

final class ScheduleSettingsViewController: UIViewController {
    
    //MARK: - Layout Properties
    
    private let mainTitleText = "Расписание"
    
    private let backgroundColor = UIColor(resource: .whiteDay)
    
    private let scheduleTableView = UITableView(frame: .zero,style: .plain)
    
    private let tableViewCellHeight = 75.0
    private let cornerRadius = 16.0
    
    private let completeButton = UIButton()
    private let completeButtonHeight = 60.0
    private let completeButtonBackgroundColor = UIColor(resource: .blackDay)
    private let completeButtonTintColor = UIColor(resource: .whiteDay)
    
    //MARK: - Properties
    
    private var pickedDays: Set<Weekday> = []
    
    var currentDays: Set<Weekday> = []
    
    var onSchedulePicked: ((Schedule) -> Void)?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickedDays = currentDays
        
        configView()
    }
    
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    
}

//MARK: - Data Source

extension ScheduleSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchedulePickerCell.reuseIdentifier, for: indexPath) as? SchedulePickerCell
        
        guard let cell else { return UITableViewCell() }
        
        if indexPath.row < 7 {
            let day = Weekday.allCases[indexPath.row]
            cell.configure(with: day, isSelected: pickedDays.contains(day)) { [weak self] isOn in
                if isOn {
                    self?.pickedDays.insert(day)
                } else {
                    self?.pickedDays.remove(day)
                }
            }
            
            return cell
        } else {
            let isSelected: Bool = pickedDays.count == 7
            cell.configureEveryDaySetting(isSelected: isSelected) { [weak self] isOn in
                if isOn {
                    Weekday.allCases.forEach { self?.pickedDays.insert($0) }
                } else {
                    self?.pickedDays.removeAll()
                }
                
                tableView.reloadData() //TODO: - Сделать анимацию плавной
            }
            
            return cell
        }
    }
}

//MARK: - Delegate

extension ScheduleSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewCellHeight
    }
}

//MARK: - Layout

extension ScheduleSettingsViewController {
    
    private func configView() {
        view.backgroundColor = backgroundColor
        
        configMainTitle()
        configButton()
        configTableView()
    }
    
    private func configMainTitle() {
        navigationItem.title = mainTitleText
    }
    
    private func configTableView() {
        scheduleTableView.allowsSelection = false
        scheduleTableView.layer.cornerRadius = cornerRadius
        scheduleTableView.layer.masksToBounds = true
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: scheduleTableView.topAnchor, constant: tableViewCellHeight * Double(Weekday.allCases.count))
            
        ])
        
        scheduleTableView.register(SchedulePickerCell.self, forCellReuseIdentifier: SchedulePickerCell.reuseIdentifier)
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
    
    private func configButton() {
        completeButton.setTitle("Готово", for: .normal)
        completeButton.setTitleColor(completeButtonTintColor, for: .normal)
        completeButton.backgroundColor = completeButtonBackgroundColor
        completeButton.layer.cornerRadius = cornerRadius
        completeButton.layer.masksToBounds = true
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: completeButtonHeight)
        ])
        
        completeButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            var schedule : Schedule
            
            if self.pickedDays.count == 7 {
                schedule = .daily
            } else if self.pickedDays.isEmpty {
                schedule = .none
            } else {
                schedule = .weekly(days: pickedDays)
            }
            
            self.onSchedulePicked?(schedule)
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }
}
