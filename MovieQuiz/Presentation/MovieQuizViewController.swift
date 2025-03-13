import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Properties
    private var presenter: MovieQuizPresenter!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self, viewControllerForAlert: self)
        imageView.layer.cornerRadius = 20
    }

    
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Public Methods
     func show(quiz step: QuizStepViewModel) {
         imageView.image = step.image
         textLabel.text = step.question
         counterLabel.text = step.questionNumber
         imageView.layer.borderWidth = 0
         view.isUserInteractionEnabled = true
     }

     func show(quiz result: QuizResultsViewModel) {
         let alertModel = AlertModel(
             title: result.title,
             message: presenter.makeResultsMessage(),
             buttonText: result.buttonText,
             completion: { [weak self] in
                 self?.presenter.restartGame()
             }
         )
         presenter.alertPresenter.showAlert(with: alertModel)
     }

     func highlightImageBorder(isCorrectAnswer: Bool) {
         imageView.layer.masksToBounds = true
         imageView.layer.borderWidth = 8
         imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
     }

     func showLoadingIndicator() {
         activityIndicator.isHidden = false
         activityIndicator.startAnimating()
     }

     func hideLoadingIndicator() {
         activityIndicator.isHidden = true
         activityIndicator.stopAnimating()
     }

     func showNetworkError(message: String) {
         hideLoadingIndicator()

         let alertModel = AlertModel(
             title: "Ошибка",
             message: message,
             buttonText: "Попробовать ещё раз",
             completion: { [weak self] in
                 self?.presenter.restartGame()
             }
         )

         presenter.alertPresenter.showAlert(with: alertModel)
     }
 }
