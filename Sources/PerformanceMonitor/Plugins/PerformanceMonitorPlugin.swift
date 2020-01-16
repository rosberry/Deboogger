//
//  Copyright © 2019 Rosberry. All rights reserved.
//

final class PerformanceMonitorPlugin: SwitchPlugin {

    var isOn: Bool {
        UserDefaults.standard.isPerformanceMonitorEnabled
    }

    let title: NSAttributedString = .init(string: "Performance monitor")

    init() {
        Deboogger.shared.shouldShowPerformanceMonitor = isOn
    }

    func switchStateChanged(_ sender: UISwitch) {
        UserDefaults.standard.isPerformanceMonitorEnabled = sender.isOn
        Deboogger.shared.updatePerformanceMonitor(hidden: sender.isOn == false)
    }
}

private extension UserDefaults {

    var isPerformanceMonitorEnabled: Bool {
        get {
            bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
