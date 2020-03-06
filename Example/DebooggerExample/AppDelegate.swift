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

        let sectionTree = [
            SectionPlugin(title: "Content", style: .nested, plugins: [
                SwitchTestPlugin(title: .init(string: "Drop connection")),
                SliderTestPlugin(title: .init(string: "Response delay")),
                SectionPlugin(title: "Profile", plugins: [
                    SectionPlugin(title: "Authentication", plugins: [
                        ButtonTestPlugin(title: .init(string: "Expire the token")),
                        SwitchTestPlugin(title: .init(string: "Is admin"))
                    ]),
                    SectionPlugin(title: "Avatar", plugins: [
                        ButtonTestPlugin(title: .init(string: "Remove the photo")),
                        SwitchTestPlugin(title: .init(string: "Is visible"))
                    ]),
                    SectionPlugin(title: "Socials", plugins: [
                        ButtonTestPlugin(title: .init(string: "Unlink facebook")),
                        ButtonTestPlugin(title: .init(string: "Unlink twitter")),
                    ])
                ]),
                SectionPlugin(title: "Bookmarks", style: .nested, plugins: [
                    ButtonTestPlugin(title: .init(string: "Remove all bookmarks")),
                    SwitchTestPlugin(title: .init(string: "Fail bookmark request"))
                ])
            ]),
            SectionPlugin(title: "System", plugins: [
                SegmentTestPlugin(title: .init(string: "Region")),
                ButtonTestPlugin(title: .init(string: "Reset stored properties"))
            ])
        ]

        if let window = window {
            Deboogger.configure(with: sectionTree, window: window)
        }

        return true
    }
}
