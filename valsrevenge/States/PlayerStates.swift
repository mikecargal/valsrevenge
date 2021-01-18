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

    override func didEnter(from previousState: GKState?) {}

    override func willExit(to nextState: GKState) {}

    override func update(deltaTime seconds: TimeInterval) {}
}

class PlayerHasNoKeyState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayerHasKeyState.self ||
            stateClass == PlayerHasNoKeyState.self
    }

    override func didEnter(from previousState: GKState?) {}

    override func willExit(to nextState: GKState) {}

    override func update(deltaTime seconds: TimeInterval) {}
}
