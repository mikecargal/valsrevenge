//
//  GameScene.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/14/21.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    
    let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    
    private var player: Player?
    
    let margin: CGFloat = 20.0
    
    let mainGameStateMachine = GKStateMachine(
        states: [
            PauseState(),
            PlayingState()
        ])
    
    private var lastUpdateTime: TimeInterval = 0

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.mainGameStateMachine.enter(PauseState.self)
        
        self.setupPlayer()
        self.setupCamera()
        
        let grassMapNode = childNode(withName: "Grass Tile Map") as? SKTileMapNode
        grassMapNode?.setupEdgeLoop()
        
        let dungeonMapNode = childNode(withName: "Dungeon Tile Map") as? SKTileMapNode
        dungeonMapNode?.setupMapPhysics()
        physicsWorld.contactDelegate = self
        self.startAdvancedNavigation()
    }

    func setupCamera() {
        guard let player = player else { return }
        let distance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(distance, to: player)
        camera?.constraints = [playerConstraint]
    }
    
    func setupPlayer() {
        self.player = childNode(withName: "player") as? Player
        if let player = player {
            player.move(.stop)
            self.agentComponentSystem.addComponent(player.agent)
        }
    }
     
    func touchDown(atPoint pos: CGPoint) {
        self.mainGameStateMachine.enter(PlayingState.self)
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                self.player?.move(Direction(rawValue: direction ?? "stop")!)
            } else if touchedNode.name == "button_attack" {
                self.player?.attack()
            }
        }
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                self.player?.move(Direction(rawValue: direction ?? "stop")!)
            }
        }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                self.player?.stop()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // update the component system
        self.agentComponentSystem.update(deltaTime: dt)
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    override func didFinishUpdate() {
        self.updateControllerLocation()
    }
    
    func updateControllerLocation() {
        let controller = childNode(withName: "//controller")
        controller?.position = CGPoint(
            x: viewLeft +
                self.margin +
                insets.left,
            y: viewBottom +
                self.margin +
                insets.bottom)
        let attackButton = childNode(withName: "//attackButton")
        attackButton?.position = CGPoint(
            x: viewRight -
                self.margin -
                insets.right,
            y: viewBottom +
                self.margin +
                insets.bottom)
    }
    
    func startAdvancedNavigation() {
        // check for a navigation graph and a key
        guard let sceneGraph = graphs.values.first,
              let keyNode = childNode(withName: "key") as? SKSpriteNode
        else { return }
        
        let agent = GKAgent2D()
        
        agent.delegate = keyNode
        agent.position = vector_float2(Float(keyNode.position.x),
                                       Float(keyNode.position.y))
        
        // set up the agent's properties
        agent.mass = 1
        agent.speed = 50
        agent.maxSpeed = 100
        agent.maxAcceleration = 100
        agent.radius = 60
        
        // Find obstacles (generators)
        var obstacles = [GKCircleObstacle]()
        enumerateChildNodes(withName: "generator_*") {
            node, _ in
            
            // create compoatible obstacle
            let circle = GKCircleObstacle(radius: Float(node.frame.size.width / 2))
            circle.position = vector_float2(Float(node.position.x),
                                            Float(node.position.y))
            obstacles.append(circle)
        }
        if let nodesOnPath = sceneGraph.nodes as? [GKGraphNode2D] {
            // show the path (optional code)
//            for (index, node) in nodesOnPath.enumerated() {
//                let shapeNode = SKShapeNode(circleOfRadius: 10)
//                shapeNode.fillColor = .green
//                shapeNode.position = CGPoint(x: CGFloat(node.position.x),
//                                             y: CGFloat(node.position.y))
//                // add node number
//                let number = SKLabelNode(text: "\(index)")
//                number.position.y = 15
//                addChild(shapeNode)
//            }
            // end optional code
            
            // create a path to follow
            let path = GKPath(graphNodes: nodesOnPath, radius: 0)
            path.isCyclical = true
            
            // set up the goals
            agent.behavior = GKBehavior(goals: [
                GKGoal(toFollow: path,
                       maxPredictionTime: 1.0,
                       forward: true),
                GKGoal(toAvoid: obstacles,
                       maxPredictionTime: 1.0)
            ], andWeights: [0.5, 100])
            
            agentComponentSystem.addComponent(agent)
        }
    }
}
