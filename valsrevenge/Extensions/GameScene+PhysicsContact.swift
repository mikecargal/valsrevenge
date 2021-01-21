//
//  GameScene+PhysicsContact.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    func match(_ contact: SKPhysicsContact, body: PhysicsBody) -> (match:SKNode, other:SKNode) {
        return contact.bodyA.categoryBitMask == body.categoryBitMask ?
            (contact.bodyA.node!, contact.bodyB.node!) :
            (contact.bodyB.node!, contact.bodyA.node!)
    }
    
    func collisionOf(_ bodyA :PhysicsBody, _ bodyB: PhysicsBody) -> UInt32 {
        bodyA.categoryBitMask | bodyB.categoryBitMask
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch collision {
        // MARK: - Player | Collectible

        case collisionOf(.player,.collectible):
            let (playerNode, collectible) = match(contact, body: .player)

            if let player = playerNode as? Player {
                player.collectItem(collectible)
            }

        // MARK: - Player | Door

        case collisionOf(.player,.door):
            let (playerNode, door) = match(contact, body: .player)

            if let player = playerNode as? Player {
                player.useKeyToOpenDoor(door)
            }

        // MARK: - Projectile | Collectible

        case collisionOf(.projectile,.collectible):
            let (projectileNode, collectibleNode) = match(contact, body: .projectile)
            if let collectibleComponent = collectibleNode.entity?.component(ofType: CollectibleComponent.self) {
                collectibleComponent.destroyedItem()
            }
            projectileNode.removeFromParent()

        // MARK: - Player | Monster

        case collisionOf(.player,.monster):
            let (playerNode, _) = match(contact, body: .player)
            if let healthComponent = playerNode.entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(-1, forNode: playerNode)
            }

        // MARK: - Projectile | Monster

        case collisionOf(.projectile,.monster):
            let (monsterNode, _) = match(contact, body: .monster)

            if let healthComponent = monsterNode.entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(-1, forNode: monsterNode)
            }

            // MARK: - Player | Platform

        case collisionOf(.player,.exit):
            let (playerNode, _) = match(contact, body: .player)
            // update the saved stats
            if let player = playerNode as? Player {
                GameData.shared.keys = player.getStats().keys
                GameData.shared.treasure = player.getStats().treasure
            }

            GameData.shared.level += 1
            loadSceneForLevel(GameData.shared.level)
        default:
            break
        }
    }
}
