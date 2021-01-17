//
//  MonsterEntity.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit
import SpriteKit

class MonsterEntity: GKEntity {
    init(monsterType: String) {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
