import UIKit

// MARK: - Defense Skill Animations
extension BattleGameViewController {
    
    func performShieldDefense() {
        let shield = UIView()
        shield.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        shield.layer.borderColor = UIColor.systemBlue.cgColor
        shield.layer.borderWidth = 3
        shield.layer.cornerRadius = playerSize / 2 + 20
        shield.frame = CGRect(
            x: redPlayer.frame.midX - playerSize / 2 - 20,
            y: redPlayer.frame.midY - playerSize / 2 - 20,
            width: playerSize + 40,
            height: playerSize + 40
        )
        view.addSubview(shield)
        
        let shimmer = UIView()
        shimmer.backgroundColor = .white
        shimmer.alpha = 0.5
        shimmer.frame = CGRect(x: 0, y: 0, width: 10, height: shield.frame.height)
        shield.addSubview(shimmer)
        
        UIView.animate(withDuration: 0.5, animations: {
            shield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
                shimmer.frame.origin.x = shield.frame.width - 10
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    shield.alpha = 0
                }) { _ in
                    shield.removeFromSuperview()
                }
            }
        }
    }
    
    func performBarrierDefense() {
        let barrier = UIView()
        barrier.backgroundColor = UIColor.systemCyan.withAlphaComponent(0.2)
        barrier.layer.borderColor = UIColor.systemCyan.cgColor
        barrier.layer.borderWidth = 2
        barrier.frame = CGRect(
            x: 20,
            y: redPlayer.frame.midY - 100,
            width: view.frame.width - 40,
            height: 200
        )
        view.addSubview(barrier)
        
        for i in 0..<3 {
            let wave = UIView()
            wave.backgroundColor = UIColor.systemCyan.withAlphaComponent(0.3)
            wave.frame = CGRect(x: 0, y: CGFloat(i) * 60 + 20, width: barrier.frame.width, height: 2)
            barrier.addSubview(wave)
            
            UIView.animate(withDuration: 1.0, delay: Double(i) * 0.2, options: [.repeat], animations: {
                wave.frame.origin.y += 180
            })
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            barrier.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    barrier.alpha = 0
                }) { _ in
                    barrier.removeFromSuperview()
                }
            }
        }
    }
    
    func performDodgeDefense() {
        let afterImage = UIView()
        afterImage.backgroundColor = redPlayer.backgroundColor
        afterImage.alpha = 0.5
        afterImage.layer.cornerRadius = playerSize / 2
        afterImage.frame = redPlayer.frame
        view.insertSubview(afterImage, belowSubview: redPlayer)
        
        let originalPosition = redPlayer.center
        
        UIView.animate(withDuration: 0.2, animations: {
            self.redPlayer.center.x += 100
            self.redPlayer.alpha = 0.3
            afterImage.alpha = 0.2
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.redPlayer.center = originalPosition
                self.redPlayer.alpha = 1.0
                afterImage.alpha = 0
            }) { _ in
                afterImage.removeFromSuperview()
            }
        }
        
        for i in 0..<5 {
            let speedLine = UIView()
            speedLine.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            speedLine.frame = CGRect(
                x: redPlayer.frame.midX,
                y: redPlayer.frame.midY - 40 + CGFloat(i) * 20,
                width: 80,
                height: 1
            )
            view.addSubview(speedLine)
            
            UIView.animate(withDuration: 0.3, animations: {
                speedLine.frame.origin.x -= 100
                speedLine.alpha = 0
            }) { _ in
                speedLine.removeFromSuperview()
            }
        }
    }
    
    func performReflectDefense() {
        let reflectShield = UIView()
        reflectShield.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
        reflectShield.layer.borderColor = UIColor.systemPurple.cgColor
        reflectShield.layer.borderWidth = 3
        reflectShield.layer.cornerRadius = playerSize / 2 + 30
        reflectShield.frame = CGRect(
            x: redPlayer.frame.midX - playerSize / 2 - 30,
            y: redPlayer.frame.midY - playerSize / 2 - 30,
            width: playerSize + 60,
            height: playerSize + 60
        )
        view.addSubview(reflectShield)
        
        let mirrorLayer = CAGradientLayer()
        mirrorLayer.frame = reflectShield.bounds
        mirrorLayer.colors = [
            UIColor.systemPurple.withAlphaComponent(0.0).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.3).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.0).cgColor
        ]
        mirrorLayer.locations = [0, 0.5, 1]
        mirrorLayer.startPoint = CGPoint(x: 0, y: 0.5)
        mirrorLayer.endPoint = CGPoint(x: 1, y: 0.5)
        reflectShield.layer.addSublayer(mirrorLayer)
        
        UIView.animate(withDuration: 3.0, delay: 0, options: [.repeat], animations: {
            reflectShield.transform = CGAffineTransform(rotationAngle: .pi * 2)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 0.5, animations: {
                reflectShield.alpha = 0
            }) { _ in
                reflectShield.removeFromSuperview()
            }
        }
    }
    
    func performImmunityDefense() {
        let immunityAura = UIView()
        immunityAura.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        immunityAura.layer.borderColor = UIColor.systemYellow.cgColor
        immunityAura.layer.borderWidth = 2
        immunityAura.layer.cornerRadius = playerSize / 2 + 40
        immunityAura.frame = CGRect(
            x: redPlayer.frame.midX - playerSize / 2 - 40,
            y: redPlayer.frame.midY - playerSize / 2 - 40,
            width: playerSize + 80,
            height: playerSize + 80
        )
        view.addSubview(immunityAura)
        
        for i in 0..<12 {
            let particle = UIView()
            particle.backgroundColor = .systemYellow
            particle.layer.cornerRadius = 3
            particle.frame = CGRect(
                x: immunityAura.frame.width / 2 - 3,
                y: immunityAura.frame.height / 2 - 3,
                width: 6,
                height: 6
            )
            immunityAura.addSubview(particle)
            
            let angle = CGFloat(i) * (.pi * 2 / 12)
            let radius: CGFloat = 40
            
            UIView.animate(withDuration: 2.0, delay: Double(i) * 0.1, options: [.repeat], animations: {
                particle.center = CGPoint(
                    x: immunityAura.frame.width / 2 + cos(angle) * radius,
                    y: immunityAura.frame.height / 2 + sin(angle) * radius
                )
            })
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            immunityAura.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            UIView.animate(withDuration: 0.5, animations: {
                immunityAura.alpha = 0
            }) { _ in
                immunityAura.removeFromSuperview()
            }
        }
    }
}