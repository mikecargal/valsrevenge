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
    
    private var leftTouch: UITouch?
    private var rightTouch: UITouch?
    
    lazy var controllerMovement: Controller? = {
        guard let player = player
        else { return nil }
        
        let stickImage = SKSpriteNode(imageNamed: "player-val-head_0")
        stickImage.setScale(0.75)
        let controller = Controller(stickImage: stickImage,
                                    attachedNode: player,
                                    nodeSpeed: player.movementSpeed,
                                    isMovement: true,
                                    range: 55.0,
                                    color: .darkGray)
        controller.setScale(0.65)
        controller.zPosition += 1
        controller.anchorLeft()
        controller.hideLargeArrows()
        controller.hideSmallArrows()
        
        return controller
    }()

    lazy var controllerAttack: Controller? = {
        guard let player = player
        else { return nil }
        
        let stickImage = SKSpriteNode(imageNamed: "controller_attack")
        stickImage.setScale(0.75)
        let controller = Controller(stickImage: stickImage,
                                    attachedNode: player,
                                    nodeSpeed: player.projectileSpeed,
                                    isMovement: false,
                                    range: 55.0,
                                    color: .gray)
        controller.setScale(0.65)
        controller.zPosition += 1
        controller.anchorRight()
        controller.hideLargeArrows()
        controller.hideSmallArrows()
        
        return controller
    }()

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
            player.setupHUD(scene: self)
            self.agentComponentSystem.addComponent(player.agent)
        }
        if let controllerMovement = controllerMovement {
            addChild(controllerMovement)
        }
        if let controllerAttack = controllerAttack {
            addChild(controllerAttack)
        }
    }
     
    func touchDown(atPoint pos: CGPoint, touch: UITouch) {
        mainGameStateMachine.enter(PlayingState.self)
        
        let nodeAtPoint = atPoint(pos)
        
        if let controllerMovement = controllerMovement {
            if controllerMovement.contains(nodeAtPoint) {
                leftTouch = touch
                controllerMovement.beginTracking()
            }
        }
        
        if let controllerAttack = controllerAttack {
            if controllerAttack.contains(nodeAtPoint) {
                rightTouch = touch
                controllerAttack.beginTracking()
            }
        }
        
        
    }
    
    func touchMoved(toPoint pos: CGPoint, touch: UITouch) {
        switch touch {
        case leftTouch:
            if let controllerMovement = controllerMovement {
                controllerMovement.moveJoystick(pos: pos)
            }
        case rightTouch:
            if let controllerAttack = controllerAttack {
                controllerAttack.moveJoystick(pos: pos)
            }
        default:
            break
        }
    }
    
    func touchUp(atPoint pos: CGPoint,touch: UITouch) {
        switch touch {
        case leftTouch:
            if let controllerMovement = controllerMovement {
                controllerMovement.endTracking()
            }
        case rightTouch:
            if let controllerAttack = controllerAttack {
                controllerAttack.endTracking()
            }
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self),touch: t) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self),touch: t) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self),touch:t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self),touch:t) }
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
        self.updateHUDLocation()
    }
    
    func updateControllerLocation() {
        self.controllerMovement?.position = CGPoint(
            x: viewLeft + self.margin + insets.left,
            y: viewBottom + self.margin + insets.bottom)
        self.controllerAttack?.position = CGPoint(
            x: viewRight - self.margin - insets.right,
            y: viewBottom + self.margin + insets.bottom)
    }
    
    func updateHUDLocation() {
        self.player?.hud.position = CGPoint(x: viewRight - self.margin - insets.right,
                                            y: viewTop - self.margin - insets.top)
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
            let circle = GKCircleObstacle(radius: Float(node.frame.size.width/2))
            circle.position = vector_float2(Float(node.position.x),
                                            Float(node.position.y))
            obstacles.append(circle)
        }
        if let nodesOnPath = sceneGraph.nodes as? [GKGraphNode2D] {
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
            
            self.agentComponentSystem.addComponent(agent)
        }
    }
}
