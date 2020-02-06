//
//  FavoriteService.swift
//
//  Copyright © 2020 Nikita Ermolenko. All rights reserved.
//

final class FavoriteService {

    enum NotificationName {
        static let favoritesListUpdated: Notification.Name = .init("favorites_list_updated")
    }
    static let shared: FavoriteService = .init()

    // MARK: - Private properties

    private var storageURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(".deboogger")
    }

    // MARK: - Public properties

    private var identifiers: Set<String> = .init() {
        didSet {
            saveIdentifiers()
        }
    }

    // MARK: - Lifecycle

    private init() {
        identifiers = loadIdentifiers()
    }

    // MARK: - Public methods

    func add(_ plugin: Plugin) {
        identifiers.insert(plugin.identifier)
        NotificationCenter.default.post(name: NotificationName.favoritesListUpdated, object: nil)
    }

    func remove(_ plugin: Plugin) {
        identifiers.remove(plugin.identifier)
        NotificationCenter.default.post(name: NotificationName.favoritesListUpdated, object: nil)
    }

    func isFavorite(_ plugin: Plugin) -> Bool {
        return identifiers.contains(plugin.identifier)
    }

    func fetchFavorite(_ plugins: [Plugin]) -> [Plugin] {
        return plugins.flatMap { plugin -> [Plugin] in
            var result = [Plugin]()
            if identifiers.contains(plugin.identifier) {
                result.append(plugin)
            }
            if let sectionPlugin = plugin as? SectionPlugin {
                result.append(contentsOf: fetchFavorite(sectionPlugin.plugins))
            }
            return result
        }
    }

    // MARK: - Private methods

    private func loadIdentifiers() -> Set<String> {
        guard let url = storageURL,
            let array = NSArray(contentsOf: url) as? [String] else {
            return []
        }
        return .init(array)
    }

    private func saveIdentifiers() {
        guard let url = storageURL else {
            return
        }
        (Array(identifiers) as NSArray).write(to: url, atomically: true)
    }
}
