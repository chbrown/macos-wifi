import Foundation

// set the rawValue type to String to facilitate parsing strings to the corresponding enum value
enum Format: String {
    case json
    case tty
}

private let newline = Data([0x0A])

func formatValue(_ value: Any?, nilValue: String = "N/A") -> String {
    if let nonNilValue = value {
        return String(describing: nonNilValue)
    }
    return nilValue
}

private func inferColumns(_ dictionaries: [[String: Any?]]) -> [String] {
    let keySet = dictionaries.reduce(Set<String>()) { keys, dictionary in
        keys.union(dictionary.keys)
    }
    return Array(keySet)
}

func formatTable(_ dictionaries: [[String: Any?]], keys: [String]? = nil) -> String {
    let columns = keys ?? inferColumns(dictionaries)
    // generate header row
    let header = columns.joined(separator: "\t")
    // reduce other dictionaries into single array
    let rows = dictionaries.reduce([header]) { rows, dictionary in
        let cells: [String] = columns.map { formatValue(dictionary[$0] ?? nil) }
        let row = cells.joined(separator: "\t")
        return rows + [row]
    }
    return rows.joined(separator: "\n")
}

func formatKVTable(_ dictionary: [String: Any?]) -> String {
    let keyWidth = dictionary.keys.map { $0.count }.max() ?? 0
    let lines = dictionary.map { entry in
        "\(entry.key.padding(toLength: keyWidth, withPad: " ", startingAt: 0)): \(formatValue(entry.value))"
    }
    return lines.joined(separator: "\n")
}

/**
 Serialize a single value to compact JSON representation.

 - parameter obj: any object to serialize
 - throws: if value cannot be serialized as JSON
*/
private func serializeToJSON(_ obj: Any) throws -> Data {
    if #available(macOS 10.13, *) {
        return try JSONSerialization.data(withJSONObject: obj, options: .sortedKeys)
    } else {
        return try JSONSerialization.data(withJSONObject: obj)
    }
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
            let jsonData = try serializeToJSON(value)
            handle.write(jsonData)
            // terminate with newline
            handle.write(newline)
        }
    case .tty:
        if let dictionary = value as? [String: Any?] {
            printLine(formatKVTable(dictionary), handle: handle)
        } else if let dictionaries = value as? [[String: Any?]] {
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
