/// Copyright (c) 2018 Razeware LLC
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
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupRealm()
    return true
  }

  private func setupRealm() {
    SyncManager.shared.logLevel = .off

    if !TodoRealm.plain.fileExists && !TodoRealm.encrypted.fileExists {
      try! FileManager.default.copyItem(
        at: TodoRealm.bundle.url, to: TodoRealm.plain.url)
    }
  }
}

// MARK: - Enumeration of all Realm file locations on disk

enum TodoRealm {
  case bundle
  case plain
  case encrypted

  var url: URL {
    do {
      switch self {
      case .bundle: return try Path.inBundle("bundled.realm")
      case .plain: return try Path.inDocuments("mytodo.realm")
      case .encrypted: return try Path.inDocuments("mytodoenc.realm")
      }
    } catch let err {
      fatalError("Failed finding expected path: \(err)")
    }
  }

  var fileExists: Bool {
    return FileManager.default.fileExists(atPath: path)
  }

  var path: String {
    return url.path
  }
}
