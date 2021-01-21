//
//  Controller.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/19/21.
//

import SpriteKit

class Controller: SKReferenceNode {
    private var isMovement: Bool!
    
    private var attachedNode: SKNode!
    private var nodeSpeed: CGFloat!
    
    private var base: SKNode!
    private var joystick: SKSpriteNode!
    private var range: CGFloat!
    
    private var isTracking: Bool = true
    
    // MARK: - Controller Init
    
    convenience init(stickImage: SKSpriteNode?,
                     attachedNode: SKNode,
                     nodeSpeed: CGFloat = 0.0,
                     isMovement: Bool = true,
                     range: CGFloat = 55.0,
                     color: SKColor = .darkGray)
    {
        self.init(fileNamed: FileNames.controller.rawValue)
        
        // setup the joystick
        joystick = childNode(withName: "//\(Names.controllerStick.rawValue)") as? SKSpriteNode
        joystick.zPosition += 1
        if let stickImage = stickImage {
            joystick.addChild(stickImage)
        }
        
        // set up inner base shape
        base = joystick.childNode(withName: "//\(Names.controllerMain.rawValue)")
        let innerBase = SKShapeNode(circleOfRadius: range * 2)
        innerBase.strokeColor = .black
        innerBase.fillColor = color
        base.addChild(innerBase)
        
        // Lock Joystick to base
        let rangeX = SKRange(lowerLimit: -range, upperLimit: range)
        let rangeY = SKRange(lowerLimit: -range, upperLimit: range)
        joystick.constraints = [SKConstraint.positionX(rangeX, y: rangeY)]
        
        // set the other properties
        self.range = range
        self.attachedNode = attachedNode
        self.nodeSpeed = nodeSpeed
        self.isMovement = isMovement
    }
    
    override init(fileNamed fileName: String?) {
        super.init(fileNamed: fileName)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func anchorRight() {
        scene?.anchorPoint = CGPoint(x: 1, y: 0)
        base.position = CGPoint(x: -175.0, y: 175.0)
    }

    func anchorLeft() {
        scene?.anchorPoint = CGPoint(x: 0, y: 0)
        base.position = CGPoint(x: 175.0, y: 175.0)
    }
    
    func hideNodeWithName(_ name: Names) {
        if let node = childNode(withName: "//\(name.rawValue)") as? SKSpriteNode { node.isHidden = true }
        
    }
    func hideLargeArrows() {
        hideNodeWithName(.controllerLeft)
        hideNodeWithName(.controllerRight)
        hideNodeWithName(.controllerUp)
        hideNodeWithName(.controllerDown)
    }
    
    func hideSmallArrows() {
        hideNodeWithName(.controllerTopLeft)
        hideNodeWithName(.controllerTopRight)
        hideNodeWithName(.controllerBottomLeft)
        hideNodeWithName(.controllerBottomRight)
    }
    
    // <ARK: - Controller Methods
    
    func beginTracking() {
        isTracking = true
    }
    
    func endTracking() {
        isTracking = false
        joystick.position = .zero
        moveAttachedNode(direction: .zero)
    }
    
    func moveJoystick(pos: CGPoint) {
        let location =  isTracking ? base.convert(pos, from: scene!) : CGPoint()
        joystick.position = location
        
        // move the joystick node
        let xAxis = location.x.clamped(to: -range...range)
        let yAxis = location.y.clamped(to: -range...range)

        if isMovement {
            moveAttachedNode(direction: CGVector(dx: xAxis, dy: yAxis))
        } else {
            otherAction(direction: CGVector(dx: xAxis, dy: yAxis))
        }
    }
    
    func moveAttachedNode(direction: CGVector) {
        attachedNode.physicsBody?.velocity =
            CGVector(dx: direction.dx * nodeSpeed,
                     dy: direction.dy * nodeSpeed)
    }
    
    func otherAction(direction: CGVector) {
        guard let player = attachedNode as? Player
        else { return }
        player.attack(direction: direction)
    }
}
