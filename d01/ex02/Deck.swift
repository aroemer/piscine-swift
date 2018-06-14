import Foundation

class Deck: NSObject
{
  static let allSpades : [Card] = Value.allValues.map { (cardValue) -> Card in
    var Spades = Card(color: Color.Spade, value: cardValue)
    return Spades
  }

  static let allDiamonds : [Card] = Value.allValues.map { (cardValue) -> Card in
    var Diamonds = Card(color: Color.Diamond, value: cardValue)
    return Diamonds
  }

  static let allHearts : [Card] = Value.allValues.map { (cardValue) -> Card in
    var Hearts = Card(color: Color.Heart, value: cardValue)
    return Hearts
  }

  static let allClubs : [Card] = Value.allValues.map { (cardValue) -> Card in
    var Clubs = Card(color: Color.Club, value: cardValue)
    return Clubs
  }

  static let allCards : [Card] = allSpades + allDiamonds + allHearts + allClubs

}
