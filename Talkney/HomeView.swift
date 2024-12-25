//
//  HomeView.swift
//  Talkney
//
//  Created by Andrew Yang on 11/10/24.
//

import SwiftUI
import AVKit
import Foundation

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        ZStack {
            TabView {
                VStack {
                    Spacer()
                    
                    HomeTabView()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                MyWordsView()
                    .tabItem {
                        Image(systemName: "bookmark.fill")
                        Text("Saved")
                    }

                ExploreView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Explore")
                    }

                OptionsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Options")
                    }
            }
            .accentColor(Color.white)
            .background(Color.black)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MyWordsView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("My Words")
                .foregroundColor(.white)
                .font(.largeTitle)
        }
    }
}

struct ExploreView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("Explore")
                .foregroundColor(.white)
                .font(.largeTitle)
        }
    }
}

struct OptionsView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("Options")
                .foregroundColor(.white)
                .font(.largeTitle)
        }
    }
}

#Preview {
    HomeView()
}
