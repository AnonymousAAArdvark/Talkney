//
//  WordDefinitionAVPiPRepresentable.swift
//  Talkney
//
//  Created by Andrew Yang on 12/25/24.
//


//
//  WordDefinitionAVPiPRepresentable.swift
//  Talkney
//
//  Created by Andrew Yang on 12/25/24.
//

import SwiftUI
import PIPKit

/// SwiftUI wrapper to embed WordDefinitionAVPiPView
struct WordDefinitionAVPiPRepresentable: UIViewRepresentable {
    let pipView = WordDefinitionAVPiPView()
    
    func makeUIView(context: Context) -> WordDefinitionAVPiPView {
        pipView
    }
    
    func updateUIView(_ uiView: WordDefinitionAVPiPView, context: Context) {
        // If you need to update dynamic data, do it here
    }
}
