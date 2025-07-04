//
//  ActionPanel.swift
//  KingsPK
//
//  Created by YuankaiZhu on 7/3/25.
//

import SwiftUI
import Foundation

// MARK: - Skill Models
struct Skill {
    let id: String
    let name: String
    let icon: String
    let cooldown: TimeInterval
    let energyCost: Int
}

enum SkillType {
    case attack
    case defense
    case recovery
}

// MARK: - Notification Names
extension Notification.Name {
    static let skillTriggered = Notification.Name("skillTriggered")
}

// MARK: - Skill Data
struct SkillData {
    static let attackSkills = [
        Skill(id: "fireball", name: "Fireball", icon: "flame.fill", cooldown: 3.0, energyCost: 20),
        Skill(id: "lightning", name: "Lightning", icon: "bolt.fill", cooldown: 2.5, energyCost: 15),
        Skill(id: "ice_spike", name: "Ice Spike", icon: "snowflake", cooldown: 2.0, energyCost: 12),
        Skill(id: "shadow_strike", name: "Shadow Strike", icon: "moon.fill", cooldown: 4.0, energyCost: 25),
        Skill(id: "earth_quake", name: "Earth Quake", icon: "globe", cooldown: 5.0, energyCost: 30),
        Skill(id: "wind_slash", name: "Wind Slash", icon: "wind", cooldown: 1.5, energyCost: 10),
        Skill(id: "poison_dart", name: "Poison Dart", icon: "drop.fill", cooldown: 3.5, energyCost: 18),
        Skill(id: "holy_smite", name: "Holy Smite", icon: "sun.max.fill", cooldown: 6.0, energyCost: 35),
        Skill(id: "dark_void", name: "Dark Void", icon: "circle.fill", cooldown: 7.0, energyCost: 40),
        Skill(id: "meteor", name: "Meteor", icon: "star.fill", cooldown: 8.0, energyCost: 45)
    ]
    
    static let defenseSkills = [
        Skill(id: "shield", name: "Shield", icon: "shield.fill", cooldown: 4.0, energyCost: 20),
        Skill(id: "barrier", name: "Barrier", icon: "rectangle.fill", cooldown: 5.0, energyCost: 25),
        Skill(id: "dodge", name: "Dodge", icon: "figure.run", cooldown: 2.0, energyCost: 15),
        Skill(id: "reflect", name: "Reflect", icon: "arrow.triangle.2.circlepath", cooldown: 6.0, energyCost: 30),
        Skill(id: "immunity", name: "Immunity", icon: "heart.fill", cooldown: 10.0, energyCost: 40)
    ]
    
    static let recoverySkills = [
        Skill(id: "heal", name: "Heal", icon: "plus.circle.fill", cooldown: 3.0, energyCost: 15),
        Skill(id: "regeneration", name: "Regeneration", icon: "arrow.clockwise.circle.fill", cooldown: 8.0, energyCost: 25),
        Skill(id: "energy_boost", name: "Energy Boost", icon: "bolt.circle.fill", cooldown: 5.0, energyCost: 10),
        Skill(id: "cleanse", name: "Cleanse", icon: "sparkles", cooldown: 4.0, energyCost: 20),
        Skill(id: "revive", name: "Revive", icon: "heart.circle.fill", cooldown: 15.0, energyCost: 50)
    ]
}

// MARK: - Character Stats
class CharacterStats: ObservableObject {
    @Published var health: Int = 100
    @Published var energy: Int = 100
    @Published var maxHealth: Int = 100
    @Published var maxEnergy: Int = 100
    
    var healthPercentage: Double {
        Double(health) / Double(maxHealth)
    }
    
    var energyPercentage: Double {
        Double(energy) / Double(maxEnergy)
    }
}

// MARK: - Skill Button Component
struct SkillButton: View {
    let skill: Skill
    let skillType: SkillType
    @State private var isOnCooldown = false
    @State private var cooldownProgress: Double = 0
    @ObservedObject var characterStats: CharacterStats
    
    var canUseSkill: Bool {
        !isOnCooldown && characterStats.energy >= skill.energyCost
    }
    
