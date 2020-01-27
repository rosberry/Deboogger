//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

struct PluginItem {
    let title: String?
    let plugin: Plugin
    let children: [PluginItem]

    var isFavorite: Bool = false
}
