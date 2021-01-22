//
//  SKTexture_LoadTextures.swift
//  valsrevenge
//
//  Created by Mike Cargal on 1/17/21.
//

import SpriteKit

extension SKTexture {
    static func loadTextures(atlas: AtlasNames, prefix: TexturePrefixes,
                             startsAt: Int, stopsAt: Int) -> [SKTexture]
    {
        let textureAtlas = SKTextureAtlas(named: atlas.rawValue)
        return (startsAt ... stopsAt).map {i in textureAtlas.textureNamed("\(prefix.rawValue)\(i)")}
    }
}
