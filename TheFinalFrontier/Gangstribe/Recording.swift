import Foundation

let recordingNames: [(String, String, String, String?)] = [
  ("Stairway to Heaven", "DasMachineLabs", "1_stairway_to_heaven.mp3", "en_GB"),
  ("Brothers in Arms", "DasMachineLabs", "2_brothers_in_arms.mp3", "en_GB"),
  ("High and Dry", "DasMachineLabs", "3_high_and_dry.mp3", "en_GB"),
  ("Losing My Religion", "DasMachineLabs", "4_losing_my_religion.mp3", "en_GB")
]

struct Recording {
  let title: String
  let subtitle: String
  let audio: URL
  let locale: Locale?
  
  init(title: String, subtitle: String, filename: String, locale: Locale?) {
    self.title = title
    self.subtitle = subtitle
    self.audio = Bundle.main.url(forResource: filename, withExtension: .none)!
    self.locale = locale
  }
  
  static func defaultRecordings() -> [Recording] {
    return recordingNames.map({ let (title, subtitle, filename, localeName) = $0;
      let locale: Locale?
      if let localeName = localeName {
        locale = Locale(identifier: localeName)
      } else {
        locale = .none
      }
      return Recording(title: title, subtitle: subtitle, filename: filename, locale: locale)
    })
  }
}



