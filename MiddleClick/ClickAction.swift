import CoreGraphics

/// What an N-finger tap or click is turned into.
enum ClickAction: String, CaseIterable {
  case middle
  case shiftMiddle
  case command
  case commandShift

  var title: String {
    switch self {
    case .middle: "Middle Click"
    case .shiftMiddle: "⇧ Middle Click"
    case .command: "⌘ Click"
    case .commandShift: "⌘⇧ Click"
    }
  }

  init(stored: String) {
    self = Self(rawValue: stored) ?? .middle
  }

  private var button: CGMouseButton {
    switch self {
    case .middle, .shiftMiddle: .center
    case .command, .commandShift: .left
    }
  }

  private var flags: CGEventFlags {
    switch self {
    case .middle: []
    case .shiftMiddle: .maskShift
    case .command: .maskCommand
    case .commandShift: [.maskCommand, .maskShift]
    }
  }

  func rewrite(_ event: CGEvent, isDown: Bool) {
    event.type = eventType(isDown: isDown)
    event.setIntegerValueField(.mouseEventButtonNumber, value: Int64(button.rawValue))
    event.flags.formUnion(flags)
  }

  func post(at location: CGPoint) {
    for isDown in [true, false] {
      guard let event = CGEvent(
        mouseEventSource: nil, mouseType: eventType(isDown: isDown),
        mouseCursorPosition: location, mouseButton: button
      ) else { continue }
      event.flags.formUnion(flags)
      event.post(tap: .cghidEventTap)
    }
  }

  private func eventType(isDown: Bool) -> CGEventType {
    switch (button, isDown) {
    case (.left, true): .leftMouseDown
    case (.left, false): .leftMouseUp
    case (_, true): .otherMouseDown
    case (_, false): .otherMouseUp
    }
  }
}
