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
        var textureArray = [SKTexture]()
        let textureAtlas = SKTextureAtlas(named: atlas)
        for i in startsAt ... stopsAt {
            let textureName = "\(prefix)\(i)"
            textureArray.append(textureAtlas.textureNamed(textureName))
        }
        return textureArray
    }
}
