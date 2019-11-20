//
//  SliderPlugin.swift
//  Deboogger
//
//  Created by Nikita Ermolenko on 08/12/2017.
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import ObjectiveC

public protocol SliderPlugin: TextPlugin {
    var minValue: Float { get }
    var maxValue: Float { get }
    var initialValue: Float { get }
    var sliderTitle: String { get }

    func sliderValueChanged(_ slider: UISlider)
}

private var associatedCurrentValue = "currentValue"

public extension SliderPlugin {

    var cellClass: BaseTableViewCell.Type {
        return SliderTableViewCell.self
    }

    var minValue: Float {
        return 0.0
    }

    var initialValue: Float {
        return 0.0
    }

    private var _currentValue: Float? {
        get {
            return objc_getAssociatedObject(self, &associatedCurrentValue) as? Float
        }
        set {
            objc_setAssociatedObject(self, &associatedCurrentValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal(set) var currentValue: Float {
        get {
            return _currentValue ?? initialValue
        }
        set {
            _currentValue = newValue
        }
    }

    var sliderTitle: String {
        return "\(currentValue) / \(maxValue)"
    }
}
