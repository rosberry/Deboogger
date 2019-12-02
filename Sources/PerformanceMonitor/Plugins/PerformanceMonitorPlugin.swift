//
//  Copyright © 2019 Rosberry. All rights reserved.
//

final class PerformanceMonitorPlugin: SwitchPlugin {

    var isOn: Bool {
        get {
            UserDefaults.standard.isPerformanceMonitorEnabled
        }
        set {
            UserDefaults.standard.isPerformanceMonitorEnabled = newValue
        }
    }

    let title: NSAttributedString = .init(string: "Performance monitor")

    func switchStateChanged(_ sender: UISwitch) {
        isOn = sender.isOn
    }
}

extension UserDefaults {

    var isPerformanceMonitorEnabled: Bool {
        get {
            bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
