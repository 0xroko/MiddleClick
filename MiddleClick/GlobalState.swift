import Foundation

@MainActor
final class GlobalState {
  static let shared = GlobalState()
  private init() {
    Config.shared.$ignoredAppBundles.onSet {
      self.ignoredAppBundlesCache = $0
    }
    Config.shared.$tapActionRawValue.onSet {
      self.tapAction = ClickAction(stored: $0)
    }
    Config.shared.$clickActionRawValue.onSet {
      self.clickAction = ClickAction(stored: $0)
    }
  }

  var threeDown = false
  var wasThreeDown = false
  var naturalMiddleClickLastTime: Date?
  /// stored locally, since accessing the cache is more CPU-expensive than a local variable
  var ignoredAppBundlesCache = Config.shared.ignoredAppBundles
  var tapAction = ClickAction(stored: Config.shared.tapActionRawValue)
  var clickAction = ClickAction(stored: Config.shared.clickActionRawValue)
}
