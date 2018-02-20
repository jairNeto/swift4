//
//  QuotesManeger.swift
//  Pensamentos
//
//  Created by Jair Guedes Ferreira Neto on 29/1/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import Foundation

class QuoteManeger {
    
    let quotes: [Quote]
    
    init() {
        let fileURL = Bundle.main.url(forResource: "quotes", withExtension: ".json")!
        let jsonData = try! Data(contentsOf: fileURL)
        let jsonDecoder = JSONDecoder()
        quotes = try! jsonDecoder.decode([Quote].self, from: jsonData)
        
    }
    
    func getRandomQuote() -> Quote {
        let index = Int(arc4random_uniform(UInt32(quotes.count)))
        return quotes[index]
    }
}
