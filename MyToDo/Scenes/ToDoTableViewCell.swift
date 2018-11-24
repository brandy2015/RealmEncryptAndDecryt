

import UIKit

class ToDoTableViewCell: UITableViewCell {
  var didToggleCompleted: (()->())?

  @IBOutlet private var label: UILabel!
  @IBOutlet private var button: UIButton!
  @IBAction private func toggleCompleted() {
    didToggleCompleted?()
  }

  func update(with item: ToDoItem) {
    label.attributedText = NSAttributedString(string: item.text,
                                              attributes: item.isCompleted ? [.strikethroughStyle: true] : [:])
    button.setTitle(item.isCompleted ? "☑️": "⏺", for: .normal)
  }
}
