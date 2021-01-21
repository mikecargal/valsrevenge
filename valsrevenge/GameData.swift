//
//  GameData.swift
//  valsrevenge
//
//  Created by Tammy Coron on 7/4/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import Foundation

class GameData: NSObject, Codable {
  
  // MARK: - Properties
  var level: Int = 1
  
  var keys: Int = 0
  var treasure: Int = 0
  
  // Set up a shared instance of GameData
  static let shared: GameData = {
    let instance = GameData()
    
    return instance
  }()
  
  // MARK: - Init
  private override init() {}
  
  // MARK: - Save & Load Locally Stored Game Data
  func saveDataWithFileName(_ filename: String) {
    let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
    do {
      let data = try PropertyListEncoder().encode(self)
      let dataFile = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                      requiringSecureCoding: true)
      try dataFile.write(to: fullPath)
    } catch {
      print("Couldn't write Store Data file.")
    }
  }
  
  func loadDataWithFileName(_ filename: String) {
    let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
    do {
      let contents = try Data(contentsOf: fullPath)
      if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(contents) as? Data {
        let gd = try PropertyListDecoder().decode(GameData.self, from: data)
        
        // Restore data (properties)
        level = gd.level
        
        keys = gd.keys
        treasure = gd.treasure
        
      }
    } catch {
      print("Couldn't load Store Data file.")
    }
  }
  
  // Get the user's documents directory
  fileprivate func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
