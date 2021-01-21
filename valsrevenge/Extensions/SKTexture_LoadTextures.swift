//
//  SKTexture_LoadTextures.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import SpriteKit

extension SKTexture {
    static func loadTextures(atlas: String, prefix: String,
                             startsAt: Int, stopsAt: Int) -> [SKTexture]
    {
        let textureAtlas = SKTextureAtlas(named: atlas)
        return (startsAt ... stopsAt).map {i in textureAtlas.textureNamed("\(prefix)\(i)")}
    }
}
