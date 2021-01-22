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
        
        componentNode.run(repeatAction, withKey: Names.spawnMonster.rawValue)
    }
    
    func stopGenerator() {
        isRunning = false
        componentNode.removeAction(forKey: Names.spawnMonster.rawValue)
    }
    
    func spawnMonsterEntity() {
        let monsterEntity = MonsterEntity(monsterType: monsterType)
        let renderComponent = RenderComponent(imageNamed: "\(monsterType)_0", scale: 0.65)
        monsterEntity.addComponent(renderComponent)
        
        if let monsterNode = monsterEntity.component(ofType: RenderComponent.self)?.spriteNode {
            monsterNode.position = componentNode.position
            componentNode.parent?.addChild(monsterNode)
            
            let randomPositions: [CGFloat] = [-50,-50,50]
            let randomX = randomPositions.randomElement() ?? 0
            monsterNode.run(SKAction.moveBy(x: randomX, y: 0, duration: 1.0))
            
            let healthComponent = HealthComponent()
            healthComponent.currentHealth = monsterHealth
            monsterEntity.addComponent(healthComponent)
            
            monsterEntity.addComponent(AgentComponent())
            
            let physicsComponent = PhysicsComponent()
            physicsComponent.bodyCategory = PhysicsCategory.monster.rawValue
            monsterEntity.addComponent(physicsComponent)
            
            if let scene = componentNode.scene as? GameScene {
                scene.entities.append(monsterEntity)
            }
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
