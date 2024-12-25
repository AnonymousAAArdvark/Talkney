//
//  TalkneyApp.swift
//  Talkney
//
//  Created by Andrew Yang on 11/6/24.
//

import SwiftUI
import AVFoundation

@main
struct TalkneyApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.black.ignoresSafeArea())
        }
    }
}

// Move AppDelegate to the same file
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
}
