//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import Deboogger

final class SliderTestPlugin: SliderPlugin {

    let initialValue: Float = 50

    let minValue: Float = 10

    let maxValue: Float = 105

    var sliderTitle: String {
        return "\(Int(currentValue)) / \(Int(maxValue))"
    }

    let title: NSAttributedString

    init(title: NSAttributedString) {
        self.title = title
    }

    func sliderValueChanged(_ slider: UISlider) {
        print(currentValue)
    }
}
