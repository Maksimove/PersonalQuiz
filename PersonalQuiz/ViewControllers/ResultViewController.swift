import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var answers: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        findDuplicates()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func findDuplicates() {
        var dict: [Animal: Answer] = [:]
        var duplicates: [Answer] = []
        
        for answer in answers {
            if let duplicate = dict[answer.animal] {
                duplicates.append(duplicate)
            } else {
                dict[answer.animal] = answer
            }
        }
        guard let animal = duplicates.first?.animal.rawValue else { return }
        resultLabel.text = "Вы - \(String(animal))!"
        guard let animalDescription = duplicates.first?.animal.definition else { return }
            descriptionLabel.text = animalDescription
    }
}
