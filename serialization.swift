private func inferColumns(_ dictionaries: [[String: String]]) -> [String] {
    let keySet = dictionaries.reduce(Set<String>()) { keys, dictionary in
        keys.union(dictionary.keys)
    }
    return Array(keySet)
}

func formatTable(_ dictionaries: [[String: String]], keys: [String]? = nil) -> String {
    let columns = keys ?? inferColumns(dictionaries)
    // generate header row
    let header = columns.joined(separator: "\t")
    // reduce other dictionaries into single array
    let rows = dictionaries.reduce([header]) { rows, dictionary in
        let cells: [String] = columns.map { dictionary[$0] ?? "" }
        let row = cells.joined(separator: "\t")
        return rows + [row]
    }
    return rows.joined(separator: "\n")
}

func formatKVTable(_ dictionary: [String: String]) -> String {
    let keyWidth = dictionary.keys.map { $0.count }.max() ?? 0
    let lines = dictionary.map { entry in
        "\(entry.key.padding(toLength: keyWidth, withPad: " ", startingAt: 0)): \(entry.value)"
    }
    return lines.joined(separator: "\n")
}
