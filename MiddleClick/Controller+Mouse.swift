import CoreGraphics
import Foundation
import CoreFoundation

extension Controller {
  private static let state = GlobalState.shared

  static let mouseEventHandler = CGEventController {
    _, type, event, _ in

    let returnedEvent = Unmanaged.passUnretained(event)
    guard !AppUtils.isIgnoredAppBundle() else { return returnedEvent }

    if state.threeDown && (type == .leftMouseDown || type == .rightMouseDown) {
      state.wasThreeDown = true
      state.threeDown = false
      state.naturalMiddleClickLastTime = Date()
      state.clickAction.rewrite(event, isDown: true)
    }

    if state.wasThreeDown && (type == .leftMouseUp || type == .rightMouseUp) {
      state.wasThreeDown = false
      state.clickAction.rewrite(event, isDown: false)
    }
    return returnedEvent
  }
}
