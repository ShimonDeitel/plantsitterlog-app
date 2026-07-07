import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [PlantSitterLogItem] = []
    @Published var isPro: Bool = false

    /// Free tier limit. Kept comfortably above seed count so a fresh install
    /// never immediately hits the paywall.
    static let freeLimit = 6

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("plantsitterlog_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: PlantSitterLogItem) {
        items.append(item)
        save()
    }

    func update(_ item: PlantSitterLogItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: PlantSitterLogItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func seedIfNeeded() -> [PlantSitterLogItem] {
        [
            PlantSitterLogItem(name: "Monstera", detail: "Living Room", extra: 7, date: Date()),
            PlantSitterLogItem(name: "Pothos", detail: "Office", extra: 10, date: Date()),
            PlantSitterLogItem(name: "Snake Plant", detail: "Bedroom", extra: 21, date: Date())
        ]
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([PlantSitterLogItem].self, from: data) else {
            items = seedIfNeeded()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
