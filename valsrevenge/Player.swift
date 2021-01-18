//
//  Player.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/14/21.
//

import GameplayKit
import SpriteKit

enum Direction: String {
    case stop
    case left
    case right
    case up
    case down
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class Player: SKSpriteNode {
    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(), PlayerHasNoKeyState()])
    private var currentDirection = Direction.stop

    private var keys: Int = 0 {
        didSet {
            print("Keys: \(keys)")
            if keys < 1 {
                stateMachine.enter(PlayerHasNoKeyState.self)
            } else {
                stateMachine.enter(PlayerHasKeyState.self)
            }
        }
    }

    private var treasure: Int = 0 {
        didSet {
            print("Treasure: \(treasure)")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stateMachine.enter(PlayerHasNoKeyState.self)
    }

    func collectItem(_ collectibleNode: SKNode) {
        guard let collectible = collectibleNode.entity?.component(ofType: CollectibleComponent.self) else { return }

        collectible.collectedItem()

        switch GameObjectType(rawValue: collectible.collectibleType) {
        case .key:
            print("collected key")
            keys += collectible.value
        case .food:
            print("collected food")
            if let hc = entity?.component(ofType: HealthComponent.self) {
                hc.updateHealth(collectible.value, forNode: self)
            }
        case .treasure:
            print("collected trasure")
            treasure += collectible.value
        default:
            break
        }
    }

    func useKeyToOpenDoor(_ doorNode: SKNode) {
            print("use key to poen door")
        switch stateMachine.currentState {
        case is PlayerHasKeyState:
            keys -= 1
            doorNode.removeFromParent()
            run(SKAction.playSoundFileNamed("door_open", waitForCompletion:     true))
        default:
            break
        }
    }
    
    func move(_ direction: Direction) {
        if direction != .stop {
            currentDirection = direction
        }
        switch direction {
        case .up:
            physicsBody?.velocity = CGVector(dx: 0, dy: 100)
        case .down:
            physicsBody?.velocity = CGVector(dx: 0, dy: -100)
        case .left:
            physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        case .right:
            physicsBody?.velocity = CGVector(dx: 100, dy: 0)
        case .topLeft:
            physicsBody?.velocity = CGVector(dx: -100, dy: 100)
        case .topRight:
            physicsBody?.velocity = CGVector(dx: 100, dy: 100)
        case .bottomLeft:
            physicsBody?.velocity = CGVector(dx: -100, dy: -100)
        case .bottomRight:
            physicsBody?.velocity = CGVector(dx: 100, dy: -100)

        case .stop:
            stop()
        }
    }

    func stop() {
        print("stop player")
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }

    func attack() {
        print("attack!!!")
        let projectile = SKSpriteNode(imageNamed: "knife")
        projectile.position = CGPoint(x: 0.0, y: 0.0)
        addChild(projectile)

        var throwDirection = CGVector()

        switch currentDirection {
        case .up:
            throwDirection = CGVector(dx: 0.0, dy: 300.0)
            projectile.zRotation = 0
        case .down:
            throwDirection = CGVector(dx: 0.0, dy: -300.0)
            projectile.zRotation = -CGFloat.pi
        case .left:
            throwDirection = CGVector(dx: -300.0, dy: 0.0)
            projectile.zRotation = CGFloat.pi/2
        case .right:
            throwDirection = CGVector(dx: 300.0, dy: 0.0)
            projectile.zRotation = -CGFloat.pi/2
        case .topLeft:
            throwDirection = CGVector(dx: -300.0, dy: 300.0)
            projectile.zRotation = CGFloat.pi/4
        case .topRight:
            throwDirection = CGVector(dx: 300.0, dy: 300.0)
            projectile.zRotation = -CGFloat.pi/4
        case .bottomLeft:
            throwDirection = CGVector(dx: -300.0, dy: -300.0)
            projectile.zRotation = 3 * CGFloat.pi/4
        case .bottomRight:
            throwDirection = CGVector(dx: 300.0, dy: -300.0)
            projectile.zRotation = 3 * -CGFloat.pi/4
        case .stop:
            print("WHAT?!?!? .stop should not be a current direction")
        }

        projectile.run(SKAction.move(by: throwDirection, duration: 0.25), completion: { projectile.removeFromParent() })
    }
}
