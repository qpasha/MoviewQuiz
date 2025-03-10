//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Pasha on 9/3/25.
//

import Foundation
protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
