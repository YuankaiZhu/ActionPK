//
//  KingsObject.swift
//  KingsPK
//
//  Created by ByteDance on 2025/7/3.
//

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
    private let playerSize: CGFloat = 50
    private let healthBarHeight: CGFloat = 20
    private let cooldownDuration = 3 // 3秒冷却时间
    
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
            redPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            redPlayer.widthAnchor.constraint(equalToConstant: playerSize),
            redPlayer.heightAnchor.constraint(equalToConstant: playerSize),
            
            bluePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bluePlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
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
            showSkillPanel()
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
        UIView.animate(withDuration: 0.2) {
            self.skillPanel.alpha = 0
            self.skillPanel.transform = CGAffineTransform(translationX: 0, y: 100)
        } completion: { _ in
            self.skillPanel.isHidden = true
        }
    }
    
    private func performAttack(skillType: String) {
        // 创建攻击特效
        let attackEffect = UIView()
        attackEffect.backgroundColor = .systemRed
        attackEffect.layer.cornerRadius = 25
        attackEffect.alpha = 0.8
        
        view.addSubview(attackEffect)
        attackEffect.translatesAutoresizingMaskIntoConstraints = false
        
        // 初始位置和大小
        NSLayoutConstraint.activate([
            attackEffect.centerXAnchor.constraint(equalTo: redPlayer.centerXAnchor),
            attackEffect.centerYAnchor.constraint(equalTo: redPlayer.centerYAnchor),
            attackEffect.widthAnchor.constraint(equalToConstant: 50),
            attackEffect.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.layoutIfNeeded()
        
        // 动画效果
        UIView.animate(withDuration: 0.8, animations: {
            // 移除原约束
            attackEffect.removeFromSuperview()
            self.view.addSubview(attackEffect)
            attackEffect.translatesAutoresizingMaskIntoConstraints = false
            
            // 设置新的约束（移动到蓝色玩家位置并变大）
            NSLayoutConstraint.activate([
                attackEffect.centerXAnchor.constraint(equalTo: self.bluePlayer.centerXAnchor),
                attackEffect.centerYAnchor.constraint(equalTo: self.bluePlayer.centerYAnchor),
                attackEffect.widthAnchor.constraint(equalToConstant: 80),
                attackEffect.heightAnchor.constraint(equalToConstant: 80)
            ])
            
            self.view.layoutIfNeeded()
        }) { _ in
            // 碰撞效果
            self.createCollisionEffect()
            attackEffect.removeFromSuperview()
            
            // 扣血
            self.blueHealth = max(0, self.blueHealth - 0.1)
            self.updateHealthBars()
            
            // 检查游戏结束
            if self.blueHealth <= 0 {
                self.gameOver(winner: "红色玩家")
            }
        }
        
        // 开始冷却
        startCooldown()
    }
    
    private func createCollisionEffect() {
        // 创建碰撞特效
        let collisionEffect = UIView()
        collisionEffect.backgroundColor = .systemYellow
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
        bluePlayer.transform = CGAffineTransform(translationX: -5, y: 0)
        UIView.animate(withDuration: 0.1, animations: {
            self.bluePlayer.transform = CGAffineTransform(translationX: 5, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.bluePlayer.transform = .identity
            }
        }
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

