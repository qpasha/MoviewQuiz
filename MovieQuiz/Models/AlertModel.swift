//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Pasha on 3/3/25.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
