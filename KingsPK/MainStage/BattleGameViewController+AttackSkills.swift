import UIKit

// MARK: - Attack Skill Animations
extension BattleGameViewController {
    
    func performFireballAttack() {
        let fireballContainer = UIView()
        fireballContainer.frame = CGRect(
            x: redPlayer.frame.midX - 30,
            y: redPlayer.frame.midY - 30,
            width: 60,
            height: 60
        )
        view.addSubview(fireballContainer)
        
        let fireball = UIView()
        fireball.backgroundColor = .systemOrange
        fireball.layer.cornerRadius = 25
        fireball.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        fireballContainer.addSubview(fireball)
        
        for i in 0..<12 {
            let particle = UIView()
            particle.backgroundColor = i % 2 == 0 ? .systemRed : .systemYellow
            particle.layer.cornerRadius = 4
            particle.frame = CGRect(x: 26, y: 26, width: 8, height: 8)
            fireballContainer.addSubview(particle)
            
            let angle = CGFloat(i) * (.pi * 2 / 12)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
                particle.center = CGPoint(
                    x: 30 + cos(angle) * 20,
                    y: 30 + sin(angle) * 20
                )
            })
        }
        
        UIView.animate(withDuration: 0.8, animations: {
            fireballContainer.center = self.bluePlayer.center
            fireballContainer.transform = CGAffineTransform(rotationAngle: .pi * 4)
        }) { _ in
            self.createFireExplosion()
            fireballContainer.removeFromSuperview()
        }
    }
    
    func performLightningAttack() {
        let lightningPath = UIBezierPath()
        let startPoint = CGPoint(x: redPlayer.frame.midX, y: redPlayer.frame.midY)
        let endPoint = CGPoint(x: bluePlayer.frame.midX, y: bluePlayer.frame.midY)
        
        lightningPath.move(to: startPoint)
        
        let segments = 8
        for i in 1..<segments {
            let progress = CGFloat(i) / CGFloat(segments)
            let x = startPoint.x + (endPoint.x - startPoint.x) * progress
            let y = startPoint.y + (endPoint.y - startPoint.y) * progress
            let offset = (i % 2 == 0 ? 20 : -20) * sin(progress * .pi * 2)
            lightningPath.addLine(to: CGPoint(x: x, y: y + offset))
        }
        lightningPath.addLine(to: endPoint)
        
        let lightningLayer = CAShapeLayer()
        lightningLayer.path = lightningPath.cgPath
        lightningLayer.strokeColor = UIColor.systemBlue.cgColor
        lightningLayer.lineWidth = 4
        lightningLayer.fillColor = UIColor.clear.cgColor
        lightningLayer.shadowColor = UIColor.cyan.cgColor
        lightningLayer.shadowOpacity = 0.8
        lightningLayer.shadowRadius = 4
        
        view.layer.addSublayer(lightningLayer)
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.createElectricShock()
            lightningLayer.removeFromSuperlayer()
        }
    }
    
    func performIceSpikeAttack() {
        let iceSpike = UIView()
        iceSpike.backgroundColor = .systemCyan
        iceSpike.layer.cornerRadius = 5
        iceSpike.frame = CGRect(x: redPlayer.frame.midX - 5, y: redPlayer.frame.midY - 30, width: 10, height: 60)
        view.addSubview(iceSpike)
        
        let frostEffect = UIView()
        frostEffect.backgroundColor = .white
        frostEffect.alpha = 0.7
        frostEffect.layer.cornerRadius = 3
        frostEffect.frame = CGRect(x: 1, y: 5, width: 8, height: 50)
        iceSpike.addSubview(frostEffect)
        
        UIView.animate(withDuration: 0.6, animations: {
            iceSpike.center = self.bluePlayer.center
            iceSpike.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }) { _ in
            self.createIceShatterEffect()
            iceSpike.removeFromSuperview()
        }
    }
    
    func performShadowStrikeAttack() {
        let shadowClone = UIView()
        shadowClone.backgroundColor = .black
        shadowClone.alpha = 0.8
        shadowClone.layer.cornerRadius = playerSize / 2
        shadowClone.frame = redPlayer.frame
        view.addSubview(shadowClone)
        
        UIView.animate(withDuration: 0.3, animations: {
            shadowClone.center = self.bluePlayer.center
            shadowClone.alpha = 0.3
        }) { _ in
            let strikeEffect = UIView()
            strikeEffect.backgroundColor = .systemPurple
            strikeEffect.layer.cornerRadius = 40
            strikeEffect.frame = CGRect(
                x: self.bluePlayer.frame.midX - 40,
                y: self.bluePlayer.frame.midY - 40,
                width: 80,
                height: 80
            )
            self.view.addSubview(strikeEffect)
            
            UIView.animate(withDuration: 0.2, animations: {
                strikeEffect.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                strikeEffect.alpha = 0
            }) { _ in
                strikeEffect.removeFromSuperview()
            }
            
            shadowClone.removeFromSuperview()
            self.createShakeEffect(for: self.bluePlayer)
        }
    }
    
    func performEarthQuakeAttack() {
        let crackView = UIView()
        crackView.backgroundColor = .systemBrown
        crackView.frame = CGRect(
            x: 0,
            y: view.frame.height - 100,
            width: view.frame.width,
            height: 4
        )
        view.addSubview(crackView)
        
        for i in 0..<20 {
            let debris = UIView()
            debris.backgroundColor = .systemBrown
            debris.layer.cornerRadius = 3
            debris.frame = CGRect(
                x: CGFloat(i) * (view.frame.width / 20),
                y: view.frame.height - 100,
                width: 6,
                height: 6
            )
            view.addSubview(debris)
            
            UIView.animate(withDuration: 1.0, delay: Double(i) * 0.05, options: .curveEaseOut, animations: {
                debris.center.y -= CGFloat.random(in: 50...150)
                debris.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }) { _ in
                debris.removeFromSuperview()
            }
        }
        
        let originalCenter = view.center
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33) {
                self.view.center.x = originalCenter.x + 10
            }
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33) {
                self.view.center.x = originalCenter.x - 10
            }
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.34) {
                self.view.center = originalCenter
            }
        } completion: { _ in
            crackView.removeFromSuperview()
        }
    }
    
    func performWindSlashAttack() {
        let windSlash = UIView()
        windSlash.backgroundColor = .systemTeal
        windSlash.alpha = 0.7
        windSlash.layer.cornerRadius = 2
        windSlash.frame = CGRect(
            x: redPlayer.frame.midX - 2,
            y: redPlayer.frame.midY - 50,
            width: 4,
            height: 100
        )
        view.addSubview(windSlash)
        
        for i in 0..<8 {
            let particle = UIView()
            particle.backgroundColor = .systemTeal
            particle.alpha = 0.6
            particle.layer.cornerRadius = 2
            particle.frame = CGRect(x: 0, y: CGFloat(i) * 12, width: 4, height: 4)
            windSlash.addSubview(particle)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            windSlash.center.x = self.bluePlayer.center.x
            windSlash.transform = CGAffineTransform(rotationAngle: .pi / 4)
        }) { _ in
            self.createWindEffect()
            windSlash.removeFromSuperview()
        }
    }
    
    func performPoisonDartAttack() {
        let dart = UIView()
        dart.backgroundColor = .systemGreen
        dart.layer.cornerRadius = 2
        dart.frame = CGRect(
            x: redPlayer.frame.midX - 2,
            y: redPlayer.frame.midY - 15,
            width: 4,
            height: 30
        )
        view.addSubview(dart)
        
        let poisonTip = UIView()
        poisonTip.backgroundColor = .systemPurple
        poisonTip.layer.cornerRadius = 2
        poisonTip.frame = CGRect(x: 0, y: 0, width: 4, height: 8)
        dart.addSubview(poisonTip)
        
        UIView.animate(withDuration: 0.5, animations: {
            dart.center = self.bluePlayer.center
        }) { _ in
            self.createPoisonEffect()
            dart.removeFromSuperview()
        }
    }
    
    func performHolySmiteAttack() {
        let lightBeam = UIView()
        lightBeam.backgroundColor = .systemYellow
        lightBeam.alpha = 0.8
        lightBeam.frame = CGRect(
            x: bluePlayer.frame.midX - 25,
            y: 0,
            width: 50,
            height: bluePlayer.frame.midY
        )
        view.addSubview(lightBeam)
        
        lightBeam.layer.shadowColor = UIColor.yellow.cgColor
        lightBeam.layer.shadowOpacity = 1.0
        lightBeam.layer.shadowRadius = 20
        
        UIView.animate(withDuration: 0.5, animations: {
            lightBeam.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                lightBeam.alpha = 0
            }) { _ in
                lightBeam.removeFromSuperview()
                self.createHolyExplosion()
            }
        }
    }
    
    func performDarkVoidAttack() {
        let voidEffect = UIView()
        voidEffect.backgroundColor = .black
        voidEffect.layer.cornerRadius = 20
        voidEffect.frame = CGRect(
            x: bluePlayer.frame.midX - 20,
            y: bluePlayer.frame.midY - 20,
            width: 40,
            height: 40
        )
        view.addSubview(voidEffect)
        
        UIView.animate(withDuration: 0.8, animations: {
            voidEffect.transform = CGAffineTransform(scaleX: 3, y: 3)
            voidEffect.alpha = 0.3
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                voidEffect.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                voidEffect.alpha = 0
            }) { _ in
                voidEffect.removeFromSuperview()
            }
        }
    }
    
    func performMeteorAttack() {
        let meteor = UIView()
        meteor.backgroundColor = .systemRed
        meteor.layer.cornerRadius = 20
        meteor.frame = CGRect(x: view.frame.width + 40, y: -40, width: 40, height: 40)
        view.addSubview(meteor)
        
        let trail = UIView()
        trail.backgroundColor = .systemOrange
        trail.alpha = 0.7
        trail.layer.cornerRadius = 10
        trail.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        meteor.addSubview(trail)
        
        UIView.animate(withDuration: 1.0, animations: {
            meteor.center = self.bluePlayer.center
            meteor.transform = CGAffineTransform(rotationAngle: .pi * 3)
        }) { _ in
            self.createMeteorImpact()
            meteor.removeFromSuperview()
        }
    }
}