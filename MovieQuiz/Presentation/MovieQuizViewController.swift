import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Properties
    private let presenter = MovieQuizPresenter()

    private var statisticService: StatisticServiceProtocol?
    
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenter?
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        presenter.viewController = self
        
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        
        view.isUserInteractionEnabled = true // Включаем взаимодействие после загрузки вопроса
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
        view.isUserInteractionEnabled = false // Блокируем нажатия, пока не появится следующий вопрос
        
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
            guard let statisticService = statisticService else { return }
            
            if presenter.isLastQuestion() {
                statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
                let totalGames = statisticService.gamesCount
                let bestGame = statisticService.bestGame
                let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
                
                let message = """
                    Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                    Количество сыгранных квизов: \(totalGames)
                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                    Средняя точность: \(accuracy)%
                    """
                
                let alertModel = AlertModel(
                    title: "Игра окончена!",
                    message: message,
                    buttonText: "Сыграть ещё раз",
                    completion: { [weak self] in
                        self?.presenter.resetQuestionIndex()
                        self?.correctAnswers = 0
                        self?.showLoadingIndicator()
                        self?.questionFactory?.loadData()
                    }
                )
                alertPresenter?.showAlert(with: alertModel)
            } else {
                presenter.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
        }

    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        view.isUserInteractionEnabled = true
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            if self.presenter.isLastQuestion() {
                self.showLoadingIndicator()
                self.questionFactory?.loadData()
            } else {
                self.questionFactory?.requestNextQuestion()
            }
        }
        
        alertPresenter?.showAlert(with: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        DispatchQueue.main.async {
            self.showNetworkError(message: "Не удалось загрузить изображение.\nОшибка: \(error.localizedDescription)")
        }
    }
}
