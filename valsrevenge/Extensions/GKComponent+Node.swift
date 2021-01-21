//
//  GKComponent+Node.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

extension GKComponent {
    var componentNode: SKNode {
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            return node
        }
        
        if let node = entity?.component(ofType: RenderComponent.self)?.spriteNode {
            return node
        }

        return SKNode()
    }
}
