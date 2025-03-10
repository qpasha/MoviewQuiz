//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Pasha on 9/3/25.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan (_ another: GameResult) -> Bool {
        return self.correct > another.correct
    }
}
