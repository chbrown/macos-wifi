import Foundation

// set the rawValue type to String to facilitate parsing strings to the corresponding enum value
enum Format: String {
    case json
    case tty
}

private let newline = Data([0x0A])

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

/**
 Serialize value and write to handle.

 - parameter value: any object to serialize
 - parameter format: format to use for output
 - parameter handle: file to write data to
 - throws: if value cannot be serialized as specified
 */
func serialize(_ value: Any, format: Format = .tty, handle: FileHandle = .standardOutput) throws {
    switch format {
    case .json:
        let values: [Any] = value as? [Any] ?? [value]
        for value in values {
            // Nb.: Swift's JSON encoders only support arrays / dictionary at the top level
            let jsonData = try JSONSerialization.data(withJSONObject: value)
            handle.write(jsonData)
            // terminate with newline
            handle.write(newline)
        }
    case .tty:
        if let dictionary = value as? [String: String] {
            printLine(formatKVTable(dictionary), handle: handle)
        } else if let dictionaries = value as? [[String: String]] {
            printLine(formatTable(dictionaries), handle: handle)
        } else if let array = value as? [String] {
            for item in array {
                printLine(item, handle: handle)
            }
        } else {
            printLine((value as AnyObject).description, handle: handle)
        }
    }
}
