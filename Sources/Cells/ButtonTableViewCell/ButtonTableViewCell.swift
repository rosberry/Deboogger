//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

final class ButtonTableViewCell: BaseTextTableViewCell {

    private enum Animation {
        static let duration: TimeInterval = 0.1
    }

    private var plugin: ButtonPlugin?
    
    @IBOutlet weak var activateButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        activateButton.backgroundColor = UIColor.blue
        activateButton.layer.shadowColor = UIColor.black.cgColor
        activateButton.layer.shadowRadius = 7.0
        activateButton.layer.shadowOpacity = 0.6
        activateButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        activateButton.layer.cornerRadius = 3
    }
    
    func configure(by plugin: ButtonPlugin) {
        super.configure(by: plugin)
        self.plugin = plugin
    }

    // MARK: - Actions

    @IBAction func touchDownEvent(_ button: UIButton) {
        animateShadowOpacity(to: 0.0)
        animateTransform(to: button.transform.scaledBy(x: 0.8, y: 0.8))
    }
    
    @IBAction func touchUpInsideEvent(_ button: UIButton) {
        plugin?.buttonPressed(button)
        animateShadowOpacity(to: 0.6)
        animateTransform(to: .identity)
    }

    @IBAction func touchCancelEvent(_ button: UIButton) {
        animateShadowOpacity(to: 0.6)
        animateTransform(to: .identity)
    }

    @IBAction func touchDrawOutsideEvent(_ button: UIButton) {
        animateShadowOpacity(to: 0.6)
        animateTransform(to: .identity)
    }

    // MARK: - Helpers

    private func animateShadowOpacity(to value: CGFloat) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
        animation.toValue = value
        animation.duration = Animation.duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        activateButton.layer.add(animation, forKey: nil)
    }

    private func animateTransform(to transform: CGAffineTransform) {
        UIView.animate(withDuration: Animation.duration) {
            self.activateButton.transform = transform
        }
    }
}
