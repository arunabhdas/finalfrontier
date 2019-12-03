import UIKit

struct Emoji {
  let name: String
  let character: String
}

class FaceSource: NSObject {
  lazy var replacements: [Emoji] = {
    let faces = "😀,😂,💩,🦄,😎,😷,😱,🤔,😍"
    let names = "smile,cry,poo,unicorn,sunglasses,mask,scream,think,love"
    return zip(faces.components(separatedBy: ","), names.components(separatedBy: ","))
      .map({ let (face, name) = $0;
        return Emoji(name: name, character: face)
      })
  }()
  
  var collectionView: UICollectionView?
  var faceChosen: ((_ face: UIImage) -> ())?
}

extension FaceSource {
  func selectFace(_ string: String) {
    if let index = replacements.index(where: { string.lowercased().contains($0.name) }),
      let collectionView = collectionView {
      let indexPath = IndexPath(item: index, section: 0)
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
      self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
  }
}



extension FaceSource: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return replacements.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let faceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceCell", for: indexPath) as! FaceCell
    faceCell.label.text = replacements[indexPath.item].character
    return faceCell
  }
}

extension FaceSource: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let emoji = replacements[indexPath.item].character
    let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 100)]
    
    let adjustment: CGFloat = 10.0
    let boundingSize = emoji.size(withAttributes: attributes)
    var adjustedSize = boundingSize
    adjustedSize.width -= adjustment
    adjustedSize.height -= adjustment
    let drawingRect = CGRect(x: adjustment * -0.5, y: adjustment * -0.5, width: boundingSize.width, height: boundingSize.height)
    
    UIGraphicsBeginImageContextWithOptions(adjustedSize, false, 0)
    emoji.draw(in: drawingRect, withAttributes: attributes)
    let face = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    faceChosen?(face!)
  }
}
