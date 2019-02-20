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

    private var tapHandler: TapHandler
    private var touchBeganTime: TimeInterval?
    
    deinit {
        stopTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    init(tapHandler: @escaping TapHandler) {
        self.tapHandler = tapHandler
        let size = Layout.size
        
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
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
            window?.frame = frame
        }
        else {
            window?.frame.origin.x = UIScreen.main.bounds.width - Layout.size
            window?.frame.origin.y = UIScreen.main.bounds.height / 2.0 - Layout.size / 2.0
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
    
     private func buttonPressed() {
        if isMoving {
            return
        }
        stopTimer()
        startTimer()
        tapHandler()
    }

    // MARK: - Helpers

    private func saveButtonPosition() {
        storage?.currentButtonFrame = window?.frame
    }

    private func removeOffset() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.window?.negativeOffsets.isEmpty == true {
                self.window?.smallestOffset.remove()
            }
            else {
                self.window?.negativeOffsets.forEach { offset in
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

// MARK: - Touches

extension AssistiveButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBeganTime = event?.timestamp

        guard let touch = touches.first else {
            return
        }
        
        stopTimer()
        beginPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else {
            return
        }
        
        let currentPosition = touch.location(in: self)
        let offsetX = currentPosition.x - beginPoint.x
        let offsetY = currentPosition.y - beginPoint.y
        
        window?.center.x += offsetX
        window?.center.y += offsetY
        
        isMoving = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let beganTime = touchBeganTime, let endTime = event?.timestamp, endTime - beganTime < 0.2 {
            tapHandler()
            removeOffset()
        }
        else {
            removeOffset()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        removeOffset()
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
