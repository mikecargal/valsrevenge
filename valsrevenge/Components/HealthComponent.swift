//
//  HealthComponent.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

class HealthComponent: GKComponent {
    @GKInspectable var currentHealth: Int = 3
    @GKInspectable var maxHealth: Int = 3
    
    private let healthFull = SKTexture(imageNamed: ImageNames.healthFull.rawValue)
    private let healthEmpty = SKTexture(imageNamed: ImageNames.healthEmpty.rawValue)
    
    private var hitAction = SKAction()
    private var dieAction = SKAction()
    
    override func didAddToEntity() {
        if let healthMeter = SKReferenceNode(fileNamed: FileNames.healthMeter.rawValue) {
            healthMeter.position = CGPoint(x: 0, y: 100)
            componentNode.addChild(healthMeter)
            updateHealth(0, forNode: componentNode)
            
            if let _ = componentNode as? Player {
                hitAction = SKAction.playSoundFileNamed(Sounds.playerHit.rawValue, waitForCompletion: false)
                dieAction = SKAction.run {
                    self.componentNode.run(SKAction.playSoundFileNamed(Sounds.playerDie.rawValue, waitForCompletion: false)) {
                        self.componentNode.scene?.loadGameOverScene()
                    }
                }
            } else {
                hitAction = SKAction.playSoundFileNamed(Sounds.monsterHit.rawValue, waitForCompletion: false)
                dieAction = SKAction.run {
                    self.componentNode.run(SKAction.playSoundFileNamed(Sounds.monsterDie.rawValue, waitForCompletion: false)) {
                        self.componentNode.removeFromParent()
                    }
                }
            }
        }
    }
    
    func updateHealth(_ value: Int, forNode node: SKNode?) {
        currentHealth = min(currentHealth + value, maxHealth)

        // run hit or die actions
        if value < 0 {
            componentNode.run(currentHealth == 0 ? dieAction : hitAction)
        }
        
        if let _ = node as? Player {
            for barNum in 1...maxHealth {
                setupBar(at: barNum, tint: .cyan)
            }
        } else {
            for barNum in 1...maxHealth {
                setupBar(at: barNum)
            }
        }
    }
    
    func setupBar(at num: Int, tint: SKColor? = nil) {
        if let health = componentNode.childNode(withName: ".//health_\(num)") as? SKSpriteNode {
            if currentHealth >= num {
                health.texture = healthFull
                if let tint = tint {
                    health.color = tint
                    health.colorBlendFactor = 1.0
                }
            } else {
                health.texture = healthEmpty
                health.colorBlendFactor = 0.0
            }
        }
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
}
