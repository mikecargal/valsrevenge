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
        default:
            break
        }
    }
}
