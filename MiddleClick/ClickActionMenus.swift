import AppKit

@MainActor final class ClickActionMenus: NSObject {
  private let config = Config.shared
  private let tapMenu = NSMenu()
  private let clickMenu = NSMenu()

  func install(in menu: NSMenu) {
    populate(tapMenu, action: #selector(selectTapAction))
    populate(clickMenu, action: #selector(selectClickAction))

    menu.addSeparator()
    menu.addItem(withTitle: "Tap sends").submenu = tapMenu
    menu.addItem(withTitle: "Click sends").submenu = clickMenu
    updateCheckmarks()
  }

  private func populate(_ menu: NSMenu, action: Selector) {
    for clickAction in ClickAction.allCases {
      menu.addItem(withTitle: clickAction.title, action: action, target: self)
        .representedObject = clickAction
    }
  }

  private func updateCheckmarks() {
    tapMenu.checkItem(representing: ClickAction(stored: config.tapActionRawValue))
    clickMenu.checkItem(representing: ClickAction(stored: config.clickActionRawValue))
  }

  @objc private func selectTapAction(sender: NSMenuItem) {
    guard let clickAction = sender.representedObject as? ClickAction else { return }
    config.tapActionRawValue = clickAction.rawValue
    updateCheckmarks()
  }

  @objc private func selectClickAction(sender: NSMenuItem) {
    guard let clickAction = sender.representedObject as? ClickAction else { return }
    config.clickActionRawValue = clickAction.rawValue
    updateCheckmarks()
  }
}

private extension NSMenu {
  func checkItem(representing clickAction: ClickAction) {
    for item in items {
      item.state = item.representedObject as? ClickAction == clickAction ? .on : .off
    }
  }
}
