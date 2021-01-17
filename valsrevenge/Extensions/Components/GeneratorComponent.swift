//
//  GeneratorComponent.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

class GeneratorComponent: GKComponent {
    @GKInspectable var monsterType: String = "skeleton"
    @GKInspectable var maxMonsters: Int = 10
    
    @GKInspectable var waitTime: TimeInterval = 5
    @GKInspectable var monsterHealth: Int = 3
    
    override func didAddToEntity() {
        let sequence = SKAction.sequence([
            SKAction.wait(forDuration: waitTime),
            SKAction.run { [unowned self] in self.spawnMonsterEntity() }
        ])
        
        let repeatAction = maxMonsters == 0 ?
            SKAction.repeatForever(sequence) :
            SKAction.repeat(sequence, count: maxMonsters)
        
        componentNode.run(repeatAction, withKey: "spawnMonster")
    }
    
    func spawnMonsterEntity() {
        let monsterEntity = MonsterEntity(monsterType: monsterType)
        let renderComponent = RenderComponent(imageNamed: "\(monsterType)_0", scale: 0.65)
        monsterEntity.addComponent(renderComponent)
        
        if let monsterNode = monsterEntity.component(ofType: RenderComponent.self)?.spriteNode {
            monsterNode.position = componentNode.position
            componentNode.parent?.addChild(monsterNode)
            
            monsterNode.run(SKAction.moveBy(x: 100, y: 0, duration: 1.0))
            
            let healthComponent = HealthComponent()
            healthComponent.currentHealth = monsterHealth
            monsterEntity.addComponent(healthComponent)
        }
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
}
