//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

final class SegmentTableViewCell: BaseTextTableViewCell {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    private var plugin: SegmentPlugin?
    
    func configure(by plugin: SegmentPlugin) {
        super.configure(by: plugin)
        self.plugin = plugin
        
        segmentControl.removeAllSegments()        
        plugin.items.enumerated().forEach { offset, item in
            segmentControl.insertSegment(withTitle: item, at: offset, animated: false)
            segmentControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10, weight: .light)],
                                                  for: .normal)
        }
        segmentControl.selectedSegmentIndex = Int(plugin.initialSelectedIndex)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        plugin?.segmentValueChanged(sender)
    }
}
