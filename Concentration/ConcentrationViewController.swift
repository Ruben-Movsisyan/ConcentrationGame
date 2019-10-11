import UIKit

class ConcentrationViewController: UIViewController {
    private var emojiList = "🐱🐭🦊🐶🐨🐼🐸🐯🦁🐮"
    private lazy var emojiChoices = emojiList

    var theme: String? {
        didSet{
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int{
           return (cardCollection.count+1)/2
    }
    
    private(set) var flipCount = 0{ didSet{ flipCountLabel.text = "Flip Count: \(flipCount)" }}
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardCollection: [UIButton]!

    @IBAction private func touchNewGameCard(_ sender: UIButton) {
        newGame()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
       flipCount += 1
        if let cardNumber = cardCollection.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card is not in card collection")
        }
    }
    
    private func updateViewFromModel(){
        if cardCollection != nil{
            for index in cardCollection.indices{
                let button = cardCollection[index]
                let card = game.cards[index]
                if card.isFaceUp{
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }else if card.isMatched{
                    button.backgroundColor = #colorLiteral(red: 0.9982461333, green: 0.9764142632, blue: 0.6037716269, alpha: 0)
                    button.isEnabled = false
                    button.setTitle("", for: UIControl.State.normal)
                    if game.guessedTuples > game.cards.count - 2{
                       newGame()
                    }
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor =  #colorLiteral(red: 0.9982461333, green: 0.9764142632, blue: 0.6037716269, alpha: 1)
                    button.isEnabled = true
                }
            }
        }
    }
    private var emoji = [Int: String]()

    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card.identifier] = String(emojiChoices.remove(at: randomStringIndex))
        }
         return emoji[card.identifier] ?? "?"
    }
    
    private func newGame(){
        game = Concentration(numberOfPairsOfCards: (cardCollection.count + 1) / 2)
        emojiChoices = theme!
        flipCount = 0
        updateViewFromModel()
    }
}

extension Int{
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        } else{
            return 0
        }
    }
}
