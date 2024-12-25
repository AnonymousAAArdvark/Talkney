//
//  WordDefinitionAVPiPView.swift
//  Talkney
//
//  Created by Andrew Yang on 12/25/24.
//

import UIKit
import PIPKit
import AVFoundation

final class WordDefinitionAVPiPView: UIView, AVPIPUIKitUsable {
    
    // MARK: - AVPIPUIKitUsable
    var pipTargetView: UIView { self }
    var renderPolicy: AVPIPKitRenderPolicy { .preferredFramesPerSecond(30) }
    
    private var currentPipSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    
    var pipSize: CGSize {
        currentPipSize
    }
    
    override var intrinsicContentSize: CGSize {
        pipSize
    }
    
    // MARK: - UI: Logo, Labels (No Buttons)
    private let logo = UIImageView(image: UIImage(named: "Logo"))
    private let titleStack = UIStackView()
    private let titleLabel = UILabel()
    private let translationLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let cornerRadius: CGFloat = 16
    
    // MARK: - Audio / Speech
//    private let recognizer = WordDefinitionSpeechRecognizer()
    private(set) var isInPiPMode = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSpeechRecognition()
        startMicCapture() // Default: start capturing microphone
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupSpeechRecognition()
        startMicCapture()
    }
    
    private func setupUI() {
        backgroundColor = .black
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        // Logo
        logo.contentMode = .scaleAspectFit
        addSubview(logo)
        
        // Title stack
        titleStack.axis = .horizontal
        titleStack.spacing = 4
        titleStack.alignment = .center
        titleStack.distribution = .fill
        addSubview(titleStack)
        
        // Title label
        titleLabel.text = "Listening..."
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleStack.addArrangedSubview(titleLabel)
        
        // Translation label
        translationLabel.text = ""
        translationLabel.textColor = .gray
        translationLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        translationLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        translationLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleStack.addArrangedSubview(translationLabel)
        
        // Subtitle label
        subtitleLabel.text = "Waiting..."
        subtitleLabel.textColor = .white.withAlphaComponent(0.7)
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.numberOfLines = 1
        addSubview(subtitleLabel)
    }
    
    private func setupSpeechRecognition() {
//        recognizer.onWordCaptured = { [weak self] word in
//            print("onWordCaptured: \(word)")
//            self?.titleLabel.text = word
//        }
//        
//        recognizer.onError = { [weak self] error in
//            self?.subtitleLabel.text = "Error: \(error.localizedDescription)"
//            
//            // Only auto-restart for non-permission errors
//            switch error {
//            case .permissionDenied, .restricted, .notDetermined:
//                // Don't auto-restart for permission issues
//                break
//            default:
//                // Automatically try to restart after a delay
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    self?.startMicCapture()
//                }
//            }
//        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        let currentHeight = pipSize.height
        let deviceWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 10
        let logoSize: CGFloat = isInPiPMode ? 30 : 40 // Smaller logo in PiP mode

        // Logo position and size
        logo.frame = CGRect(x: padding, y: padding, width: logoSize, height: logoSize)

        // Title stack position and size
        let stackX = logo.frame.maxX + padding
        let stackY = padding
        let stackWidth = deviceWidth - stackX - padding
        let stackHeight: CGFloat = currentHeight > 50 ? 24 : 16 // Adjust stack height for PiP mode
        titleStack.frame = CGRect(x: stackX, y: stackY, width: stackWidth, height: stackHeight)

        // Subtitle label position and size
        let subtitleY = stackY + stackHeight + 5
        subtitleLabel.frame = CGRect(x: stackX, y: subtitleY, width: stackWidth, height: 20)
    }
    
    // MARK: - PiP
    func startPiP() {
        guard !isInPiPMode else { return }
        isInPiPMode = true
        currentPipSize = CGSize(width: UIScreen.main.bounds.width * 2.5, height: 100) // Smaller height for PiP mode
        stopPictureInPicture() // Stop PiP to reconfigure size
        startPictureInPicture() // Restart PiP with the updated size
    }

    
    func stopPiP() {
        guard isInPiPMode else { return }
        isInPiPMode = false
        currentPipSize = CGSize(width: UIScreen.main.bounds.width, height: 100) // Normal size
        stopPictureInPicture() // Stop PiP to reconfigure size
        startPictureInPicture() // Restart PiP with the updated size
    }
    
    // MARK: - Audio Session Methods
    
    /// Switches to microphone capture (speech recognition).
    func startMicCapture() {
//        recognizer.startRecognition()
        subtitleLabel.text = "Capturing microphone..."
    }
    
    /// Switches to device audio playback (no mic).
    func startDeviceAudio() {
//        recognizer.stopRecognition()
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.record, mode: .default, options: [])
            try audioSession.setActive(true)
            subtitleLabel.text = "Device audio playback..."
        } catch {
            subtitleLabel.text = "Failed .playback session"
            print("Error setting session: \(error)")
        }
    }
    
    deinit {
//        recognizer.stopRecognition()
    }
}
