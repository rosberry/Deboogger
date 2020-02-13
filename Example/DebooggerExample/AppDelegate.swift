//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
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

        let sectionTree = [
            SectionPlugin(title: "Section 1", style: .nested, plugins: [
                SwitchTestPlugin(),
                SliderTestPlugin(),
                SectionPlugin(title: "Sub-Section 1", plugins: [
                    SectionPlugin(title: "Sub-Sub-Section 1", plugins: [
                        ButtonTestPlugin(),
                        SwitchTestPlugin()
                    ]),
                    SectionPlugin(title: "Sub-Sub-Section 2", plugins: [
                        ButtonTestPlugin(),
                        SwitchTestPlugin()
                    ]),
                    SectionPlugin(title: "Sub-Sub-Section 3", plugins: [
                        ButtonTestPlugin(),
                        SwitchTestPlugin()
                    ])
                ]),
                SectionPlugin(title: "Sub-Section 2", style: .nested, plugins: [
                    ButtonTestPlugin(),
                    SwitchTestPlugin()
                ])
            ]),
            SectionPlugin(title: "Section 2", plugins: [
                SegmentTestPlugin(),
                ButtonTestPlugin()
            ])
        ]

        if let window = window {
            Deboogger.configure(with: sectionTree, window: window)
        }

        return true
    }
}
