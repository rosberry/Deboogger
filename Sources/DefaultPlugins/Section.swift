//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

public final class Section: NavigationPlugin {

    public let title: NSAttributedString
    public let plugins: [Plugin]
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
