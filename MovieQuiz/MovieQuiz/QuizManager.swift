//
//  QuizManager.swift
//  MovieQuiz
//
//  Created by Jair Guedes Ferreira Neto on 14/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import Foundation

typealias Round = (quiz: Quiz, options: [QuizOption])

class QuizManager {
    
    let quizes: [Quiz]
    let quizesOptions: [QuizOption]
    var round: Round?
    var score: Int
    
    init() {
        score = 0
        let quizesURL = Bundle.main.url(forResource: "quizes", withExtension: "json")!
        do {
            let quizesData = try Data(contentsOf: quizesURL)
            quizes = try JSONDecoder().decode([Quiz].self, from: quizesData)
            let quizesOptionsURL = Bundle.main.url(forResource: "options", withExtension: "json")!
            let quizesOptionsData = try! Data(contentsOf: quizesOptionsURL)
            quizesOptions = try! JSONDecoder().decode([QuizOption].self, from: quizesOptionsData)
        } catch {
            print(error.localizedDescription)
            quizes = []
            quizesOptions = []
        }
    }
    
    func generateRandomQuiz() -> Round {
        let quizIndex = Int(arc4random_uniform(UInt32(quizes.count)))
        let quiz = quizes[quizIndex]
        var indexes: Set<Int> = [quizIndex]
        while indexes.count < 4 {
            let index = Int(arc4random_uniform(UInt32(quizes.count)))
            indexes.insert(index)
        }
        let options = indexes.map({quizesOptions[$0]})
        round = (quiz, options)
        
        return round!
    }
    
    func checkAnswer(answer: String) {
        guard let round = round else {return}
        if answer == round.quiz.name {
            score += 1
        }
    }
}

struct Quiz: Codable {
    let name: String
    let number: Int
}

struct QuizOption: Codable {
    let name: String
}
