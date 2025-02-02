//
//  hideToggle.swift
//  winston
//
//  Created by Igor Marcossi on 14/08/23.
//

import Foundation
import Alamofire

private let queue = DispatchQueue(label: "lo.cafe.winston.hide.timer", attributes: .initiallyInactive)

private class HideDebouncer {
  static var shared = HideDebouncer()
  var workItem: DispatchWorkItem? = nil
  var names: [String] = []
}

extension RedditAPI {
  func hidePost(_ hide: Bool, fullnames: [String]) async -> () {
    if !HideDebouncer.shared.workItem.isNil {
      HideDebouncer.shared.workItem?.cancel()
      HideDebouncer.shared.workItem = nil
    }
    HideDebouncer.shared.names += fullnames
    HideDebouncer.shared.workItem = DispatchWorkItem {
      HideDebouncer.shared.workItem = nil
      let names = HideDebouncer.shared.names
      HideDebouncer.shared.names.removeAll()
      Task(priority: .background) {
        await self.refreshToken()
        if let headers = self.getRequestHeaders() {
          let params = HidePayload(id: names.joined(separator: ","))
          let dataTask = AF.request(
            "\(RedditAPI.redditApiURLBase)/api/\(hide ? "" : "un")hide",
            method: .post,
            parameters: params,
            encoder: URLEncodedFormParameterEncoder(destination: .httpBody),
            headers: headers
          ).serializingString()
          let result = await dataTask.result
          switch result {
          case .success:
//            print("foi")
            //          return true
            break
          case .failure:
            //        print(error)
            //          return nil
            break
          }
        } else {
          //        return nil
        }
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: HideDebouncer.shared.workItem!) // delay of 5 seconds
  }
  
  struct HidePayload: Codable {
    let id: String
  }
}
