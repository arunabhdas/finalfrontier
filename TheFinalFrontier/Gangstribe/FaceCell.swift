import UIKit

class FaceCell: UICollectionViewCell {
  
  @IBOutlet weak var label: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectedBackgroundView = UIView(frame:bounds.insetBy(dx: 5, dy: 5))
    selectedBackgroundView?.layer.cornerRadius = 5.0
    selectedBackgroundView?.backgroundColor = UIColor.orange
  }
}
