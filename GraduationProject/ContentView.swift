//
//  ContentView.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI

import SwiftUI
import Lottie

struct ContentView: View {
    @State var playbackMode = LottiePlaybackMode.pause
    
    var body: some View {
        VStack {
            LottieView(animation: .named("animation_lmvrqr49"))
                .play(playbackMode)
            
            Button {
                playbackMode = .fromProgress(0, toProgress: 1, loopMode: .playOnce)
            } label: {
                Image(systemName: "play.fill")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
