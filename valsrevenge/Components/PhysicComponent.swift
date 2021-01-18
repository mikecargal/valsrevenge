//
//  File.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

enum PhysicsCategory: String {
    case player
    case wall
    case door
    case monster
    case projectile
    case collectible
    case exit
}

enum PhysicsShape: String {
    case circle
    case rect
}

struct PhysicsBody: OptionSet, Hashable {
    let rawValue: UInt32

    static let player = PhysicsBody(rawValue: 1 << 0)
    static let wall = PhysicsBody(rawValue: 1 << 1)
    static let door = PhysicsBody(rawValue: 1 << 2)
    static let monster = PhysicsBody(rawValue: 1 << 3)
    static let projectile = PhysicsBody(rawValue: 1 << 4)
    static let collectible = PhysicsBody(rawValue: 1 << 5)
    static let exit = PhysicsBody(rawValue: 1 << 6)

    static let collisions: [PhysicsBody: [PhysicsBody]] = [
        .player: [.wall, .door],
        .monster: [.wall, .door],
      //  .door: [.player,.monster]
    ]

    static let contactTests: [PhysicsBody: [PhysicsBody]] = [
        .player: [.monster, .collectible, .door, .exit],
        .wall: [.player],
        .door: [.player],
        .monster: [.player, .projectile],
        .projectile: [.monster, .collectible, .wall],
        .collectible: [.player, .projectile],
        .exit: [.player]
    ]

    var categoryBitMask: UInt32 {
        return self.rawValue
    }

    var collisionBitMask: UInt32 {
        let bitMask = PhysicsBody
            .collisions[self]?
            .reduce(PhysicsBody()) { result, physicsBody in
                print("before union: result=\(result), physicsBody=\(physicsBody)")
                let newRes = result.union(physicsBody)
                print("after union: result=\(newRes), physicsBody=\(physicsBody)")
                return newRes
            }
        return bitMask?.rawValue ?? 0
    }

    var contactTestBitMask: UInt32 {
        let bitMask = PhysicsBody
            .contactTests[self]?
            .reduce(PhysicsBody()) { result, physicsBody in
                result.union(physicsBody)
            }
        return bitMask?.rawValue ?? 0
    }

    static func forType(_ type: PhysicsCategory?) -> PhysicsBody? {
        switch type {
        case .player:
            return self.player
        case .wall:
            return self.wall
        case .door:
            return self.door
        case .monster:
            return self.monster
        case .projectile:
            return self.projectile
        case .collectible:
            return self.collectible
        case .exit:
            return self.exit
        case .none:
            break
        }
        return nil
    }
}

// MARK: - COMPONENT CODE STARTS HERE

class PhysicsComponent: GKComponent {
    @GKInspectable var bodyCategory: String = PhysicsCategory.wall.rawValue
    @GKInspectable var bodyShape: String = PhysicsShape.circle.rawValue

    override func didAddToEntity() {
        guard let bodyCategory = PhysicsBody.forType(PhysicsCategory(rawValue: bodyCategory)),
              let bodyShape = PhysicsShape(rawValue:self.bodyShape),
              let sprite = componentNode as? SKSpriteNode
        else { return }

        let size = sprite.size

        switch bodyShape {
        case .rect:
            print("PhysicsComponent.physicsBody -> rectangleOf \(size)")
            componentNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        case .circle:
            componentNode.physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        }

        componentNode.physicsBody?.categoryBitMask = bodyCategory.categoryBitMask
        componentNode.physicsBody?.collisionBitMask = bodyCategory.collisionBitMask
        componentNode.physicsBody?.contactTestBitMask = bodyCategory.contactTestBitMask

        componentNode.physicsBody?.affectedByGravity = false
        componentNode.physicsBody?.allowsRotation = false
    }

    override class var supportsSecureCoding: Bool {
        true
    }
}
