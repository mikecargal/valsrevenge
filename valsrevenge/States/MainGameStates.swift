//
//  MainGameStates.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/18/21.
//

import GameplayKit

class PauseState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayingState.self
    }
}

class PlayingState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PauseState.self
    }
}

