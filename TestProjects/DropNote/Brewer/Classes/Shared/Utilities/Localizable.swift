// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Coffee weight
  case attributeCoffeeWeight
  /// Grind size
  case attributeGrindSize
  /// Notes
  case attributeNotes
  /// Pre-infusion time
  case attributePreInfusionTime
  /// Tamp strength
  case attributeTampStrength
  /// Temperature
  case attributeTemperature
  /// Time
  case attributeTime
  /// Water weight or volume
  case attributeWaterWeight
  /// Cancel
  case brewDetailsConfirmationNo
  /// Are you sure you want to remove this brew?
  case brewDetailsConfirmationTitle
  /// Remove
  case brewDetailsConfirmationYes
  /// Score
  case brewDetailScore
  /// Brew details
  case brewDetailsItemTitle
  /// Remove brew
  case brewDetailsRemoveTitle
  /// From the oldest
  case brewingsSortingDateAscending
  /// From the newest
  case brewingsSortingDateDescending
  /// From the worst
  case brewingsSortingScoreAscending
  /// From the best
  case brewingsSortingScoreDescending
  /// Sort
  case brewingsSortingSortTitle
  /// Score details
  case brewScoreDetailsItemTitle
  /// Acidity
  case cuppingAttributeAcidity
  /// Aftertaste
  case cuppingAttributeAftertaste
  /// Aroma
  case cuppingAttributeAroma
  /// Balance
  case cuppingAttributeBalance
  /// Body
  case cuppingAttributeBody
  /// Overall
  case cuppingAttributeOverall
  /// Sweetness
  case cuppingAttributeSweetness
  /// Type or select grind size
  case grindSizeInformativeText
  /// Coarse
  case grindSizeLevelCoarse
  /// Extra fine
  case grindSizeLevelExtraFine
  /// Fine
  case grindSizeLevelFine
  /// Medium
  case grindSizeLevelMedium
  /// Tap here to provide numerical value
  case grindSizeNumericButtonTitle
  /// Tap here to use slider
  case grindSizeSliderButtonTitle
  /// Here you'll see the history of your brewings
  case historyEmptySetDescription
  /// Search
  case historyFilterPlaceholder
  /// History
  case historyItemTitle
  /// Aeropress
  case methodAeropress
  /// Chemex
  case methodDetailChemex
  /// Inverted
  case methodDetailInverted
  /// Traditional
  case methodDetailTraditional
  /// V60
  case methodDetailV60
  /// Espresso machine
  case methodEsspressoMachine
  /// Kalita
  case methodKalita
  /// Kone
  case methodKone
  /// Pick method
  case methodPickItemTitle
  /// Pour-Over
  case methodPourOver
  /// Done
  case navigationDone
  /// Edit
  case navigationEdit
  /// Type your coffee...
  case newBrewCoffeeInputPlaceholder
  /// Type your espresso machine...
  case newBrewCoffeeMachinePlaceholder
  /// New brew
  case newBrewItemTitle
  /// Coffee
  case selectableSearchCoffeeItemTitle
  /// Espresso machine
  case selectableSearchCoffeeMachineItemTitle
  /// Sequence
  case sequenceItemTitle
  /// About
  case settingsAboutMenuItemTitle
  /// Thanks for translation
  case settingsAboutThanksForTransaltion
  /// Default
  case settingsBrewingSequenceMenuDefaultSubtitle
  /// Brewing sequence
  case settingsBrewingSequenceMenuItemTitle
  /// Feedback
  case settingsFeedbackMenuItemTitle
  /// Settings
  case settingsItemTitle
  /// Please rate Dropnote
  case settingsRateMenuItemTitle
  /// Units
  case settingsUnitsMenuItemTitle
  /// Start brewing
  case startBrewingItemTitle
  /// Select tamping strength
  case tampingInformativeText
  /// Type water temperature\nUnit can be changed in settings
  case temperatureInformativeText
  /// Type duration of brewing process
  case timeInformativeText
  /// Coffee
  case unitCategoryCoffee
  /// Temperature
  case unitCategoryTemperature
  /// Water
  case unitCategoryWater
  /// Units
  case unitsItemTitle
  /// Type weight or volume of water\nUnit can be changed in settings
  case waterInformativeText
  /// Type coffee weight\nUnit can be changed in settings
  case weightInformativeText
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .attributeCoffeeWeight:
        return L10n.tr(key: "AttributeCoffeeWeight")
      case .attributeGrindSize:
        return L10n.tr(key: "AttributeGrindSize")
      case .attributeNotes:
        return L10n.tr(key: "AttributeNotes")
      case .attributePreInfusionTime:
        return L10n.tr(key: "AttributePreInfusionTime")
      case .attributeTampStrength:
        return L10n.tr(key: "AttributeTampStrength")
      case .attributeTemperature:
        return L10n.tr(key: "AttributeTemperature")
      case .attributeTime:
        return L10n.tr(key: "AttributeTime")
      case .attributeWaterWeight:
        return L10n.tr(key: "AttributeWaterWeight")
      case .brewDetailsConfirmationNo:
        return L10n.tr(key: "BrewDetailsConfirmationNo")
      case .brewDetailsConfirmationTitle:
        return L10n.tr(key: "BrewDetailsConfirmationTitle")
      case .brewDetailsConfirmationYes:
        return L10n.tr(key: "BrewDetailsConfirmationYes")
      case .brewDetailScore:
        return L10n.tr(key: "BrewDetailScore")
      case .brewDetailsItemTitle:
        return L10n.tr(key: "BrewDetailsItemTitle")
      case .brewDetailsRemoveTitle:
        return L10n.tr(key: "BrewDetailsRemoveTitle")
      case .brewingsSortingDateAscending:
        return L10n.tr(key: "BrewingsSortingDateAscending")
      case .brewingsSortingDateDescending:
        return L10n.tr(key: "BrewingsSortingDateDescending")
      case .brewingsSortingScoreAscending:
        return L10n.tr(key: "BrewingsSortingScoreAscending")
      case .brewingsSortingScoreDescending:
        return L10n.tr(key: "BrewingsSortingScoreDescending")
      case .brewingsSortingSortTitle:
        return L10n.tr(key: "BrewingsSortingSortTitle")
      case .brewScoreDetailsItemTitle:
        return L10n.tr(key: "BrewScoreDetailsItemTitle")
      case .cuppingAttributeAcidity:
        return L10n.tr(key: "CuppingAttributeAcidity")
      case .cuppingAttributeAftertaste:
        return L10n.tr(key: "CuppingAttributeAftertaste")
      case .cuppingAttributeAroma:
        return L10n.tr(key: "CuppingAttributeAroma")
      case .cuppingAttributeBalance:
        return L10n.tr(key: "CuppingAttributeBalance")
      case .cuppingAttributeBody:
        return L10n.tr(key: "CuppingAttributeBody")
      case .cuppingAttributeOverall:
        return L10n.tr(key: "CuppingAttributeOverall")
      case .cuppingAttributeSweetness:
        return L10n.tr(key: "CuppingAttributeSweetness")
      case .grindSizeInformativeText:
        return L10n.tr(key: "GrindSizeInformativeText")
      case .grindSizeLevelCoarse:
        return L10n.tr(key: "GrindSizeLevelCoarse")
      case .grindSizeLevelExtraFine:
        return L10n.tr(key: "GrindSizeLevelExtraFine")
      case .grindSizeLevelFine:
        return L10n.tr(key: "GrindSizeLevelFine")
      case .grindSizeLevelMedium:
        return L10n.tr(key: "GrindSizeLevelMedium")
      case .grindSizeNumericButtonTitle:
        return L10n.tr(key: "GrindSizeNumericButtonTitle")
      case .grindSizeSliderButtonTitle:
        return L10n.tr(key: "GrindSizeSliderButtonTitle")
      case .historyEmptySetDescription:
        return L10n.tr(key: "HistoryEmptySetDescription")
      case .historyFilterPlaceholder:
        return L10n.tr(key: "HistoryFilterPlaceholder")
      case .historyItemTitle:
        return L10n.tr(key: "HistoryItemTitle")
      case .methodAeropress:
        return L10n.tr(key: "MethodAeropress")
      case .methodDetailChemex:
        return L10n.tr(key: "MethodDetailChemex")
      case .methodDetailInverted:
        return L10n.tr(key: "MethodDetailInverted")
      case .methodDetailTraditional:
        return L10n.tr(key: "MethodDetailTraditional")
      case .methodDetailV60:
        return L10n.tr(key: "MethodDetailV60")
      case .methodEsspressoMachine:
        return L10n.tr(key: "MethodEsspressoMachine")
      case .methodKalita:
        return L10n.tr(key: "MethodKalita")
      case .methodKone:
        return L10n.tr(key: "MethodKone")
      case .methodPickItemTitle:
        return L10n.tr(key: "MethodPickItemTitle")
      case .methodPourOver:
        return L10n.tr(key: "MethodPourOver")
      case .navigationDone:
        return L10n.tr(key: "NavigationDone")
      case .navigationEdit:
        return L10n.tr(key: "NavigationEdit")
      case .newBrewCoffeeInputPlaceholder:
        return L10n.tr(key: "NewBrewCoffeeInputPlaceholder")
      case .newBrewCoffeeMachinePlaceholder:
        return L10n.tr(key: "NewBrewCoffeeMachinePlaceholder")
      case .newBrewItemTitle:
        return L10n.tr(key: "NewBrewItemTitle")
      case .selectableSearchCoffeeItemTitle:
        return L10n.tr(key: "SelectableSearchCoffeeItemTitle")
      case .selectableSearchCoffeeMachineItemTitle:
        return L10n.tr(key: "SelectableSearchCoffeeMachineItemTitle")
      case .sequenceItemTitle:
        return L10n.tr(key: "SequenceItemTitle")
      case .settingsAboutMenuItemTitle:
        return L10n.tr(key: "SettingsAboutMenuItemTitle")
      case .settingsAboutThanksForTransaltion:
        return L10n.tr(key: "SettingsAboutThanksForTransaltion")
      case .settingsBrewingSequenceMenuDefaultSubtitle:
        return L10n.tr(key: "SettingsBrewingSequenceMenuDefaultSubtitle")
      case .settingsBrewingSequenceMenuItemTitle:
        return L10n.tr(key: "SettingsBrewingSequenceMenuItemTitle")
      case .settingsFeedbackMenuItemTitle:
        return L10n.tr(key: "SettingsFeedbackMenuItemTitle")
      case .settingsItemTitle:
        return L10n.tr(key: "SettingsItemTitle")
      case .settingsRateMenuItemTitle:
        return L10n.tr(key: "SettingsRateMenuItemTitle")
      case .settingsUnitsMenuItemTitle:
        return L10n.tr(key: "SettingsUnitsMenuItemTitle")
      case .startBrewingItemTitle:
        return L10n.tr(key: "StartBrewingItemTitle")
      case .tampingInformativeText:
        return L10n.tr(key: "TampingInformativeText")
      case .temperatureInformativeText:
        return L10n.tr(key: "TemperatureInformativeText")
      case .timeInformativeText:
        return L10n.tr(key: "TimeInformativeText")
      case .unitCategoryCoffee:
        return L10n.tr(key: "UnitCategoryCoffee")
      case .unitCategoryTemperature:
        return L10n.tr(key: "UnitCategoryTemperature")
      case .unitCategoryWater:
        return L10n.tr(key: "UnitCategoryWater")
      case .unitsItemTitle:
        return L10n.tr(key: "UnitsItemTitle")
      case .waterInformativeText:
        return L10n.tr(key: "WaterInformativeText")
      case .weightInformativeText:
        return L10n.tr(key: "WeightInformativeText")
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
