//
//  Constants.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/20/21.
//

enum ImageNames: String {
    case playerHead0 = "player-val-head_0"
    case attackController = "controller_attack"
    case healthFull = "health_full"
    case healthEmpty = "health_empty"
}

enum Names: String {
    case grassTileMap = "Grass Tile Map"
    case dungeonTileMap = "Dungeon Tile Map"
    case player
    case key
    case exit
    case knife
    case destrooyed
    case anyGenerator = "generator_*"
    case newGameButton
    case loadGameButton
    case controllerStick = "controller_stick"
    case controllerMain = "controller_main"
    case controllerLeft = "controller_left"
    case controllerRight = "controller_right"
    case controllerUp = "controller_up"
    case controllerDown = "controller_down"
    case controllerTopLeft = "controller_topLeft"
    case controllerTopRight = "controller_topRight"
    case controllerBottomLeft = "controller_bottomLeft"
    case controllerBottomRight = "controller_bottomRight"
    case spawnMonster
}

enum FileNames: String {
    case controller = "Controller"
    case gameData = "gameData.json"
    case music
    case gameOverScene = "GameOverScene"
    case doorOpen = "door_open"
    case healthMeter = "HealthMeter"
}

enum FontNames: String {
    case AvenirNextBold = "AvenirNext-Bold"
}

enum AtlasNames: String {
    case monsterGoblin = "monster_goblin"
    case monsterSkeleton = "monster_skeleton"
}

enum TexturePrefixes: String {
    case goblin =  "goblin_"
    case skeleton = "skeleton_"
}

enum Sounds: String {
    case key
    case destroyed
    case food
    case treasure
    case playerHit = "player_hit"
    case playerDie = "player_die"
    case monsterHit = "monster_hit"
    case monsterDie = "monster_die"
}
