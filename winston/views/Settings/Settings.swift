//
//  Settings.swift
//  winston
//
//  Created by Igor Marcossi on 24/06/23.
//

import SwiftUI
import Defaults
//import SceneKit

enum SettingsPages {
  case behavior, appearance, account, about, commentSwipe, postSwipe, accessibility, faq
}

struct Settings: View {
  var reset: Bool
  @Environment(\.openURL) private var openURL
  @StateObject private var router = Router()
  @Default(.likedButNotSubbed) var likedButNotSubbed
  var body: some View {
    NavigationStack(path: $router.path) {
      VStack {
        List {
          
          Section {
            NavigationLink(value: SettingsPages.behavior) {
              Label("Behavior", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
            }
            NavigationLink(value: SettingsPages.appearance) {
              Label("Appearance", systemImage: "theatermask.and.paintbrush.fill")
            }
            NavigationLink(value: SettingsPages.account) {
              Label("Account", systemImage: "person.crop.circle")
            }
//            NavigationLink(value: SettingsPages.accessibility) {
//              Label("Accessibility", systemImage: "figure.roll")
//            }
            
          }
          
          Section {
            NavigationLink(value: SettingsPages.faq){
              Label("FAQ", systemImage: "exclamationmark.questionmark")
            }
            NavigationLink(value: SettingsPages.about) {
              Label("About", systemImage: "cup.and.saucer.fill")
            }
            Button {
              sendCustomEmail()
            } label: {
              Label("Report a bug", systemImage: "ladybug.fill")
            }
            Button {
              openURL(URL(string: "https://patreon.com/user?u=93745105")!)
            } label: {
              Label("Support our work!", systemImage: "heart.fill")
            }
            Button{
              likedButNotSubbed = []
            } label: {
              Label("Clear local likes", systemImage: "trash")
            }
            
          }
        }
      }
      .navigationDestination(for: SettingsPages.self) { x in
        Group {
          switch x {
          case .behavior:
            BehaviorPanel()
          case .appearance:
            AppearancePanel()
          case .account:
            AccountPanel()
          case .about:
            AboutPanel()
          case .commentSwipe:
            CommentSwipePanel()
          case .postSwipe:
            PostSwipePanel()
          case .accessibility:
            AccessibilityPanel()
          case .faq:
            FAQPanel()
          }
        }
        .environmentObject(router)
      }
      .navigationTitle("Settings")
      .environmentObject(router)
      .onChange(of: reset) { _ in router.path.removeLast(router.path.count) }
      .animation(.default, value: router.path)
    }
  }
}

//struct Settings_Previews: PreviewProvider {
//  static var previews: some View {
//    Settings()
//  }
//}
