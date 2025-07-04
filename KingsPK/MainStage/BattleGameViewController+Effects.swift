import UIKit

// MARK: - Common Visual Effects
extension BattleGameViewController {
    
    // MARK: - Collision Effect
    func createCollisionEffect(color: UIColor = .systemYellow) {
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
        
        UIView.animate(withDuration: 0.3, animations: {
            collisionEffect.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            collisionEffect.alpha = 0
        }) { _ in
            collisionEffect.removeFromSuperview()
        }
        
        createShakeEffect(for: bluePlayer)
    }
    
    // MARK: - Shake Effect
    func createShakeEffect(for view: UIView) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 3
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))
        view.layer.add(shake, forKey: "shake")
    }
    
    // MARK: - Fire Explosion
    func createFireExplosion() {
        let explosionView = UIView()
        explosionView.frame = CGRect(
            x: bluePlayer.frame.midX - 60,
            y: bluePlayer.frame.midY - 60,
            width: 120,
            height: 120
        )
        view.addSubview(explosionView)
        
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
        
        createShakeEffect(for: bluePlayer)
    }
    
    // MARK: - Electric Shock
    func createElectricShock() {
        let shockView = UIView()
        shockView.frame = bluePlayer.frame
        shockView.layer.cornerRadius = shockView.frame.width / 2
        shockView.layer.borderWidth = 3
        shockView.layer.borderColor = UIColor.systemBlue.cgColor
        shockView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        view.addSubview(shockView)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33) {
                shockView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33) {
                shockView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.34) {
                shockView.backgroundColor = UIColor.cyan.withAlphaComponent(0.8)
            }
        } completion: { _ in
            shockView.removeFromSuperview()
        }
        
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
        
        createShakeEffect(for: bluePlayer)
    }
    
    // MARK: - Ice Shatter
    func createIceShatterEffect() {
        for i in 0..<12 {
            let shard = UIView()
            shard.backgroundColor = .systemCyan
            shard.layer.cornerRadius = 2
            shard.frame = CGRect(
                x: bluePlayer.frame.midX - 2,
                y: bluePlayer.frame.midY - 2,
                width: 4,
                height: 8
            )
            view.addSubview(shard)
            
            let angle = CGFloat(i) * (.pi * 2 / 12)
            let distance = CGFloat.random(in: 30...60)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                shard.center = CGPoint(
                    x: self.bluePlayer.frame.midX + cos(angle) * distance,
                    y: self.bluePlayer.frame.midY + sin(angle) * distance
                )
                shard.transform = CGAffineTransform(rotationAngle: angle)
                shard.alpha = 0
            }) { _ in
                shard.removeFromSuperview()
            }
        }
        createShakeEffect(for: bluePlayer)
    }
    
    // MARK: - Wind Effect
    func createWindEffect() {
        for i in 0..<5 {
            let windLine = UIView()
            windLine.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
            windLine.frame = CGRect(
                x: 0,
                y: bluePlayer.frame.midY - 20 + CGFloat(i) * 10,
                width: view.frame.width,
                height: 2
            )
            view.addSubview(windLine)
            
            UIView.animate(withDuration: 0.3, delay: Double(i) * 0.05, options: .curveEaseOut, animations: {
                windLine.frame.origin.x = self.view.frame.width
                windLine.alpha = 0
            }) { _ in
                windLine.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Poison Effect
    func createPoisonEffect() {
        let poisonCloud = UIView()
        poisonCloud.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        poisonCloud.layer.cornerRadius = 40
        poisonCloud.frame = CGRect(
            x: bluePlayer.frame.midX - 40,
            y: bluePlayer.frame.midY - 40,
            width: 80,
            height: 80
        )
        view.addSubview(poisonCloud)
        
        UIView.animate(withDuration: 0.5, animations: {
            poisonCloud.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 1.0, animations: {
                poisonCloud.alpha = 0
            }) { _ in
                poisonCloud.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Holy Explosion
    func createHolyExplosion() {
        let holyBurst = UIView()
        holyBurst.backgroundColor = .systemYellow
        holyBurst.layer.cornerRadius = 50
        holyBurst.frame = CGRect(
            x: bluePlayer.frame.midX - 50,
            y: bluePlayer.frame.midY - 50,
            width: 100,
            height: 100
        )
        view.addSubview(holyBurst)
        
        UIView.animate(withDuration: 0.3, animations: {
            holyBurst.transform = CGAffineTransform(scaleX: 2, y: 2)
            holyBurst.alpha = 0
        }) { _ in
            holyBurst.removeFromSuperview()
        }
    }
    
    // MARK: - Meteor Impact
    func createMeteorImpact() {
        let impactCrater = UIView()
        impactCrater.backgroundColor = UIColor.systemBrown.withAlphaComponent(0.8)
        impactCrater.layer.cornerRadius = 40
        impactCrater.frame = CGRect(
            x: bluePlayer.frame.midX - 40,
            y: bluePlayer.frame.midY - 40,
            width: 80,
            height: 80
        )
        view.addSubview(impactCrater)
        
        for i in 0..<16 {
            let debris = UIView()
            debris.backgroundColor = .systemOrange
            debris.layer.cornerRadius = 3
            debris.frame = CGRect(
                x: bluePlayer.frame.midX - 3,
                y: bluePlayer.frame.midY - 3,
                width: 6,
                height: 6
            )
            view.addSubview(debris)
            
            let angle = CGFloat(i) * (.pi * 2 / 16)
            let distance = CGFloat.random(in: 40...80)
            
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                debris.center = CGPoint(
                    x: self.bluePlayer.frame.midX + cos(angle) * distance,
                    y: self.bluePlayer.frame.midY + sin(angle) * distance
                )
                debris.alpha = 0
            }) { _ in
                debris.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            impactCrater.alpha = 0
        }) { _ in
            impactCrater.removeFromSuperview()
        }
        
        createShakeEffect(for: view)
    }
}