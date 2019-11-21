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
            Section(title: "Section 1", style: .nested, plugins: [
                SwitchTestPlugin(),
                SliderTestPlugin(),
                Section(title: "Sub-Section 1", plugins: [
                    Section(title: "Sub-Sub-Section 1", plugins: [
                        ButtonTestPlugin(),
                        SwitchTestPlugin()
                    ]),
                    Section(title: "Sub-Sub-Section 2", plugins: [
                        ButtonTestPlugin(),
                        SwitchTestPlugin()
                    ]),
                    Section(title: "Sub-Sub-Section 3", plugins: [
                        ButtonTestPlugin(),
                        SwitchTestPlugin()
                    ])
                ]),
                Section(title: "Sub-Section 2", style: .nested, plugins: [
                    ButtonTestPlugin(),
                    SwitchTestPlugin()
                ])
            ]),
            Section(title: "Section 2", plugins: [
                SegmentTestPlugin(),
                ButtonTestPlugin()
            ])
        ]

        Deboogger.configure(with: sectionTree)

        return true
    }
}
