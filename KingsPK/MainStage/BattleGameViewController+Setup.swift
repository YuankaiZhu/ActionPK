import UIKit

// MARK: - UI Setup Extension
extension BattleGameViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupHealthBars()
        setupPlayers()
        setupActionButton()
        setupCountdownLabel()
        setupSkillPanel()
        addSubviews()
    }
    
    private func setupHealthBars() {
        // Health bar backgrounds
        redHealthBackground.backgroundColor = .systemGray4
        blueHealthBackground.backgroundColor = .systemGray4
        redHealthBackground.layer.cornerRadius = healthBarHeight / 2
        blueHealthBackground.layer.cornerRadius = healthBarHeight / 2
        
        // Health bars
        redHealthBar.backgroundColor = .systemRed
        blueHealthBar.backgroundColor = .systemBlue
        redHealthBar.layer.cornerRadius = healthBarHeight / 2
        blueHealthBar.layer.cornerRadius = healthBarHeight / 2
    }
    
    private func setupPlayers() {
        redPlayer.backgroundColor = .systemRed
        bluePlayer.backgroundColor = .systemBlue
        redPlayer.layer.cornerRadius = playerSize / 2
        bluePlayer.layer.cornerRadius = playerSize / 2
    }
    
    private func setupActionButton() {
        actionButton.setTitle("行动", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 25
    }
    
    private func setupCountdownLabel() {
        countdownLabel.textAlignment = .center
        countdownLabel.font = .systemFont(ofSize: 18, weight: .medium)
        countdownLabel.textColor = .systemRed
        countdownLabel.isHidden = true
    }
    
    func setupSkillPanel() {
        skillPanel.backgroundColor = .clear
        skillPanel.isHidden = true
        
        // Panel background
        panelBackground.backgroundColor = .systemBackground
        panelBackground.layer.cornerRadius = 20
        panelBackground.layer.shadowColor = UIColor.black.cgColor
        panelBackground.layer.shadowOpacity = 0.3
        panelBackground.layer.shadowOffset = CGSize(width: 0, height: -2)
        panelBackground.layer.shadowRadius = 10
        
        // Skill buttons
        [attackButton, skill1Button, skill2Button].forEach { button in
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 15
        }
        
        attackButton.setTitle("🗡️ 攻击", for: .normal)
        attackButton.backgroundColor = .systemRed
        
        skill1Button.setTitle("⚡ 闪电攻击", for: .normal)
        skill1Button.backgroundColor = .systemPurple
        
        skill2Button.setTitle("🔥 火焰攻击", for: .normal)
        skill2Button.backgroundColor = .systemOrange
        
        skillPanel.addSubview(panelBackground)
        [attackButton, skill1Button, skill2Button].forEach {
            skillPanel.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        panelBackground.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        [redHealthBackground, blueHealthBackground, redHealthBar, blueHealthBar,
         redPlayer, bluePlayer, actionButton, countdownLabel, skillPanel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Health bar backgrounds
            redHealthBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            redHealthBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            redHealthBackground.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            redHealthBackground.heightAnchor.constraint(equalToConstant: healthBarHeight),
            
            blueHealthBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            blueHealthBackground.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            blueHealthBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            blueHealthBackground.heightAnchor.constraint(equalToConstant: healthBarHeight),
            
            // Health bars
            redHealthBar.topAnchor.constraint(equalTo: redHealthBackground.topAnchor),
            redHealthBar.leadingAnchor.constraint(equalTo: redHealthBackground.leadingAnchor),
            redHealthBar.bottomAnchor.constraint(equalTo: redHealthBackground.bottomAnchor),
            redHealthBar.trailingAnchor.constraint(equalTo: redHealthBackground.trailingAnchor),
            
            blueHealthBar.topAnchor.constraint(equalTo: blueHealthBackground.topAnchor),
            blueHealthBar.leadingAnchor.constraint(equalTo: blueHealthBackground.leadingAnchor),
            blueHealthBar.bottomAnchor.constraint(equalTo: blueHealthBackground.bottomAnchor),
            blueHealthBar.trailingAnchor.constraint(equalTo: blueHealthBackground.trailingAnchor),
            
            // Players
            redPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            redPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            redPlayer.widthAnchor.constraint(equalToConstant: playerSize),
            redPlayer.heightAnchor.constraint(equalToConstant: playerSize),
            
            bluePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bluePlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            bluePlayer.widthAnchor.constraint(equalToConstant: playerSize),
            bluePlayer.heightAnchor.constraint(equalToConstant: playerSize),
            
            // Action button
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Countdown label
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10),
            
            // Skill panel
            skillPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skillPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skillPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            skillPanel.heightAnchor.constraint(equalToConstant: 300),
            
            // Panel background
            panelBackground.leadingAnchor.constraint(equalTo: skillPanel.leadingAnchor, constant: 20),
            panelBackground.trailingAnchor.constraint(equalTo: skillPanel.trailingAnchor, constant: -20),
            panelBackground.bottomAnchor.constraint(equalTo: skillPanel.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            panelBackground.heightAnchor.constraint(equalToConstant: 200),
            
            // Skill buttons
            attackButton.centerXAnchor.constraint(equalTo: panelBackground.centerXAnchor),
            attackButton.topAnchor.constraint(equalTo: panelBackground.topAnchor, constant: 30),
            attackButton.widthAnchor.constraint(equalToConstant: 200),
            attackButton.heightAnchor.constraint(equalToConstant: 44),
            
            skill1Button.centerXAnchor.constraint(equalTo: panelBackground.centerXAnchor),
            skill1Button.topAnchor.constraint(equalTo: attackButton.bottomAnchor, constant: 15),
            skill1Button.widthAnchor.constraint(equalToConstant: 200),
            skill1Button.heightAnchor.constraint(equalToConstant: 44),
            
            skill2Button.centerXAnchor.constraint(equalTo: panelBackground.centerXAnchor),
            skill2Button.topAnchor.constraint(equalTo: skill1Button.bottomAnchor, constant: 15),
            skill2Button.widthAnchor.constraint(equalToConstant: 200),
            skill2Button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupActions() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        attackButton.addTarget(self, action: #selector(attackButtonTapped), for: .touchUpInside)
        skill1Button.addTarget(self, action: #selector(skill1ButtonTapped), for: .touchUpInside)
        skill2Button.addTarget(self, action: #selector(skill2ButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
}