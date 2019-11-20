//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation

public final class Section {

    public enum Style {
        case plain
        case nested
    }

    let title: String
    let plugins: [Plugin]
    let style: Style

    public init(title: String, style: Style = .plain, plugins: [Plugin]) {
        self.title = title
        self.plugins = plugins
        self.style = style
    }

    public convenience init(title: String, style: Style = .plain, plugins: Plugin...) {
        self.init(title: title, style: style, plugins: plugins)
    }
}
