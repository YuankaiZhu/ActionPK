import UIKit

// MARK: - Recovery Skill Animations
extension BattleGameViewController {
    
    func performHealRecovery() {
        let healEffect = UIView()
        healEffect.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        healEffect.layer.cornerRadius = playerSize / 2
        healEffect.frame = redPlayer.frame
        view.addSubview(healEffect)
        
        for i in 0..<8 {
            let particle = UIView()
            particle.backgroundColor = .systemGreen
            particle.layer.cornerRadius = 4
            particle.frame = CGRect(
                x: redPlayer.frame.midX - 4,
                y: redPlayer.frame.maxY,
                width: 8,
                height: 8
            )
            view.addSubview(particle)
            
            UIView.animate(withDuration: 1.0, delay: Double(i) * 0.1, options: .curveEaseOut, animations: {
                particle.center.y = self.redPlayer.frame.minY - 20
                particle.alpha = 0
            }) { _ in
                particle.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            healEffect.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            healEffect.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                healEffect.transform = .identity
                healEffect.alpha = 0
            }) { _ in
                healEffect.removeFromSuperview()
                self.redHealth = min(1.0, self.redHealth + 0.3)
                self.updateHealthBars()
            }
        }
    }
    
    func performRegenerationRecovery() {
        let regenAura = UIView()
        regenAura.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        regenAura.layer.borderColor = UIColor.systemGreen.cgColor
        regenAura.layer.borderWidth = 2
        regenAura.layer.cornerRadius = playerSize / 2 + 10
        regenAura.frame = CGRect(
            x: redPlayer.frame.midX - playerSize / 2 - 10,
            y: redPlayer.frame.midY - playerSize / 2 - 10,
            width: playerSize + 20,
            height: playerSize + 20
        )
        view.addSubview(regenAura)
        
        var healCount = 0
        let healTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            healCount += 1
            
            let pulse = UIView()
            pulse.backgroundColor = .systemGreen
            pulse.alpha = 0.5
            pulse.layer.cornerRadius = 10
            pulse.frame = CGRect(
                x: regenAura.frame.width / 2 - 10,
                y: regenAura.frame.height / 2 - 10,
                width: 20,
                height: 20
            )
            regenAura.addSubview(pulse)
            
            UIView.animate(withDuration: 0.5, animations: {
                pulse.transform = CGAffineTransform(scaleX: 2, y: 2)
                pulse.alpha = 0
            }) { _ in
                pulse.removeFromSuperview()
            }
            
            self.redHealth = min(1.0, self.redHealth + 0.05)
            self.updateHealthBars()
            
            if healCount >= 8 {
                timer.invalidate()
                UIView.animate(withDuration: 0.5, animations: {
                    regenAura.alpha = 0
                }) { _ in
                    regenAura.removeFromSuperview()
                }
            }
        }
    }
    
    func performEnergyBoostRecovery() {
        let energyEffect = UIView()
        energyEffect.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        energyEffect.layer.cornerRadius = playerSize / 2
        energyEffect.frame = redPlayer.frame
        view.addSubview(energyEffect)
        
        for i in 0..<6 {
            let bolt = UIView()
            bolt.backgroundColor = .systemBlue
            bolt.layer.cornerRadius = 3
            bolt.frame = CGRect(
                x: redPlayer.frame.midX - 3,
                y: redPlayer.frame.midY - 3,
                width: 6,
                height: 6
            )
            view.addSubview(bolt)
            
            let angle = CGFloat(i) * (.pi * 2 / 6)
            UIView.animate(withDuration: 0.8, delay: Double(i) * 0.05, options: .curveEaseOut, animations: {
                bolt.center = CGPoint(
                    x: self.redPlayer.frame.midX + cos(angle) * 60,
                    y: self.redPlayer.frame.midY + sin(angle) * 60
                )
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    bolt.center = self.redPlayer.center
                    bolt.alpha = 0
                }) { _ in
                    bolt.removeFromSuperview()
                }
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            energyEffect.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                energyEffect.alpha = 0
            }) { _ in
                energyEffect.removeFromSuperview()
            }
        }
    }
    
    func performCleanseRecovery() {
        let cleanseWave = UIView()
        cleanseWave.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        cleanseWave.layer.cornerRadius = playerSize / 2
        cleanseWave.frame = redPlayer.frame
        view.addSubview(cleanseWave)
        
        for _ in 0..<20 {
            let sparkle = UIView()
            sparkle.backgroundColor = .white
            sparkle.layer.cornerRadius = 2
            let x = redPlayer.frame.midX + CGFloat.random(in: -30...30)
            let y = redPlayer.frame.midY + CGFloat.random(in: -30...30)
            sparkle.frame = CGRect(x: x, y: y, width: 4, height: 4)
            view.addSubview(sparkle)
            
            UIView.animate(withDuration: 0.5, delay: Double.random(in: 0...0.3), options: .curveEaseOut, animations: {
                sparkle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                sparkle.alpha = 0
            }) { _ in
                sparkle.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            cleanseWave.transform = CGAffineTransform(scaleX: 2, y: 2)
            cleanseWave.alpha = 0
        }) { _ in
            cleanseWave.removeFromSuperview()
        }
    }
    
    func performReviveRecovery() {
        let reviveLight = UIView()
        reviveLight.backgroundColor = .systemYellow
        reviveLight.frame = CGRect(x: redPlayer.frame.midX - 2, y: 0, width: 4, height: view.frame.height)
        view.addSubview(reviveLight)
        
        UIView.animate(withDuration: 0.3, animations: {
            reviveLight.frame.size.width = 100
            reviveLight.frame.origin.x = self.redPlayer.frame.midX - 50
            reviveLight.alpha = 0.5
        }) { _ in
            let leftWing = UIView()
            leftWing.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            leftWing.layer.cornerRadius = 20
            leftWing.frame = CGRect(
                x: self.redPlayer.frame.minX - 40,
                y: self.redPlayer.frame.midY - 40,
                width: 40,
                height: 80
            )
            self.view.addSubview(leftWing)
            
            let rightWing = UIView()
            rightWing.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            rightWing.layer.cornerRadius = 20
            rightWing.frame = CGRect(
                x: self.redPlayer.frame.maxX,
                y: self.redPlayer.frame.midY - 40,
                width: 40,
                height: 80
            )
            self.view.addSubview(rightWing)
            
            UIView.animate(withDuration: 0.5, animations: {
                leftWing.transform = CGAffineTransform(rotationAngle: -.pi / 6)
                rightWing.transform = CGAffineTransform(rotationAngle: .pi / 6)
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    leftWing.alpha = 0
                    rightWing.alpha = 0
                    reviveLight.alpha = 0
                }) { _ in
                    leftWing.removeFromSuperview()
                    rightWing.removeFromSuperview()
                    reviveLight.removeFromSuperview()
                    
                    self.redHealth = 1.0
                    self.updateHealthBars()
                }
            }
        }
    }
}