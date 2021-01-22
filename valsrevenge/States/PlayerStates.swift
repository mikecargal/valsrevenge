//
//  PlayerStates.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import GameplayKit

class PlayerHasKeyState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayerHasKeyState.self ||
            stateClass == PlayerHasNoKeyState.self
    }
}

class PlayerHasNoKeyState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayerHasKeyState.self ||
            stateClass == PlayerHasNoKeyState.self
    }
}
