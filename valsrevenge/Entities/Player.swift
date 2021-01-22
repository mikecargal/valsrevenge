//
//  Player.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/14/21.
//

import GameplayKit
import SpriteKit

class Player: SKSpriteNode {
    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(),
                                               PlayerHasNoKeyState()])

    var movementSpeed: CGFloat = 5
    var maxProjectiles: Int = 1
    var numProjectiles: Int = 0

    var projectileSpeed: CGFloat = 25

    var projectileRange: TimeInterval = 1

    let attackDelay = SKAction.wait(forDuration: 0.25)

    var agent = GKAgent2D()

    var hud = SKNode()
    private let treasureLabel = SKLabelNode(fontNamed: FontNames.AvenirNextBold.rawValue)
    private let keysLabel = SKLabelNode(fontNamed: FontNames.AvenirNextBold.rawValue)

    private var keys: Int = GameData.shared.keys {
        didSet {
            keysLabel.text = "Keys: \(keys)"
            stateMachine.enter(keys < 1 ? PlayerHasNoKeyState.self : PlayerHasKeyState.self)
        }
    }

    private var treasure: Int = GameData.shared.treasure {
        didSet {
            treasureLabel.text = "Treasure: \(treasure)"
            print("Treasure: \(treasure)")
        }
    }

    func getStats() -> (keys: Int, treasure: Int) {
        return (keys, treasure)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        agent.delegate = self
        stateMachine.enter(PlayerHasNoKeyState.self)
    }

    func setupHUD(scene: GameScene) {
        // set up the treasue label
        treasureLabel.text = "Treasure: \(treasure)"
        treasureLabel.horizontalAlignmentMode = .right
        treasureLabel.verticalAlignmentMode = .center
        treasureLabel.position = CGPoint(x: 0, y: -treasureLabel.frame.height)
        treasureLabel.zPosition += 1

        // set up the keys label
        keysLabel.text = "Keys: \(keys)"
        keysLabel.horizontalAlignmentMode = .right
        keysLabel.verticalAlignmentMode = .center
        keysLabel.position = CGPoint(x: 0, y: treasureLabel.frame.minY - treasureLabel.frame.height)
        keysLabel.zPosition += 1

        // Add the labels to the HUD
        hud.addChild(treasureLabel)
        hud.addChild(keysLabel)

        scene.addChild(hud)
    }

    func collectItem(_ collectibleNode: SKNode) {
        guard let collectible = collectibleNode.entity?.component(ofType: CollectibleComponent.self) else { return }

        collectible.collectedItem()

        switch GameObjectType(rawValue: collectible.collectibleType) {
        case .key:
            keys += collectible.value
        case .food:
            if let hc = entity?.component(ofType: HealthComponent.self) {
                hc.updateHealth(collectible.value, forNode: self)
            }
        case .treasure:
            treasure += collectible.value
        default:
            break
        }
    }

    func useKeyToOpenDoor(_ doorNode: SKNode) {
        if stateMachine.currentState is PlayerHasKeyState {
            keys -= 1
            doorNode.removeFromParent()
            run(SKAction.playSoundFileNamed(FileNames.doorOpen.rawValue, waitForCompletion: true))
        }
    }

    func attack(direction: CGVector) {
        if direction != .zero, numProjectiles < maxProjectiles {
            numProjectiles += 1
            let projectile = SKSpriteNode(imageNamed: Names.knife.rawValue)
            projectile.position = CGPoint(x: 0.0, y: 0.0)
            projectile.zPosition += 1
            addChild(projectile)

            let physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
            physicsBody.affectedByGravity = false
            physicsBody.allowsRotation = true
            physicsBody.isDynamic = true

            let pb = PhysicsBody.projectile
            physicsBody.categoryBitMask = pb.categoryBitMask
            physicsBody.contactTestBitMask = pb.contactTestBitMask
            physicsBody.collisionBitMask = pb.collisionBitMask

            projectile.physicsBody = physicsBody

            projectile.run(SKAction.group([
                SKAction.sequence([
                    SKAction.wait(forDuration: projectileRange),
                    SKAction.removeFromParent()
                ]),
                SKAction.group([
                    SKAction.applyTorque(0.25, duration: projectileRange),
                    SKAction.move(by: CGVector(dx: direction.dx * projectileSpeed,
                                               dy: direction.dy * projectileSpeed),
                                  duration: projectileRange)
                ])
            ]))

            run(SKAction.sequence([
                attackDelay,
                SKAction.run { self.numProjectiles -= 1 }
            ]))
        }
    }
}
