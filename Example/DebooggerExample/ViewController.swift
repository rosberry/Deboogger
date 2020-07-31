//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit
import Deboogger

class ViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed

        let names: [NSNotification.Name] = [.DebooggerWillShow,
                                            .DebooggerDidShow,
                                            .DebooggerWillHide,
                                            .DebooggerDidHide]
        for name in names {
            NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notification in
                print(notification.name)
            }
        }       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
}

