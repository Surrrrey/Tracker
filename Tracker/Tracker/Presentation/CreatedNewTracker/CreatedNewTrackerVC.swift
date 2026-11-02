import UIKit

final class CreatedNewTrackerVC: UIViewController {
    
    //MARK: - Layout Properties
    
    let mainTitleText = "Новая привычка"
    
    private let textFieldTableView = UITableView(frame: .zero, style: .plain)
    private let textFieldPlaceholder = "Введите название трекера"
    
    private let tableViewCellHeight = 75.0
    private let tableViewCornerRadius = 16.0
    
    private let settingsTableView = UITableView(frame: .zero, style: .plain)
    
    private let backgroundColor = UIColor(resource: .whiteDay)
    
    private let cancelButton = UIButton()
    
    private let createButton = UIButton()
    
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
        configCancelButton()
        configCreateButton()
    }
    
    private func configMainTitle() {
        navigationItem.title = mainTitleText
        
    }
    
    private func configTextFieldTableView() {
        textFieldTableView.separatorStyle = .none
        textFieldTableView.backgroundColor = .clear
        textFieldTableView.layer.cornerRadius = tableViewCornerRadius
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
        settingsTableView.layer.cornerRadius = tableViewCornerRadius
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
    
    private func configCancelButton() {
        
    }
    
    private func configCreateButton() {
        
    }
}