    var body: some View {
        Button(action: {
            triggerSkill()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
                
                if isOnCooldown {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.6))
                }
                
                VStack(spacing: 4) {
                    Image(systemName: skill.icon)
                        .font(.system(size: 24))
                        .foregroundColor(canUseSkill ? .white : .gray)
                    
                    Text(skill.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(canUseSkill ? .white : .gray)
                        .multilineTextAlignment(.center)
                    
                    Text("\(skill.energyCost)")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
                
                if isOnCooldown {
                    Circle()
                        .trim(from: 0, to: cooldownProgress)
                        .stroke(Color.yellow, lineWidth: 3)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: cooldownProgress)
                }
            }
        }
        .disabled(!canUseSkill)
        .frame(width: 80, height: 80)
    }
    
    private var backgroundGradient: LinearGradient {
        switch skillType {
        case .attack:
            return LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .defense:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .recovery:
            return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private var borderColor: Color {
        canUseSkill ? .white : .gray
    }
    
    private func triggerSkill() {
        guard canUseSkill else { return }
        
        // Send notification with skill data
        let userInfo: [String: Any] = [
            "skillId": skill.id,
            "skillName": skill.name,
            "skillType": skillType,
            "energyCost": skill.energyCost
        ]
        
        NotificationCenter.default.post(
            name: .skillTriggered,
            object: nil,
            userInfo: userInfo
        )
        
        // Update character stats
        characterStats.energy = max(0, characterStats.energy - skill.energyCost)
        
        // Start cooldown
        startCooldown()
    }
    
    private func startCooldown() {
        isOnCooldown = true
        cooldownProgress = 0
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            cooldownProgress += 0.1 / skill.cooldown
            
            if cooldownProgress >= 1.0 {
                isOnCooldown = false
                cooldownProgress = 0
                timer.invalidate()
            }
        }
    }
}

// MARK: - Stats Display
struct StatsDisplay: View {
    @ObservedObject var characterStats: CharacterStats
    
    var body: some View {
        VStack(spacing: 12) {
            // Health Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("Health")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(characterStats.health)/\(characterStats.maxHealth)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                ProgressView(value: characterStats.healthPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .frame(height: 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
            }
            
            // Energy Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.blue)
                    Text("Energy")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(characterStats.energy)/\(characterStats.maxEnergy)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                ProgressView(value: characterStats.energyPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
}

// MARK: - Skills Section
struct SkillsSection: View {
    let title: String
    let skills: [Skill]
    let skillType: SkillType
    @ObservedObject var characterStats: CharacterStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(skills, id: \.id) { skill in
                    SkillButton(skill: skill, skillType: skillType, characterStats: characterStats)
                }
            }
        }
    }
}

// MARK: - Main Control Panel
struct PKControlPanel: View {
    @StateObject private var characterStats = CharacterStats()
    @State private var selectedPlayer = 1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [.black, .gray.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Attack Skills
                        SkillsSection(
                            title: "🗡️ Attack Skills",
                            skills: SkillData.attackSkills,
                            skillType: .attack,
                            characterStats: characterStats
                        )
                        .padding(.horizontal)
                        
                        // Defense Skills
                        SkillsSection(
                            title: "🛡️ Defense Skills",
                            skills: SkillData.defenseSkills,
                            skillType: .defense,
                            characterStats: characterStats
                        )
                        .padding(.horizontal)
                        
                        // Recovery Skills
                        SkillsSection(
                            title: "💚 Recovery Skills",
                            skills: SkillData.recoverySkills,
                            skillType: .recovery,
                            characterStats: characterStats
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear {
            setupNotificationObserver()
        }
    }
    
    private func resetCharacterStats() {
        characterStats.health = characterStats.maxHealth
        characterStats.energy = characterStats.maxEnergy
    }
    
    private func setupNotificationObserver() {
        // This is where other developers can listen for skill notifications
        NotificationCenter.default.addObserver(
            forName: .skillTriggered,
            object: nil,
            queue: .main
        ) { notification in
            if let userInfo = notification.userInfo {
                print("Skill triggered: \(userInfo)")
                // Other developers can implement their character animations here
            }
        }
    }
}

// MARK: - Preview
struct PKControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        PKControlPanel()
    }
}
