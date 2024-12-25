//
//  AppDelegate.swift
//  Talkney
//
//  Created by Andrew Yang on 11/25/24.
//


import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAudioSession()
        return true
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, 
                                  mode: .moviePlayback,
                                  options: [.mixWithOthers, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // Add these application lifecycle methods
    func applicationDidEnterBackground(_ application: UIApplication) {
        do {
            let session = AVAudioSession.sharedInstance()
            // Reactivate audio session when entering background
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to reactivate audio session: \(error)")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        do {
            let session = AVAudioSession.sharedInstance()
            // Ensure audio session is active when returning to foreground
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to reactivate audio session: \(error)")
        }
    }
}
