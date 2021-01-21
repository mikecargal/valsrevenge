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
        joystick = childNode(withName: "//\(Names.controlerStick)") as? SKSpriteNode
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
    
    func hideLargeArrows() {
        if let node = childNode(withName: "//\(Names.controllerLeft.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
        if let node = childNode(withName: "//\(Names.controllerRight.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
        if let node = childNode(withName: "//\(Names.controllerUp.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
        if let node = childNode(withName: "//\(Names.controllerDown.rawValue)") as? SKSpriteNode { node.isHidden = true }
    }
    
    func hideSmallArrows() {
        if let node = childNode(withName: "//\(Names.controllerTopLeft.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
        if let node = childNode(withName: "//\(Names.controllerTopRight.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
        if let node = childNode(withName: "//\(Names.controllerBottomLeft.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
        if let node = childNode(withName: "//\(Names.controllerBottomRight.rawValue)") as? SKSpriteNode { node.isHidden = true
        }
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
        var location = pos
        
        // verify the player is using the on-screen controls
        if isTracking {
            location = base.convert(pos, from: scene!)
        }
        
        // move the joystick node
        let xAxis = CGFloat(location.x.clamped(to: -range...range))
        let yAxis = CGFloat(location.y.clamped(to: -range...range))
        joystick.position = CGPoint(x: location.x,
                                    y: location.y)
        if isMovement {
            moveAttachedNode(direction: CGVector(dx: xAxis, dy: yAxis))
        } else {
            otherAction(direction: CGVector(dx: xAxis, dy: yAxis))
        }
    }
    
    func moveAttachedNode(direction: CGVector) {
        attachedNode.physicsBody?.velocity =
            CGVector(dx: CGFloat(direction.dx * nodeSpeed),
                     dy: CGFloat(direction.dy * nodeSpeed))
    }
    
    func otherAction(direction: CGVector) {
        guard let player = attachedNode as? Player
        else { return }
        player.attack(direction: direction)
    }
}
