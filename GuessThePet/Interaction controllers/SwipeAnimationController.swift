///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

final class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
  var interactionInProgress = false
  private var shouldCompletedTransition = false
  private weak var viewController: UIViewController?
  
  init(viewController: UIViewController!) {
    super.init()
    self.viewController = viewController
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handle(_:)))
    gesture.edges = .left
    viewController.view.addGestureRecognizer(gesture)
  }
  
  @objc private func handle(_ gesture: UIScreenEdgePanGestureRecognizer) {
    guard let superview = gesture.view?.superview else { return }
    let translation = gesture.translation(in: superview)
    var progress = translation.x / 200
    progress = CGFloat(fminf(fmaxf(Float(progress), 0), 1))
    
    switch gesture.state {
    case .began:
      interactionInProgress = true
      viewController?.dismiss(animated: true)
    case .changed:
      shouldCompletedTransition = progress > 0.5
      update(progress)
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      shouldCompletedTransition ? finish() : cancel()
    default: break
    }
  }
}
