import UIKit
struct viewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

// Для состояния "Вопрос показан"
struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

// для состояние "Результат Квиза"
struct QuizResultsViewModel {
    // строка с заголовком алерта
    let title: String
    // строка с текстом о количестве набранных очков
    let text: String
    // текст для кнопки алерта
    let buttonText: String
}
