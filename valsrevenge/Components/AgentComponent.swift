//
//  AgentComponent.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/18/21.
//

import GameplayKit
import SpriteKit

class AgentComponent: GKComponent {
    let agent = GKAgent2D()
    
    lazy var interceptionGoal: GKGoal = {
        guard let scene = componentNode.scene as? GameScene,
              let player = scene.childNode(withName: "Player") as? Player
        else { return GKGoal(toWander: 1.0) }
        
        return GKGoal(toInterceptAgent: player.agent, maxPredictionTime: 1.0)
    }()
    
    override func didAddToEntity() {
        guard let scene = componentNode.scene as? GameScene
        else { return }
        
        // set up the goald and behaviors
        let wanderGoal = GKGoal(toWander: 1.0)
        agent.behavior = GKBehavior(goals: [wanderGoal, interceptionGoal], andWeights: [100, 0])
        
        agent.delegate = componentNode
        
        // constrain the agent's movement
        agent.mass = 1
        agent.maxAcceleration = 125
        agent.maxSpeed = 125
        agent.radius = 60
        agent.speed = 100
        
        scene.agentComponentSystem.addComponent(agent)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let scene = componentNode.scene as? GameScene,
              let player = scene.childNode(withName: "player") as? Player
        else { return }
        
        agent.behavior?.setWeight(
            player.stateMachine.currentState is PlayerHasKeyState ? 100 : 0,
            for: interceptionGoal)
    }

    override class var supportsSecureCoding: Bool {
        true
    }
}
