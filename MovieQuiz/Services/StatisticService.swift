//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Pasha on 9/3/25.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    /// Enum для ключей UserDefaults
    private enum Keys: String {
        case correctAnswers
        case totalQuestions
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
    
    var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }

    var totalQuestions: Int {
        get {
            storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
        // Добавляем чтение значения из UserDefaults
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
        // Добавляем запись значения newValue в UserDefaults
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        // Добавляем чтение значений полей GameResult(correct, total и date) из UserDefaults,
        // Затем создаём GameResult от полученных значений
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
        // Добавляем запись значений каждого поля из newValue в UserDefaults
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        // отношение всех правильных ответов от общего числа вопросов
        get {
            guard totalQuestions > 0 else { return 0.0 }
            return (Double(correctAnswers) / Double(totalQuestions)) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        // Обновляем общее количество правильных ответов и вопросов
        correctAnswers += count
        totalQuestions += amount
        gamesCount += 1

        // Создаём новый результат игры
        let newGameResult = GameResult(correct: count, total: amount, date: Date())

        // Проверяем, является ли этот результат лучшим
        if newGameResult.isBetterThan(bestGame) {
            bestGame = newGameResult
        }
    }
    
    // Метод для сброса всей статистики
    func resetStatistics() {
        storage.removeObject(forKey: Keys.correctAnswers.rawValue)
        storage.removeObject(forKey: Keys.totalQuestions.rawValue)
        storage.removeObject(forKey: Keys.gamesCount.rawValue)
        storage.removeObject(forKey: Keys.bestGameCorrect.rawValue)
        storage.removeObject(forKey: Keys.bestGameTotal.rawValue)
        storage.removeObject(forKey: Keys.bestGameDate.rawValue)
    }
    
}
