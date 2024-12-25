//
//  HomeTabView.swift
//  Talkney
//
//  Created by Andrew Yang on 11/10/24.
//

import SwiftUI
import PIPKit

struct HomeTabView: View {
    // Create an instance of our SwiftUI-bridged PiP view
    @State private var pipRepresentable = WordDefinitionAVPiPRepresentable()
    
    @State private var capturingMicrophone = true

    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Show the PiP content as a normal SwiftUI subview (for demonstration).
                // You could also hide it and only show it in PiP, if desired.
                pipRepresentable
                    .frame(width: 200, height: 120)
                    .background(Color.gray.opacity(0.2))
                
                // Button to start PiP
                Button(action: {
                    pipRepresentable.pipView.startPictureInPicture()
                }) {
                    Text("Start AV PiP")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                // Button to stop PiP
                Button(action: {
                    pipRepresentable.pipView.stopPictureInPicture()
                }) {
                    Text("Stop AV PiP")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                
                // Audio Toggle
                Button(capturingMicrophone ? "Switch to Device Audio" : "Switch to Microphone") {
                    capturingMicrophone.toggle()
                    if capturingMicrophone {
                        pipRepresentable.pipView.startMicCapture()
                    } else {
                        pipRepresentable.pipView.startDeviceAudio()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}
