import Foundation

struct Concentration{
   private(set) var cards = [Card]()

    var guessedTuples = 0

    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "ConcentrationModel.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    guessedTuples += 2
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "ConcentrationMOdel.init(\(numberOfPairsOfCards)): you must have at least 1 pair of cards")
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
            cards.shuffle()
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
