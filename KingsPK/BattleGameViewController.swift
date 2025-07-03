import UIKit

class BattleGameViewController: UIViewController {
    
    // MARK: - UI Components
    private let redHealthBar = UIView()
    private let blueHealthBar = UIView()
    private let redHealthBackground = UIView()
    private let blueHealthBackground = UIView()
    
    private let redPlayer = UIView()
    private let bluePlayer = UIView()
    
    private let actionButton = UIButton(type: .system)
    private let countdownLabel = UILabel()
    
    private let skillPanel = UIView()
    private let attackButton = UIButton(type: .system)
    private let skill1Button = UIButton(type: .system)
    private let skill2Button = UIButton(type: .system)
    private let panelBackground = UIView()
    
    // MARK: - Game State
    private var redHealth: CGFloat = 1.0
    private var blueHealth: CGFloat = 1.0
    private var isOnCooldown = false
    private var cooldownTimer: Timer?
    private var countdownSeconds = 0
    
    // MARK: - Constants
    private let playerSize: CGFloat = 100
    private let healthBarHeight: CGFloat = 20
    private let cooldownDuration = 30 // 冷却时间
    
    let skillPanelVC: MyUIKitViewController = MyUIKitViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 设置血条背景
        redHealthBackground.backgroundColor = .systemGray4
        blueHealthBackground.backgroundColor = .systemGray4
        redHealthBackground.layer.cornerRadius = healthBarHeight / 2
        blueHealthBackground.layer.cornerRadius = healthBarHeight / 2
        
        // 设置血条
        redHealthBar.backgroundColor = .systemRed
        blueHealthBar.backgroundColor = .systemBlue
        redHealthBar.layer.cornerRadius = healthBarHeight / 2
        blueHealthBar.layer.cornerRadius = healthBarHeight / 2
        
        // 设置玩家角色
        redPlayer.backgroundColor = .systemRed
        bluePlayer.backgroundColor = .systemBlue
        redPlayer.layer.cornerRadius = playerSize / 2
        bluePlayer.layer.cornerRadius = playerSize / 2
        
