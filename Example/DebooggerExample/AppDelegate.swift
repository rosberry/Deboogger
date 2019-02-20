//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit
import Deboogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Deboogger.configure(with:
//            SwitchTestPlugin(),
//            SliderTestPlugin(),
//            SegmentTestPlugin(),
//            ButtonTestPlugin()
//        )

        Deboogger.configure(with:
            Section(title: "Section 1", plugins: SwitchTestPlugin(), SliderTestPlugin()),
            Section(title: "Section 2", plugins: SegmentTestPlugin(), ButtonTestPlugin())
        )

        return true
    }
}
