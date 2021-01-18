//
//  GeneratorComponent.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

class GeneratorComponent: GKComponent {
    @GKInspectable var monsterType: String = GameObject.defaultGeneratorType
    @GKInspectable var maxMonsters: Int = 10
    
    @GKInspectable var waitTime: TimeInterval = 5
    @GKInspectable var monsterHealth: Int = 3
    
    var isRunning = false
    
    let spawnActionName = "spawnMonster"
    
    override func didAddToEntity() {}
    
    func startGenerator() {
        isRunning = true
        
        let sequence = SKAction.sequence([
            SKAction.wait(forDuration: waitTime),
            SKAction.run { [unowned self] in self.spawnMonsterEntity() }
        ])
        
        let repeatAction = maxMonsters == 0 ?
            SKAction.repeatForever(sequence) :
            SKAction.repeat(sequence, count: maxMonsters)
        
        componentNode.run(repeatAction, withKey: spawnActionName)
    }
    
    func stopGenerator() {
        isRunning = false
        componentNode.removeAction(forKey: spawnActionName)
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
    
    override func update(deltaTime seconds: TimeInterval) {
        if let scene = componentNode.scene as? GameScene {
            switch scene.mainGameStateMachine.currentState {
            case is PauseState:
                if isRunning { stopGenerator() }
            case is PlayingState:
                if !isRunning { startGenerator() }
            default:
                break
            }
        }
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
}
