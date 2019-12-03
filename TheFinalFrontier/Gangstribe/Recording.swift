import Foundation

let recordingNames: [(String, String, String, String?)] = [
  ("It's Like That", "Run DMC", "01_ItsLikeThat.m4a", "en_GB"),
  ("Jump Around", "House of Pain", "02_JumpAround.m4a", "en_GB"),
  ("Gangsta's Paradise", "Coolio", "03_GangstasParadise.m4a", "en_GB"),
  ("U Can't Touch This", "MC Hammer", "04_UCantTouchThis.m4a", "en_GB"),
  ("Rapper's Delight", "Sugarhill Gang", "05_RappersDelight.m4a", "en_GB"),
  ("I Like Big Butts", "Sir Mix-a-Lot", "06_ILikeBigButts.m4a", "en_GB"),
  ("One Dance", "Drake", "07_OneDance.m4a", "en_GB"),
  ("No Sleep 'Til Brooklyn", "Beastie Boys", "08_NoSleepTilBrooklyn.m4a", "en_GB"),
  ("Informer", "Snow", "09_Informer.m4a", "en_GB"),
  ("Raise Your Hands", "โจอี้ บอย", "10_RaiseYourHands.m4a", "th_TH")
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



