import UIKit

class BattleGameViewController: UIViewController {
    
    // MARK: - UI Components
    let redHealthBar = UIView()
    let blueHealthBar = UIView()
    let redHealthBackground = UIView()
    let blueHealthBackground = UIView()
    
    let redPlayer = UIView()
    let bluePlayer = UIView()
    
    let actionButton = UIButton(type: .system)
    let countdownLabel = UILabel()
    
    let skillPanel = UIView()
    let attackButton = UIButton(type: .system)
    let skill1Button = UIButton(type: .system)
    let skill2Button = UIButton(type: .system)
    let panelBackground = UIView()
    
    // MARK: - Game State
    var redHealth: CGFloat = 1.0
    var blueHealth: CGFloat = 1.0
    var isOnCooldown = false
    var cooldownTimer: Timer?
    var countdownSeconds = 0
    
    // MARK: - Constants
    let playerSize: CGFloat = 100
    let healthBarHeight: CGFloat = 20
    let cooldownDuration = 30
    
    let skillPanelVC: PKControlPanelController = PKControlPanelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupNotificationObserver()
    }
    
    // MARK: - Notification Observer
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: .skillTriggered,
            object: nil,
            queue: .main
        ) { notification in
            if let userInfo = notification.userInfo {
                print("Skill triggered: \(userInfo)")
                self.hideSkillPanel()
                let skillId: String = userInfo["skillId"] as? String ?? ""
                let skillType = userInfo["skillType"] as? String ?? ""
                
                self.handleSkillAnimation(skillId: skillId, skillType: skillType)
                self.startCooldown()
            }
        }
    }
    
    // MARK: - Skill Animation Handler
    private func handleSkillAnimation(skillId: String, skillType: String) {
        let isAttackSkill = skillType.contains("attack") || SkillData.attackSkills.contains { $0.id == skillId }
        
        switch skillId {
        // Attack Skills
        case "fireball": performFireballAttack()
        case "lightning": performLightningAttack()
        case "ice_spike": performIceSpikeAttack()
        case "shadow_strike": performShadowStrikeAttack()
        case "earth_quake": performEarthQuakeAttack()
        case "wind_slash": performWindSlashAttack()
        case "poison_dart": performPoisonDartAttack()
        case "holy_smite": performHolySmiteAttack()
        case "dark_void": performDarkVoidAttack()
        case "meteor": performMeteorAttack()
            
        // Defense Skills
        case "shield": performShieldDefense()
        case "barrier": performBarrierDefense()
        case "dodge": performDodgeDefense()
        case "reflect": performReflectDefense()
        case "immunity": performImmunityDefense()
            
        // Recovery Skills
        case "heal": performHealRecovery()
        case "regeneration": performRegenerationRecovery()
        case "energy_boost": performEnergyBoostRecovery()
        case "cleanse": performCleanseRecovery()
        case "revive": performReviveRecovery()
            
        default: performBasicAttack()
        }
        
        if isAttackSkill {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dealDamage()
            }
        }
    }
    
    // MARK: - Actions
    @objc func actionButtonTapped() {
        if !isOnCooldown {
            self.skillPanelVC.modalPresentationStyle = .custom
            self.skillPanelVC.transitioningDelegate = self
            present(self.skillPanelVC, animated: true, completion: nil)
        }
    }
    
    @objc func attackButtonTapped() {
        hideSkillPanel()
        performBasicAttack()
        startCooldown()
    }
    
    @objc func skill1ButtonTapped() {
        hideSkillPanel()
        performLightningAttack()
        startCooldown()
    }
    
    @objc func skill2ButtonTapped() {
        hideSkillPanel()
        performFireballAttack()
        startCooldown()
    }
    
    @objc func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !skillPanel.isHidden && !panelBackground.frame.contains(view.convert(location, to: skillPanel)) {
            hideSkillPanel()
        }
    }
    
    // MARK: - Game Logic
    func hideSkillPanel() {
        self.skillPanelVC.dismiss(animated: true)
    }
    
    func dealDamage() {
        blueHealth = max(0, blueHealth - 0.1)
        updateHealthBars()
        
        if blueHealth <= 0 {
            gameOver(winner: "红色玩家")
        }
    }
    
    func updateHealthBars() {
        UIView.animate(withDuration: 0.3) {
            self.redHealthBar.transform = CGAffineTransform(scaleX: self.redHealth, y: 1)
            self.blueHealthBar.transform = CGAffineTransform(scaleX: self.blueHealth, y: 1)
        }
    }
    
    private func startCooldown() {
        isOnCooldown = true
        countdownSeconds = cooldownDuration
        
        actionButton.backgroundColor = .systemGray
        actionButton.isEnabled = false
        
        countdownLabel.isHidden = false
        updateCountdownDisplay()
        
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.countdownSeconds -= 1
            self.updateCountdownDisplay()
            
            if self.countdownSeconds == 25 {
                self.countdownSeconds = 5
                self.showCooldownReductionToast()
            }
            
            if self.countdownSeconds <= 0 {
                self.endCooldown()
            }
        }
    }
    
    private func showCooldownReductionToast() {
        let toastLabel = UILabel()
        toastLabel.text = "点赞达到100，冷却时间-20s！！！"
        toastLabel.font = .systemFont(ofSize: 20, weight: .medium)
        toastLabel.textColor = .systemRed
        toastLabel.sizeToFit()
        self.view.addSubview(toastLabel)
        
        toastLabel.frame = CGRect(x: 100, y: 200, width: toastLabel.frame.width, height: toastLabel.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 3) {
            toastLabel.alpha = 0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    private func updateCountdownDisplay() {
        countdownLabel.text = "冷却中: \(countdownSeconds)s"
    }
    
    private func endCooldown() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        isOnCooldown = false
        
        actionButton.backgroundColor = .systemBlue
        actionButton.isEnabled = true
        
        countdownLabel.isHidden = true
    }
    
    private func gameOver(winner: String) {
        let alert = UIAlertController(title: "游戏结束", message: "\(winner)获胜！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "重新开始", style: .default) { _ in
            self.resetGame()
        })
        present(alert, animated: true)
    }
    
    private func resetGame() {
        redHealth = 1.0
        blueHealth = 1.0
        updateHealthBars()
        
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        endCooldown()
    }
    
    // Basic attack (kept in main file as default)
    func performBasicAttack() {
        let attackEffect = UIView()
        attackEffect.backgroundColor = .systemRed
        attackEffect.layer.cornerRadius = 25
        attackEffect.alpha = 0.8
        
        view.addSubview(attackEffect)
        attackEffect.frame = CGRect(
            x: redPlayer.frame.minX,
            y: redPlayer.frame.minY,
            width: 100,
            height: 100
        )
        
        UIView.animate(withDuration: 0.8, animations: {
            attackEffect.frame = CGRect(
                x: self.bluePlayer.frame.midX - 40,
                y: self.bluePlayer.frame.midY - 40,
                width: 80,
                height: 80
            )
        }) { _ in
            self.createCollisionEffect(color: .systemYellow)
            attackEffect.removeFromSuperview()
        }
    }
}
