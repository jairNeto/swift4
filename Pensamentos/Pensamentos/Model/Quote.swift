//
//  Quote.swift
//  Pensamentos
//
//  Created by Jair Guedes Ferreira Neto on 29/1/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import Foundation

struct Quote: Codable {
    
    let quote: String
    let author: String
    let image: String
    
    var quoteFormatted: String {
        return " ‟" + quote + "” "
    }
    
    var authorFormatted: String {
        return "- " + author + " -"
    }
}
