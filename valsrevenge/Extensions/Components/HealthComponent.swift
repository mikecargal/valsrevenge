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
    
    private let healthFull = SKTexture(imageNamed: "health_full")
    private let healthEmpty = SKTexture(imageNamed: "health_empty")
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node else {
            return
        }
        
        if let healthMeter = SKReferenceNode(fileNamed: "HealthMeter") {
            healthMeter.position = CGPoint(x: 0, y: 100)
            node.addChild(healthMeter)
            updateHealth(0, forNode: node)
        }
    }
    
    func updateHealth(_ value:Int, forNode node: SKNode?) {
        currentHealth += min(value,maxHealth)
        
        if let _ = node as? Player {
            for barNum in 1...maxHealth {
                setupBar(at: barNum,tint: .cyan)
            }
        } else {
            for barNum in 1...maxHealth {
                setupBar(at: barNum)
            }
        }
    }
    
    func setupBar(at num: Int, tint: SKColor? = nil) {
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        
        if let health = node.childNode(withName: ".//health_\(num)") as? SKSpriteNode {
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

    override func willRemoveFromEntity() {}
    
    override func update(deltaTime seconds: TimeInterval) {}
    
    override class var supportsSecureCoding: Bool {
        true
    }
}
