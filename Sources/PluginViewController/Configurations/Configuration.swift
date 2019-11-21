//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

protocol ConfigurationDelegate: class {
    func configuration(_ sender: Configuration, didRequest childConfiguration: Configuration, withTitle title: String?)
}

protocol Configuration: UITableViewDataSource, UITableViewDelegate {

    var delegate: ConfigurationDelegate? { get set }

    var tableView: UITableView? { get set }
    func configure() 
}
