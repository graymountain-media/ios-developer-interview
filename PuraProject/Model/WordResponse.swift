//
//  WordResponse.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation

struct WordResponse: Codable {
    let meta: Meta
    let shortdef: [String]
    
    var syns: [String] {
        return meta.syns?.first ?? []
    }
    
    var ants: [String] {
        return meta.ants?.first ?? []
    }
    
    var word: Word {
        return Word(text: meta.stems.first!, definitions: shortdef, synonyms: syns, antonyms: ants)
    }
}