        // 设置操作按钮
        actionButton.setTitle("行动", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 25
        
        // 设置倒计时标签
        countdownLabel.textAlignment = .center
        countdownLabel.font = .systemFont(ofSize: 18, weight: .medium)
        countdownLabel.textColor = .systemRed
        countdownLabel.isHidden = true
        
        // 设置技能面板
        setupSkillPanel()
        
        // 添加到视图
        [redHealthBackground, blueHealthBackground, redHealthBar, blueHealthBar,
         redPlayer, bluePlayer, actionButton, countdownLabel, skillPanel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NotificationCenter.default.addObserver(
            forName: .skillTriggered,
            object: nil,
            queue: .main
        ) { notification in
            if let userInfo = notification.userInfo {
                print("Skill triggered: \(userInfo)")
                // Other developers can implement their character animations here
                self.hideSkillPanel()
                let name: String = userInfo["skillId"] as? String ?? ""
                switch name {
                case "fireball":
                    self.performFireAttack()
                default:
                    self.performBasicAttack()
                }
                
                // 开始冷却
                self.startCooldown()
            }
        }
    }
    
    private func setupSkillPanel() {
        skillPanel.backgroundColor = .clear
        skillPanel.isHidden = true
        
        // 半透明背景
        panelBackground.backgroundColor = .systemBackground
        panelBackground.layer.cornerRadius = 20
        panelBackground.layer.shadowColor = UIColor.black.cgColor
        panelBackground.layer.shadowOpacity = 0.3
        panelBackground.layer.shadowOffset = CGSize(width: 0, height: -2)
        panelBackground.layer.shadowRadius = 10
        
        // 设置技能按钮
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 血条背景约束
            redHealthBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            redHealthBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            redHealthBackground.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            redHealthBackground.heightAnchor.constraint(equalToConstant: healthBarHeight),
            
            blueHealthBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            blueHealthBackground.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            blueHealthBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            blueHealthBackground.heightAnchor.constraint(equalToConstant: healthBarHeight),
            
            // 血条约束
            redHealthBar.topAnchor.constraint(equalTo: redHealthBackground.topAnchor),
            redHealthBar.leadingAnchor.constraint(equalTo: redHealthBackground.leadingAnchor),
            redHealthBar.bottomAnchor.constraint(equalTo: redHealthBackground.bottomAnchor),
            redHealthBar.trailingAnchor.constraint(equalTo: redHealthBackground.trailingAnchor),
            
            blueHealthBar.topAnchor.constraint(equalTo: blueHealthBackground.topAnchor),
            blueHealthBar.leadingAnchor.constraint(equalTo: blueHealthBackground.leadingAnchor),
            blueHealthBar.bottomAnchor.constraint(equalTo: blueHealthBackground.bottomAnchor),
            blueHealthBar.trailingAnchor.constraint(equalTo: blueHealthBackground.trailingAnchor),
            
            // 玩家角色约束
            redPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            redPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            redPlayer.widthAnchor.constraint(equalToConstant: playerSize),
            redPlayer.heightAnchor.constraint(equalToConstant: playerSize),
            
            bluePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bluePlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            bluePlayer.widthAnchor.constraint(equalToConstant: playerSize),
            bluePlayer.heightAnchor.constraint(equalToConstant: playerSize),
            
            // 操作按钮约束
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 倒计时标签约束
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10),
            
            // 技能面板约束
            skillPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skillPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skillPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            skillPanel.heightAnchor.constraint(equalToConstant: 300),
            
            // 面板背景约束
            panelBackground.leadingAnchor.constraint(equalTo: skillPanel.leadingAnchor, constant: 20),
            panelBackground.trailingAnchor.constraint(equalTo: skillPanel.trailingAnchor, constant: -20),
            panelBackground.bottomAnchor.constraint(equalTo: skillPanel.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            panelBackground.heightAnchor.constraint(equalToConstant: 200),
            
            // 技能按钮约束
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
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        attackButton.addTarget(self, action: #selector(attackButtonTapped), for: .touchUpInside)
        skill1Button.addTarget(self, action: #selector(skill1ButtonTapped), for: .touchUpInside)
        skill2Button.addTarget(self, action: #selector(skill2ButtonTapped), for: .touchUpInside)
        
        // 添加点击手势以关闭面板
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func actionButtonTapped() {
        if !isOnCooldown {
            let controlPanelVC = PKControlPanelController()
            controlPanelVC.modalPresentationStyle = .custom
            controlPanelVC.transitioningDelegate = self
            present(controlPanelVC, animated: true, completion: nil)
        }
    }
    
    @objc private func attackButtonTapped() {
        hideSkillPanel()
        performAttack(skillType: "攻击")
    }
    
    @objc private func skill1ButtonTapped() {
        hideSkillPanel()
        performAttack(skillType: "闪电攻击")
    }
    
    @objc private func skill2ButtonTapped() {
        hideSkillPanel()
        performAttack(skillType: "火焰攻击")
    }
    
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !skillPanel.isHidden && !panelBackground.frame.contains(view.convert(location, to: skillPanel)) {
            hideSkillPanel()
        }
    }
    
    // MARK: - Game Logic
    private func showSkillPanel() {
        skillPanel.isHidden = false
        skillPanel.alpha = 0
        skillPanel.transform = CGAffineTransform(translationX: 0, y: 100)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.skillPanel.alpha = 1
            self.skillPanel.transform = .identity
        }
    }
    
    private func hideSkillPanel() {
//        UIView.animate(withDuration: 0.2) {
//            self.skillPanel.alpha = 0
//            self.skillPanel.transform = CGAffineTransform(translationX: 0, y: 100)
//        } completion: { _ in
//            self.skillPanel.isHidden = true
//        }
        self.skillPanelVC.dismiss(animated: true)
    }
    
    private func performAttack(skillType: String) {
        switch skillType {
        case "攻击":
            performBasicAttack()
        case "闪电攻击":
            performLightningAttack()
        case "火焰攻击":
            performFireAttack()
        default:
            performBasicAttack()
        }
        
        // 开始冷却
        startCooldown()
    }
    
    private func performBasicAttack() {
        // 创建基础攻击特效
        let attackEffect = UIView()
        attackEffect.backgroundColor = .systemRed
        attackEffect.layer.cornerRadius = 25
        attackEffect.alpha = 0.8
        
        view.addSubview(attackEffect)
        attackEffect.translatesAutoresizingMaskIntoConstraints = false
        
        // 初始位置和大小
//        NSLayoutConstraint.activate([
//            attackEffect.centerXAnchor.constraint(equalTo: redPlayer.centerXAnchor),
//            attackEffect.centerYAnchor.constraint(equalTo: redPlayer.centerYAnchor),
//            attackEffect.widthAnchor.constraint(equalToConstant: 50),
//            attackEffect.heightAnchor.constraint(equalToConstant: 50)
//        ])
        attackEffect.frame = CGRect(
            x: redPlayer.frame.minX,
            y: redPlayer.frame.minY,
            width: 100,
            height: 100
        )
        
        view.layoutIfNeeded()
        
        // 动画效果
        UIView.animate(withDuration: 0.8, animations: {
            attackEffect.frame = CGRect(
                x: attackEffect.frame.midX + 300,
                y: attackEffect.frame.minY,
                width: 80,
                height: 80
            )
        }) { _ in
            self.createCollisionEffect(color: .systemYellow)
            attackEffect.removeFromSuperview()
            self.dealDamage()
        }
    }
    
    private func performFireAttack() {
        // 创建火焰攻击特效
        let fireContainer = UIView()
        fireContainer.frame = CGRect(
            x: redPlayer.frame.midX - 25,
            y: redPlayer.frame.midY - 25,
            width: 50,
            height: 50
        )
        view.addSubview(fireContainer)
        
        // 创建多个火焰粒子
        for i in 0..<8 {
            let flame = UIView()
            flame.backgroundColor = i % 2 == 0 ? .systemRed : .systemOrange
            flame.layer.cornerRadius = 8
            flame.frame = CGRect(x: 20, y: 20, width: 16, height: 16)
            fireContainer.addSubview(flame)
            
            // 火焰粒子动画
            UIView.animate(withDuration: 0.6, delay: Double(i) * 0.05, options: [.repeat, .autoreverse], animations: {
                flame.transform = CGAffineTransform(scaleX: 1.5, y: 1.8)
                flame.alpha = 0.7
            })
        }
        
        // 火焰轨迹动画
        UIView.animate(withDuration: 1.0, delay: 0.3, options: .curveEaseInOut, animations: {
            fireContainer.frame = CGRect(
                x: self.bluePlayer.frame.midX - 40,
                y: self.bluePlayer.frame.midY - 40,
                width: 80,
                height: 80
            )
            fireContainer.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }) { _ in
            self.createFireExplosion()
            fireContainer.removeFromSuperview()
            self.dealDamage()
        }
    }
    
    private func performLightningAttack() {
        // 创建闪电路径
        let lightningPath = UIBezierPath()
        let startPoint = CGPoint(x: redPlayer.frame.midX, y: redPlayer.frame.midY)
        let endPoint = CGPoint(x: bluePlayer.frame.midX, y: bluePlayer.frame.midY)
        
        lightningPath.move(to: startPoint)
        
        // 创建锯齿状闪电路径
        let segments = 8
        for i in 1..<segments {
            let progress = CGFloat(i) / CGFloat(segments)
            let x = startPoint.x + (endPoint.x - startPoint.x) * progress
            let y = startPoint.y + (endPoint.y - startPoint.y) * progress
            
            // 添加随机偏移创造闪电效果
            let offset = (i % 2 == 0 ? 20 : -20) * sin(progress * .pi * 2)
            lightningPath.addLine(to: CGPoint(x: x, y: y + offset))
        }
        lightningPath.addLine(to: endPoint)
        
        // 创建闪电图层
        let lightningLayer = CAShapeLayer()
        lightningLayer.path = lightningPath.cgPath
        lightningLayer.strokeColor = UIColor.systemBlue.cgColor
        lightningLayer.lineWidth = 4
        lightningLayer.fillColor = UIColor.clear.cgColor
        lightningLayer.shadowColor = UIColor.cyan.cgColor
        lightningLayer.shadowOpacity = 0.8
        lightningLayer.shadowRadius = 4
        
        view.layer.addSublayer(lightningLayer)
        
        // 闪电动画
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = 0.3
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 4
        glowAnimation.toValue = 12
        glowAnimation.duration = 0.2
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = 3
        
        lightningLayer.add(strokeAnimation, forKey: "stroke")
        lightningLayer.add(glowAnimation, forKey: "glow")
        
        // 添加电击效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.createElectricShock()
            lightningLayer.removeFromSuperlayer()
            self.dealDamage()
        }
    }
    
    private func createFireExplosion() {
        // 创建火焰爆炸效果
        let explosionView = UIView()
        explosionView.frame = CGRect(
            x: bluePlayer.frame.midX - 60,
            y: bluePlayer.frame.midY - 60,
            width: 120,
            height: 120
        )
        view.addSubview(explosionView)
        
        // 创建火焰爆炸粒子
        for i in 0..<12 {
            let particle = UIView()
            particle.backgroundColor = i % 3 == 0 ? .systemRed : (i % 3 == 1 ? .systemOrange : .systemYellow)
            particle.layer.cornerRadius = 6
            particle.frame = CGRect(x: 54, y: 54, width: 12, height: 12)
            explosionView.addSubview(particle)
            
            let angle = CGFloat(i) * (.pi * 2 / 12)
            let distance: CGFloat = 50
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                particle.center = CGPoint(
                    x: 60 + cos(angle) * distance,
                    y: 60 + sin(angle) * distance
                )
                particle.alpha = 0
                particle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
        }
        
        // 核心爆炸效果
        let coreExplosion = UIView()
        coreExplosion.backgroundColor = .systemYellow
        coreExplosion.layer.cornerRadius = 15
        coreExplosion.frame = CGRect(x: 45, y: 45, width: 30, height: 30)
        explosionView.addSubview(coreExplosion)
        
        UIView.animate(withDuration: 0.3, animations: {
            coreExplosion.transform = CGAffineTransform(scaleX: 2, y: 2)
            coreExplosion.alpha = 0
        }) { _ in
            explosionView.removeFromSuperview()
        }
        
        // 震动效果
        createShakeEffect(for: bluePlayer)
    }
    
    private func createElectricShock() {
        // 创建电击效果
        let shockView = UIView()
        shockView.frame = bluePlayer.frame
        shockView.layer.cornerRadius = shockView.frame.width / 2
        shockView.layer.borderWidth = 3
        shockView.layer.borderColor = UIColor.systemBlue.cgColor
        shockView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        view.addSubview(shockView)
        
        // 电击动画
        UIView.animate(withDuration: 0.1, animations: {
            shockView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                shockView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    shockView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
                }) { _ in
                    shockView.removeFromSuperview()
                }
            }
        }
        
        // 电击粒子效果
        for i in 0..<6 {
            let spark = UIView()
            spark.backgroundColor = .cyan
            spark.layer.cornerRadius = 2
            spark.frame = CGRect(x: bluePlayer.frame.midX - 2, y: bluePlayer.frame.midY - 2, width: 4, height: 4)
            view.addSubview(spark)
            
            let angle = CGFloat(i) * (.pi * 2 / 6)
            let distance: CGFloat = 40
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                spark.center = CGPoint(
                    x: self.bluePlayer.frame.midX + cos(angle) * distance,
                    y: self.bluePlayer.frame.midY + sin(angle) * distance
                )
                spark.alpha = 0
            }) { _ in
                spark.removeFromSuperview()
            }
        }
        
        // 震动效果
        createShakeEffect(for: bluePlayer)
    }
    
    private func createShakeEffect(for view: UIView) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 3
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))
        view.layer.add(shake, forKey: "shake")
    }
    
    private func dealDamage() {
        // 扣血
        blueHealth = max(0, blueHealth - 0.1)
        updateHealthBars()
        
        // 检查游戏结束
        if blueHealth <= 0 {
            gameOver(winner: "红色玩家")
        }
    }
    
    private func createCollisionEffect(color: UIColor = .systemYellow) {
        // 创建碰撞特效
        let collisionEffect = UIView()
        collisionEffect.backgroundColor = color
        collisionEffect.layer.cornerRadius = 40
        collisionEffect.alpha = 0.9
        
        view.addSubview(collisionEffect)
        collisionEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collisionEffect.centerXAnchor.constraint(equalTo: bluePlayer.centerXAnchor),
            collisionEffect.centerYAnchor.constraint(equalTo: bluePlayer.centerYAnchor),
            collisionEffect.widthAnchor.constraint(equalToConstant: 80),
            collisionEffect.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        view.layoutIfNeeded()
        
        // 爆炸效果
        UIView.animate(withDuration: 0.3, animations: {
            collisionEffect.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            collisionEffect.alpha = 0
        }) { _ in
            collisionEffect.removeFromSuperview()
        }
        
        // 震动效果
        createShakeEffect(for: bluePlayer)
    }
    
    private func updateHealthBars() {
        UIView.animate(withDuration: 0.3) {
            self.redHealthBar.transform = CGAffineTransform(scaleX: self.redHealth, y: 1)
            self.blueHealthBar.transform = CGAffineTransform(scaleX: self.blueHealth, y: 1)
        }
    }
    
    private func startCooldown() {
        isOnCooldown = true
        countdownSeconds = cooldownDuration
        
        // 更新按钮状态
        actionButton.backgroundColor = .systemGray
        actionButton.isEnabled = false
        
        // 显示倒计时
        countdownLabel.isHidden = false
        updateCountdownDisplay()
        
        // 开始倒计时
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.countdownSeconds -= 1
            self.updateCountdownDisplay()
            
            if self.countdownSeconds == 25 {
                self.countdownSeconds = 5
                
                let toastLabel = UILabel()
                toastLabel.text = "点赞达到100，冷却时间-20s！！！"
                toastLabel.font = .systemFont(ofSize: 30, weight: .medium)
                toastLabel.textColor = .systemRed
                toastLabel.sizeToFit()
                self.view.addSubview(toastLabel)
                
                NSLayoutConstraint.activate([
                    toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    toastLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
                ])
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.3, delay: 5) {
                    toastLabel.
                }
            }
            
            if self.countdownSeconds <= 0 {
                self.endCooldown()
            }
        }
    }
    
    private func updateCountdownDisplay() {
        countdownLabel.text = "冷却中: \(countdownSeconds)s"
    }
    
    private func endCooldown() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        isOnCooldown = false
        
        // 恢复按钮状态
        actionButton.backgroundColor = .systemBlue
        actionButton.isEnabled = true
        
        // 隐藏倒计时
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
}

