//
//  GameObjects.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

enum GameObjectType: String {
    // monsters
    case skeleton
    case goblin
    // collectibles
    case key
    case food
    case treasure
}

enum GameObject {
    static let defaultGeneratorType = GameObjectType.skeleton.rawValue
    static let defaultAnimationType = GameObjectType.skeleton.rawValue

    static let defaultCollectibleType = GameObjectType.key.rawValue

    static let skeleton = Skeleton()
    static let goblin = Goblin()

    static let key = Key()
    static let food = Food()
    static let treasure = Treasure()

    struct Goblin {
        let animationSettings = Animation(
            textures: SKTexture.loadTextures(atlas: AtlasNames.monsterGoblin,
                                             prefix: TexturePrefixes.goblin,
                                             startsAt: 0, stopsAt: 1))
    }

    struct Skeleton {
        let animationSettings = Animation(
            textures: SKTexture.loadTextures(atlas: AtlasNames.monsterSkeleton,
                                             prefix: TexturePrefixes.skeleton,
                                             startsAt: 0, stopsAt: 1),
            timePerFrame: TimeInterval(1.0 / 25.0))
    }

    struct Key {
        let collectibleSettings = Collectible(type: .key,
                                              collectSound: Sounds.key,
                                              destroySound: Sounds.destroyed )
    }

    struct Food {
        let collectibleSettings = Collectible(type: .food,
                                              collectSound: Sounds.food,
                                              destroySound: Sounds.destroyed,
                                              canDestroy: true)
    }

    struct Treasure {
        let collectibleSettings = Collectible(type: .treasure,
                                              collectSound: Sounds.treasure,
                                              destroySound: Sounds.destroyed)
    }

    static func forAnimationType(_ type: GameObjectType?) -> Animation? {
        switch type {
        case .skeleton:
            return GameObject.skeleton.animationSettings
        case .goblin:
            return GameObject.goblin.animationSettings
        default:
            return nil
        }
    }

    static func forCollectibleType(_ type: GameObjectType?) -> Collectible? {
        switch type {
        case .key:
            return GameObject.key.collectibleSettings
        case .food:
            return GameObject.food.collectibleSettings
        case .treasure:
            return GameObject.treasure.collectibleSettings
        default:
            return nil
        }
    }
}
