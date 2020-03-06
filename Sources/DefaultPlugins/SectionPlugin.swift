//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use `SectionPlugin` instead")
public typealias Section = SectionPlugin

public final class SectionPlugin: NavigationPlugin {

    public let title: NSAttributedString
    public var plugins: [Plugin]
    public let style: NavigationStyle

    public init(title: String = .init(), style: NavigationStyle = .plain, plugins: [Plugin]) {
        self.title = NSAttributedString(string: title)
        self.plugins = plugins
        self.style = style
    }

    public convenience init(title: String, style: NavigationStyle = .plain, plugins: Plugin...) {
        self.init(title: title, style: style, plugins: plugins)
    }
}
