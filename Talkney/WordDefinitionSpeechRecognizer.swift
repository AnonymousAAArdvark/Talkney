//
//  WordDefinitionSpeechRecognizer.swift
//  Talkney
//
//  Created by Andrew Yang on 12/25/24.
//

import Foundation
import Speech
import AVFoundation

enum SpeechRecognizerError: Error {
    case permissionDenied
    case restricted
    case notDetermined
    case recognizerUnavailable
    case configError(Error)
    case engineStartError(Error)
    case unknownError(Error)
}

class WordDefinitionSpeechRecognizer {
    
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    // Callbacks
    var onWordCaptured: ((String) -> Void)?
    var onError: ((SpeechRecognizerError) -> Void)?

    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    }

    func startRecognition() {
        // 1) Check for permission if needed, or assume it’s granted
        // 2) Configure the audio session
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .default, options: .mixWithOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            onError?(.configError(error))
            return
        }

        // 3) Create recognition request
        let request = SFSpeechAudioBufferRecognitionRequest()
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            onError?(.recognizerUnavailable)
            return
        }

        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let error = error {
                self?.onError?(.unknownError(error))
                self?.stopRecognition()
                return
            }
            guard let result = result else { return }
            // Partial or final result
            if result.isFinal {
                let bestString = result.bestTranscription.formattedString
                self?.onWordCaptured?(bestString)
            } else {
                // If you want partial results:
                let bestString = result.bestTranscription.formattedString
                self?.onWordCaptured?(bestString)
            }
        }

        // 4) Install a tap on the audio engine’s input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            request.append(buffer)
        }

        // 5) Start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            onError?(.engineStartError(error))
        }
    }

    func stopRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
