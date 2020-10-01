import Foundation

/**
 Write the given string to the specified FileHandle.

 - parameter str: native string to write encoded in utf-8.
 - parameter handle: FileHandle to write to (defaults to /dev/stdout)
 - parameter terminator: string to write after `str` (encoded in utf-8) (defaults to a single newline)
 */
private func writeString(_ str: String, handle: FileHandle = .standardOutput, terminator: String = "\n") {
    if let data = str.data(using: .utf8) {
        handle.write(data)
        if let terminatorData = terminator.data(using: .utf8) {
            handle.write(terminatorData)
        }
    }
}

func printOut(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let str = items.map { ($0 as AnyObject).description }.joined(separator: separator)
    writeString(str, handle: .standardOutput, terminator: terminator)
}

func printErr(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let str = items.map { ($0 as AnyObject).description }.joined(separator: separator)
    writeString(str, handle: .standardError, terminator: terminator)
}
