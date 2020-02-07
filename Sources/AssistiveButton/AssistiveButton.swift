//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

final class AssistiveButton: UIButton {
    
    enum Layout {
        static let size: CGFloat = 50
    }

    typealias TapHandler = () -> Void

    private var isMoving = false
    private var beginPoint = CGPoint.zero
    private var opacityTimer: Timer?
    private let storage = UserDefaults(suiteName: "deboogger")

    private lazy var movingPanGestureRecognizer: UIPanGestureRecognizer = .init(target: self,
                                                                                action: #selector(panRecognizerHandler))

    private var tapHandler: TapHandler

    override var canBecomeFirstResponder: Bool {
        true
    }

    override var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return superview?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: UIKeyCommand.inputUpArrow,
                             modifierFlags: .command,
                             action: #selector(hardwareShortcutPressed),
                             discoverabilityTitle: "Open deboogger")]
    }
    
    deinit {
        stopTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    init(tapHandler: @escaping TapHandler) {
        self.tapHandler = tapHandler
        let size = Layout.size
        
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))

        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        addGestureRecognizer(movingPanGestureRecognizer)
        
        setTitle("🛠", for: .normal)
        
        layer.cornerRadius = size / 2
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor.black.withAlphaComponent(0.2)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        if let frame = storage?.currentButtonFrame {
            self.frame = frame
        }
        else {
            frame.origin.x = UIScreen.main.bounds.width - Layout.size
            frame.origin.y = UIScreen.main.bounds.height / 2.0 - Layout.size / 2.0
        }
        startTimer()
    }
    
    @objc private func orientationChanged() {
        removeOffset()
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        opacityTimer?.invalidate()
        opacityTimer = nil
        opacityTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(update), userInfo: nil, repeats: false)
    }
    
    @objc private func update() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.3
        }
    }
    
    private func stopTimer() {
        alpha = 1.0
        
        opacityTimer?.invalidate()
        opacityTimer = nil
    }
    
    // MARK: - Actions
    
     @objc private func buttonPressed() {
        if isMoving {
            return
        }
        stopTimer()
        startTimer()
        tapHandler()
    }

    @objc private func hardwareShortcutPressed() {
        tapHandler()
    }

    @objc private func panRecognizerHandler(_ recognizer: UIPanGestureRecognizer) {
        let view = recognizer.view
        switch recognizer.state {
            case .began:
                stopTimer()
                beginPoint = recognizer.location(in: view)
            case .changed:
                recognizer.setTranslation(.zero, in: view)
                let point = recognizer.location(in: view)

                let offsetX = point.x - beginPoint.x
                let offsetY = point.y - beginPoint.y

                center.x += offsetX
                center.y += offsetY
                isMoving = true
            case .ended, .failed, .cancelled:
                removeOffset()
            default:
                return
        }
    }

    // MARK: - Helpers

    private func saveButtonPosition() {
        storage?.currentButtonFrame = frame
    }

    private func removeOffset() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.negativeOffsets.isEmpty == true {
                self.smallestOffset.remove()
            }
            else {
                self.negativeOffsets.forEach { offset in
                    offset.remove()
                }
            }
        }, completion: { _ in
            self.isMoving = false
            self.saveButtonPosition()
            self.startTimer()
        })
    }
}

private extension UserDefaults {

    var currentButtonFrame: CGRect? {
        get {
            if let stringRect = string(forKey: #function) {
                return NSCoder.cgRect(for: stringRect)
            }
            return nil
        }
        set {
            if let value = newValue {
                let stringRect = NSCoder.string(for: value)
                setValue(stringRect, forKey: #function)
            }
            else {
                removeObject(forKey: #function)
            }
        }
    }
}
