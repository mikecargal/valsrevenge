//
//  AnimationComponent.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

struct Animation {
    let textures: [SKTexture]
    var timePerFrame: TimeInterval

    let repeatTexturesForever: Bool
    let resizeTexture: Bool
    let restoreTexture: Bool
    init(textures: [SKTexture],
         timePerFrame: TimeInterval = TimeInterval(1.0 / 5.0),
         repeatTexturesForever: Bool = true,
         resizeTexture: Bool = true,
         restoreTexture: Bool = true)
    {
        self.textures = textures
        self.timePerFrame = timePerFrame
        self.repeatTexturesForever = repeatTexturesForever
        self.resizeTexture = resizeTexture
        self.restoreTexture = restoreTexture
    }
}

// MARK: - COMPONENT CODE STARTS HERE

class AnimationComponent: GKComponent {
    @GKInspectable var animationType: String = GameObject.defaultAnimationType

    override func didAddToEntity() {
        guard let animation =
            GameObject.forAnimationType(GameObjectType(rawValue: animationType))
        else {
            return
        }

        let animationAction = SKAction.animate(with: animation.textures, timePerFrame: animation.timePerFrame)

        if animation.repeatTexturesForever {
            componentNode.run(SKAction.repeatForever(animationAction))
        } else {
            componentNode.run(animationAction)
        }
    }

    override class var supportsSecureCoding: Bool {
        true
    }
}
