//
//  GameViewController.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/14/21.
//

import GameplayKit
import SpriteKit
import UIKit

protocol GameViewControllerDelegate {
    func didChangeLayout()
}

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the view
        if let view = self.view as! SKView? {
            let scene = TitleScene(fileNamed: "TitleScene")
            scene?.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard
            let skView = view as? SKView,
            let gameViewControllerDelegate = skView.scene as? GameViewControllerDelegate
        else {
            return
        }
        gameViewControllerDelegate.didChangeLayout()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
