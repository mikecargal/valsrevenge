//
//  SKScene+SceneManager.swift
//  valsrevenge
//
//  Created by Tammy Coron on 10/16/20.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import GameplayKit
import SpriteKit

extension SKScene {
    func startNewGame() {
        GameData.shared.level = 1
        GameData.shared.keys = 0
        GameData.shared.treasure = 0
    
        loadSceneForLevel(GameData.shared.level)
    }
  
    func resumeSavedGame() {
        loadSceneForLevel(GameData.shared.level)
    }
  
    func loadSceneForLevel(_ level: Int) {
        print("Attempting to load next scene: GameScene_\(level).")
    
        // Play sound
        run(SKAction.playSoundFileNamed(Names.exit.rawValue, waitForCompletion: true))
    
        // Create actions to load the next scene
        let presentGameScene = SKAction.run {
            // Load 'GameScene_xx.sks' as a GKScene
            if let scene = GKScene(fileNamed: "GameScene_\(level)") {
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    // Copy gameplay related content over to the scene
                    sceneNode.entities = scene.entities
                    sceneNode.graphs = scene.graphs
          
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
          
                    // Present the scene
                    self.view?.presentScene(sceneNode,
                                            transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
          
                    // Update the layout
                    sceneNode.didChangeLayout()
                }
            } else {
                print("Can't load next scene: GameScene_\(level).")
            }
        }
    
        // Run the actions in sequence
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.50),
            presentGameScene
        ]))
    }
  
    func loadGameOverScene() {
        print("Attempting to load the game over scene.")
    
        // Create actions to load the game over scene
        let presentGameOverScene = SKAction.run {
            if let scene = GameOverScene(fileNamed: FileNames.gameOverScene.rawValue) {
                scene.scaleMode = .aspectFill
        
                self.view?.presentScene(scene,
                                        transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
            } else {
                print("Can't load game over scene.")
            }
        }
    
        // Run the actions in sequence
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.50),
            presentGameOverScene
        ]))
    }
}
