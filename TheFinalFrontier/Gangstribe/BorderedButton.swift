import UIKit

@IBDesignable
class BorderedButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  fileprivate func sharedInit() {
    layer.borderColor = currentTitleColor.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 5
  }
  
  override func tintColorDidChange() {
    super.tintColorDidChange()
    layer.borderColor = currentTitleColor.cgColor
  }
  
  override var isEnabled: Bool {
    didSet {
      layer.borderColor = currentTitleColor.cgColor
    }
  }
  
  
}
