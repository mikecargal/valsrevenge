//
//  GameScene+ViewUpdates.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/15/21.
//

import SpriteKit

extension GameScene: GameViewControllerDelegate {
    func didChangeLayout() {
        let w = view?.bounds.size.width ?? 1024
        let h = view?.bounds.size.height ?? 1336
        camera?.setScale(h >= w ? 1.0 : 1.25)
    }
}
