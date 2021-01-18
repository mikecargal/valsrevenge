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

        case PhysicsBody.player.categoryBitMask |
            PhysicsBody.collectible.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                contact.bodyA.node :
                contact.bodyB.node

            let collectibleNode = contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitMask ?
                contact.bodyA.node :
                contact.bodyB.node
           if let player = playerNode as? Player,
              let collectible = collectibleNode {
            player.collectItem(collectible)
           }

        // MARK: - Player | Door

        case PhysicsBody.player.categoryBitMask |
            PhysicsBody.door.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                contact.bodyA.node :
                contact.bodyB.node

            let doorNode = contact.bodyA.categoryBitMask == PhysicsBody.door.categoryBitMask ?
                contact.bodyA.node :
                contact.bodyB.node
            if let player = playerNode as? Player,
               let door = doorNode {
                player.useKeyToOpenDoor(door)
            }

        default:
            break
        }
    }
}
