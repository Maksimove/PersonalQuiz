import UIKit

final class QuestionsViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabel: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedSlider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    // MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        let answersCount = Float(currentAnswers.count - 1)
        rangedSlider.maximumValue = answersCount
        rangedSlider.value = answersCount / 2
    }
    // MARK: - data transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let answersResult = segue.destination as? ResultViewController else { return }
        answersResult.answers = answersChosen
    }
    // MARK: - IB Actions
    @IBAction func singleAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
}

    // MARK: - Private Methods
extension QuestionsViewController {
    func updateUI() {
        //Скрываем все
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        // Задаем заголовок
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        //Получаем текущее значение
        let currentQuestion = questions[questionIndex]
        //Устанавливаем текущий вопрос
        questionLabel.text = currentQuestion.title
        
        //Считаем прогресс
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        //Устанавливаем значение для прогрессвью
        questionProgressView.setProgress(totalProgress, animated: true)
        //Отобразить стек определенной категории
        showCurrentAnswers(for: currentQuestion.type)
    }

    func showCurrentAnswers(for type: ResponceType) {
        switch type {
            
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .range: showRangedStackView(with: currentAnswers)
            
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabel, answers) {
            label.text = answer.title
        }
    }
    
    func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}






