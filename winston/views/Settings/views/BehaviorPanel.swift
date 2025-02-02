//
//  Behavior.swift
//  winston
//
//  Created by Igor Marcossi on 05/07/23.
//

import SwiftUI
import Defaults

struct BehaviorPanel: View {
  @Default(.maxPostLinkImageHeightPercentage) var maxPostLinkImageHeightPercentage
  @Default(.openYoutubeApp) var openYoutubeApp
  @Default(.preferenceDefaultFeed) var preferenceDefaultFeed
  @Default(.preferredSort) var preferredSort
  @Default(.preferredCommentSort) var preferredCommentSort
  @Default(.blurPostLinkNSFW) var blurPostLinkNSFW
  @Default(.blurPostNSFW) var blurPostNSFW
  @Default(.collapseAutoModerator) var collapseAutoModerator
  @Default(.readPostOnScroll) var readPostOnScroll
  @Default(.hideReadPosts) var hideReadPosts
  @Default(.enableSwipeAnywhere) var enableSwipeAnywhere
  @Default(.autoPlayVideos) var autoPlayVideos
  
  var body: some View {
    List {
      
      Section("General") {
        Toggle("Open Youtube videos externally", isOn: $openYoutubeApp)
        
        Picker("Default Launch Feed", selection: $preferenceDefaultFeed) {
          Text("Home").tag("home")
          Text("Popular").tag("popular")
          Text("All").tag("all")
          
          Text("Subscription List").tag("subList")
        }
        .pickerStyle(DefaultPickerStyle())
      }
      
      Section {
        Toggle("Enable swipe anywhere", isOn: $enableSwipeAnywhere)
      } footer: {
        Text("This will allow you to do swipe actions in any screen, but will disable post and comments swipe gestures.")
      }
      
      Section("Posts") {
        NavigationLink("Posts swipe settings", value: SettingsPages.postSwipe)
        Toggle("Autoplay videos (muted)", isOn: $autoPlayVideos)
        Toggle("Read posts on scroll", isOn: $readPostOnScroll)
        Toggle("Hide read posts", isOn: $hideReadPosts)
        Toggle("Blur NSFW in opened posts", isOn: $blurPostNSFW)
        Toggle("Blur NSFW in posts links", isOn: $blurPostLinkNSFW)
        Picker("Posts sorting", selection: $preferredSort) {
          ForEach(SubListingSortOption.allCases, id: \.self) { val in
            Label(val.rawVal.id.capitalized, systemImage: val.rawVal.icon)
          }
        }
        VStack(alignment: .leading) {
          HStack {
            Text("Max posts image height")
            Spacer()
            Text(maxPostLinkImageHeightPercentage == 110 ? "Original" : "\(Int(maxPostLinkImageHeightPercentage))%")
              .opacity(0.6)
          }
          Slider(value: $maxPostLinkImageHeightPercentage, in: 10...110, step: 10)
        }
      }
      
      Section("Comments") {
        NavigationLink("Comments swipe settings", value: SettingsPages.commentSwipe)
        Picker("Comments sorting", selection: $preferredCommentSort) {
          ForEach(CommentSortOption.allCases, id: \.self) { val in
            Label(val.rawVal.id.capitalized, systemImage: val.rawVal.icon)
          }
        }
        
        Toggle("Collapse AutoModerator comments", isOn: $collapseAutoModerator)
      }
      
    }
    .navigationTitle("Behavior")
    .navigationBarTitleDisplayMode(.inline)
  }
}
//
//struct Behavior_Previews: PreviewProvider {
//    static var previews: some View {
//        Behavior()
//    }
//}
