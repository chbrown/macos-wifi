import CoreWLAN
import Foundation

// CLI helpers

private func basename(_ pathOption: String?) -> String? {
    if let path = pathOption {
        return URL(fileURLWithPath: path).lastPathComponent
    }
    return nil
}

private func printUsage() {
    let process = basename(CommandLine.arguments.first) ?? "executable"
    printErr("""
    Usage: \(process) -h|-help|--help
           \(process) -action interfaces|current|scan
           \(process) # same as: -action current
           \(process) -action associate -bssid bssid [-password password]
    """)
}

// CLI entry point

func main() {
    // CommandLine.arguments[0] is the path of the executed file, which we drop
    let args = Array(CommandLine.arguments.dropFirst())
    // handle boolean arguments separately since UserDefaults only processes '-key value' pairs
    if (args.contains { arg in arg == "-h" || arg == "-help" || arg == "--help" }) {
        printUsage()
        exit(0)
    }
    // use UserDefaults to parse other command line arguments
    let defaults = UserDefaults.standard

    let action = defaults.string(forKey: "action") ?? "current"
    let format = Format(rawValue: defaults.string(forKey: "format") ?? "tty") ?? .tty

    let client = CWWiFiClient.shared()
    let interface = client.interface()!

    switch action {
    case "interfaces":
        let names: [String] = CWWiFiClient.interfaceNames() ?? []
        try! serialize(names) // format: .json not supported for interface names
    case "current":
        var result = interfaceDictionary(interface)
        // timestamp with floating point seconds since epoch
        result["Timestamp"] = Date().timeIntervalSince1970
        try! serialize(result, format: format)
    case "scan":
        let networks = try! interface.scanForNetworks(withSSID: nil)
        let networkDictionaries = networks.map(networkDictionary)
        try! serialize(networkDictionaries, format: format)
    case "associate":
        if let bssid = defaults.string(forKey: "bssid") {
            let networks = try! interface.scanForNetworks(withSSID: nil)
            printErr("Associating with bssid:", bssid)
            if let targetNetwork = networks.first(where: { $0.bssid == bssid }) {
                let password = defaults.string(forKey: "password")
                try! interface.associate(to: targetNetwork, password: password)
            } else {
                printErr("No network matching bssid found!")
            }
        } else {
            printErr("The 'associate' action requires supplying a -bssid value")
            printUsage()
            exit(1)
        }
    default:
        printErr("Unrecognized action: \(action)")
        printUsage()
        exit(1)
    }
}

main()
