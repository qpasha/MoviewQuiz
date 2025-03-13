//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pasha on 3/3/25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
