import Foundation

class Card: NSObject
{
  var color: Color
  var value: Value

  init(color: Color, value: Value)
  {
    self.color = color
    self.value = value
  }

  override var description: String
  {
        return "The card is a \(value) of \(color)"
  }

  override func isEqual(_ object: Any?) -> Bool
  {
    if let anyCard = object as? Card
    {
      return (self.value == anyCard.value) && (self.color == anyCard.color)
    }
    return false
  }
}
