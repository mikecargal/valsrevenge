//
//  GameScene+PhysicsContact.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask |
            contact.bodyB.categoryBitMask
        switch collision {
        // MARK: - Player | Collectible

        case PhysicsBody.player.categoryBitMask | PhysicsBody.collectible.categoryBitMask:
            let (playerNode, collectibleNode) = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                (contact.bodyA.node, contact.bodyB.node) :
                (contact.bodyB.node, contact.bodyA.node)

            if let player = playerNode as? Player,
               let collectible = collectibleNode
            {
                player.collectItem(collectible)
            }

        // MARK: - Player | Door

        case PhysicsBody.player.categoryBitMask | PhysicsBody.door.categoryBitMask:
            let (playerNode, doorNode) = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                (contact.bodyA.node, contact.bodyB.node) :
                (contact.bodyB.node, contact.bodyA.node)

            if let player = playerNode as? Player,
               let door = doorNode
            {
                player.useKeyToOpenDoor(door)
            }

        // MARK: - Projectile | Collectible

        case PhysicsBody.projectile.categoryBitMask | PhysicsBody.collectible.categoryBitMask:
            let (projectileNode, collectibleNode) = contact.bodyA.categoryBitMask == PhysicsBody.projectile.categoryBitMask ?
                (contact.bodyA.node, contact.bodyB.node) :
                (contact.bodyB.node, contact.bodyA.node)
            if let collectibleComponent = collectibleNode?.entity?.component(ofType: CollectibleComponent.self) {
                collectibleComponent.destroyedItem()
            }
            projectileNode?.removeFromParent()

        // MARK: - Player | Monster

        case PhysicsBody.player.categoryBitMask | PhysicsBody.monster.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.contactTestBitMask ?
                contact.bodyA.node : contact.bodyB.node
            if let healthComponent = playerNode?.entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(-1, forNode: playerNode)
            }

        // MARK: - Projectile | Monster

        case PhysicsBody.projectile.categoryBitMask | PhysicsBody.monster.categoryBitMask:
            let monsterNode = contact.bodyA.categoryBitMask == PhysicsBody.monster.categoryBitMask ?
                contact.bodyA.node : contact.bodyB.node

            if let healthComponent = monsterNode?.entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(-1, forNode: monsterNode)
            }

        default:
            break
        }
    }
}
