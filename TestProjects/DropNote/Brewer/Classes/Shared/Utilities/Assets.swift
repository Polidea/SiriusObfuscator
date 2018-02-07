// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case Team = "Team"
  case Ic_add = "ic_add"
  case Ic_aeropress = "ic_aeropress"
  case Ic_aeropress_quick = "ic_aeropress_quick"
  case Ic_arrow = "ic_arrow"
  case Ic_back = "ic_back"
  case Ic_best = "ic_best"
  case Ic_chemex = "ic_chemex"
  case Ic_chemex_bw = "ic_chemex_bw"
  case Ic_close = "ic_close"
  case Ic_coffee = "ic_coffee"
  case Ic_coffee_machine = "ic_coffee_machine"
  case Ic_coffee_machine_bw = "ic_coffee_machine_bw"
  case Ic_done = "ic_done"
  case Ic_drip = "ic_drip"
  case Ic_drip_bw = "ic_drip_bw"
  case Ic_empty_history = "ic_empty_history"
  case Ic_grind = "ic_grind"
  case Ic_inverted = "ic_inverted"
  case Ic_inverted_bw = "ic_inverted_bw"
  case Ic_kalita = "ic_kalita"
  case Ic_kone = "ic_kone"
  case Ic_machine = "ic_machine"
  case Ic_newest = "ic_newest"
  case Ic_next = "ic_next"
  case Ic_notes = "ic_notes"
  case Ic_oldest = "ic_oldest"
  case Ic_previous = "ic_previous"
  case Ic_tab_history = "ic_tab_history"
  case Ic_tab_history_pressed = "ic_tab_history_pressed"
  case Ic_tab_settings = "ic_tab_settings"
  case Ic_tab_settings_pressed = "ic_tab_settings_pressed"
  case Ic_tab_start = "ic_tab_start"
  case Ic_tab_start_pressed = "ic_tab_start_pressed"
  case Ic_tamp = "ic_tamp"
  case Ic_temp = "ic_temp"
  case Ic_time = "ic_time"
  case Ic_water = "ic_water"
  case Ic_weight = "ic_weight"
  case Ic_worst = "ic_worst"

  var image: Image {
    return Image(asset: self)
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
