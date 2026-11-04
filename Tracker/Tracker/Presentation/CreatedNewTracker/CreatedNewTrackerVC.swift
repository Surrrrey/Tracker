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
    private let createButtonColor = UIColor(resource: .whiteDay)
    private let createButtonDisabledColor = UIColor(resource: .ypGray)

    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
    }
    
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    
}

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
            
            return textFieldCell
        } else if tableView == settingsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath)
            
            guard let settingsCell = cell as? SettingsCell else { return UITableViewCell() }
            
            settingsCell.setText(with: indexPath)
            
            return settingsCell
        }
        return UITableViewCell()
    }
}

extension CreatedNewTrackerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewCellHeight
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
    }
    
    private func configCreateButton() {
        createButton.isEnabled = false
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(createButtonColor, for: .normal)
        createButton.layer.cornerRadius = cornerRadius
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = createButtonDisabledColor
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
    }
}
