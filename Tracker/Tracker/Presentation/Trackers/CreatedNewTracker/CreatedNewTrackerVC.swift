import UIKit

final class CreatedNewTrackerVC: UIViewController {
    
    //MARK: - Layout Properties
    
    private let mainTitleText = "Новая привычка"
    
    private let textFieldTableView = UITableView(frame: .zero, style: .plain)
    
    private let tableViewCellHeight = 75.0
    private let cornerRadius = 16.0
    
    private let settingsTableView = UITableView(frame: .zero, style: .plain)
    
    private let backgroundColor = UIColor(resource: .whiteDay)
    
    private let stackView = UIStackView()
    private let stackViewHeight = 60.0
    
    private let cancelButton = UIButton()
    private let cancelButtonColor = UIColor(resource: .ypRed)
    private let borderWidth = 1.0
    
    private let createButton = UIButton()
    private let createButtonTextColor = UIColor(resource: .whiteDay)
    private let createButtonActiveColor = UIColor(resource: .blackDay)
    private let createButtonDisabledColor = UIColor(resource: .ypGray)

    //MARK: - Properties
    
    var pickedSchedule: Schedule = .none
    
    private let colorsSection: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3,
                                            .colorSelection4, .colorSelection5, .colorSelection6,
                                            .colorSelection7, .colorSelection8, .colorSelection9,
                                            .colorSelection10, .colorSelection11, .colorSelection12,
                                            .colorSelection13, .colorSelection14, .colorSelection15,
                                            .colorSelection16, .colorSelection17, .colorSelection18
    ]
    
    private let emojis = ["🐶", "🐱", "🐰", "🦊", "🐼", "🐻", "🐸", "🦉", "🚀", "⚽️", "📚", "🍳"]
    
    var onTrackerCreated: ((TrackerCategory) -> Void)?

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
    }
    
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    
    private func formatSchedule(_ schedule: Schedule) -> String {
        switch schedule {
        case .none:
            return ""
        case .daily:
            return "Каждый день"
        case .weekly(let days):
            guard !days.isEmpty else {
                return ""
            }
            let shortNames = days.sorted { $0.rawValue < $1.rawValue }.map { $0.displayShortName }
            return shortNames.joined(separator: ", ")
        }
    }
    
    private func currentTrackerName() -> String {
        guard let cell = textFieldTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell,
              let text = cell.textField.text
        else { return "" }
        return text
    }
    
    private func createTracker() {
        let name = currentTrackerName()
        
        let tracker = Tracker(id: UUID(),
                              name: name,
                              color: colorsSection.randomElement() ?? .colorSelection1,
                              emoji: emojis.randomElement() ?? "🐱",
                              schedule: pickedSchedule)
        
        let category = TrackerCategory(category: Categories(category: "Заглушка"), trackers: [tracker])
        
        onTrackerCreated?(category)
        dismiss(animated: true)
    }
}

//MARK: - Data Source

extension CreatedNewTrackerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == textFieldTableView {
            return 1
        } else if tableView == settingsTableView {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == textFieldTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath)
            
            guard let textFieldCell = cell as? TextFieldCell else { return UITableViewCell() }
            
            textFieldCell.delegate = self
            
            return textFieldCell
        } else if tableView == settingsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath)
            
            guard let settingsCell = cell as? SettingsCell else { return UITableViewCell() }
            
            settingsCell.setText(with: indexPath)
            if indexPath.row == 1 {
                settingsCell.setPickedDaysText(with: formatSchedule(pickedSchedule))
            }
            let isLastRow = indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1)
            cell.separatorInset = isLastRow ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) : .zero
            
            return settingsCell
        }
        return UITableViewCell()
    }
}

//MARK: - Delegate

extension CreatedNewTrackerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //TODO: Category
        }
        if indexPath.row == 1 {
            let scheduleVC = ScheduleSettingsViewController()
            
            if case let .weekly(days) = pickedSchedule {
                scheduleVC.currentDays = days
            }
            if case .daily = pickedSchedule {
                scheduleVC.currentDays.insert(Weekday.monday)
                scheduleVC.currentDays.insert(Weekday.tuesday)
                scheduleVC.currentDays.insert(Weekday.wednesday)
                scheduleVC.currentDays.insert(Weekday.thursday)
                scheduleVC.currentDays.insert(Weekday.friday)
                scheduleVC.currentDays.insert(Weekday.saturday)
                scheduleVC.currentDays.insert(Weekday.sunday)
            }
            
            scheduleVC.onSchedulePicked = { [weak self] schedule in
                self?.pickedSchedule = schedule
                self?.updateCreateButtonState()
                self?.settingsTableView.reloadData()
            }
            ViewControllerSwitcher.shared.presentNavigationController(from: self, scheduleVC)
        }
    }
}

//MARK: - Text Field Delegate

extension CreatedNewTrackerVC: TextFieldCellDelegate {
    func textFieldCell(_ cell: TextFieldCell, didChangeText text: String) {
            updateCreateButtonState()
    }
    
    private func updateCreateButtonState() {
        let name = currentTrackerName()
        let hasName = !name.trimmingCharacters(in: .whitespaces).isEmpty
        
        var hasSchedule = false
        
        switch pickedSchedule {
        case.none:
            hasSchedule = false
        case .daily:
            hasSchedule = true
        case .weekly:
            hasSchedule = true
        }
        
        if hasName && hasSchedule {
            createButton.isEnabled = true
            createButton.backgroundColor = createButtonActiveColor
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = createButtonDisabledColor
        }
    }
}

//MARK: - Layout

extension CreatedNewTrackerVC {
    
    private func configView() {
        view.backgroundColor = backgroundColor
        
        configMainTitle()
        configTextFieldTableView()
        configSettingsTableView()
        configStackView()
    }
    
    private func configMainTitle() {
        navigationItem.title = mainTitleText
    }
    
    private func configTextFieldTableView() {
        textFieldTableView.separatorStyle = .none
        textFieldTableView.backgroundColor = .clear
        textFieldTableView.layer.cornerRadius = cornerRadius
        textFieldTableView.layer.masksToBounds = true
        
        textFieldTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textFieldTableView)
        
        NSLayoutConstraint.activate([
            textFieldTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textFieldTableView.heightAnchor.constraint(equalToConstant: tableViewCellHeight)
        ])
        
        textFieldTableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        textFieldTableView.delegate = self
        textFieldTableView.dataSource = self
    }
    
    private func configSettingsTableView() {
        settingsTableView.separatorStyle = .singleLine
        settingsTableView.backgroundColor = .none
        settingsTableView.layer.cornerRadius = cornerRadius
        settingsTableView.layer.masksToBounds = true
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(settingsTableView)
        
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: textFieldTableView.bottomAnchor, constant: 24),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsTableView.heightAnchor.constraint(equalToConstant: tableViewCellHeight * 2)
        ])
        
        settingsTableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    private func configStackView() {
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        configCancelButton()
        configCreateButton()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        ])
    }
    
    private func configCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(cancelButtonColor, for: .normal)
        cancelButton.layer.cornerRadius = cornerRadius
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = backgroundColor
        cancelButton.layer.borderColor = cancelButtonColor.cgColor
        cancelButton.layer.borderWidth = borderWidth
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }
    
    private func configCreateButton() {
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(createButtonTextColor, for: .normal)
        createButton.backgroundColor = createButtonDisabledColor
        createButton.isEnabled = false
        createButton.layer.cornerRadius = cornerRadius
        createButton.layer.masksToBounds = true
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.createTracker()
        }, for: .touchUpInside)
    }
}
