//
//  CollectibleComponent.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

struct Collectible {
    let type: GameObjectType

    let collectSoundFile: String
    let destroySoundFile: String

    let canDestroy: Bool

    init(type: GameObjectType,
         collectSound: Sounds,
         destroySound: Sounds,
         canDestroy: Bool = false)
    {
        self.type = type
        self.collectSoundFile = collectSound.rawValue
        self.destroySoundFile = destroySound.rawValue
        self.canDestroy = canDestroy
    }
}
    
// MARK: - COMPONENT CODE STARTS HERE

class CollectibleComponent: GKComponent {
    @GKInspectable var collectibleType: String = GameObject.defaultCollectibleType
    @GKInspectable var value: Int = 1
        
    private var collectSoundAction = SKAction()
    private var destroySoundAction = SKAction()
    private var canDestroy = false
        
    override func didAddToEntity() {
        guard let collectible = GameObject.forCollectibleType(GameObjectType(rawValue: collectibleType))
        else { return }
            
        collectSoundAction = SKAction.playSoundFileNamed(collectible.collectSoundFile, waitForCompletion: false)
        destroySoundAction = SKAction.playSoundFileNamed(collectible.destroySoundFile, waitForCompletion: false)
        canDestroy = collectible.canDestroy
    }
        
    func collectedItem() {
        componentNode.run(collectSoundAction, completion: { self.componentNode.removeFromParent() })
    }
        
    func destroyedItem() {
        if canDestroy {
            componentNode.run(destroySoundAction, completion: { self.componentNode.removeFromParent() })
        }
    }
        
    override class var supportsSecureCoding: Bool {
        true
    }
}
    
