import Foundation
import CoreWLAN

// CLI helpers

private func basename(_ pathOption: String?) -> String? {
  if let path = pathOption {
    return URL(fileURLWithPath: path).lastPathComponent
  }
  return nil
}

private func printUsage() {
  let process = basename(CommandLine.arguments.first) ?? "executable"
  printErr("Usage: \(process) [-h|--help] -action interfaces|current|scan|associate [-bssid bssid] [-password password]")
}

// CLI actions

func interfaces() {
  printErr("Available interfaces:")
  for interfaceName in CWWiFiClient.interfaceNames() ?? [] {
    printOut(interfaceName)
  }
}

func current(_ interface: CWInterface) {
  printErr("Current interface:")
  printOut(formatKVTable(interfaceDictionary(interface)))
}

func scan(_ interface: CWInterface) throws {
  printErr("Available networks:")
  let networks = try interface.scanForNetworks(withSSID: nil)
  let networkDictionaries = networks.map(networkDictionary)
  let keys = [
    "SSID", "BSSID",
    "ChannelNumber", "ChannelBand", "ChannelWidth",
    "RSSI",
    "Noise",
    // "InformationElement",
    // "BeaconInterval",
    // "IBSS",
    "Country",
  ]
  printOut(formatTable(Array(networkDictionaries), keys: keys))
}

func associate(_ interface: CWInterface, bssid: String, password: String?) throws {
  let networks = try interface.scanForNetworks(withSSID: nil)
  printErr("Associating with bssid:", bssid)
  if let targetNetwork = networks.first(where: {$0.bssid == bssid}) {
    try interface.associate(to: targetNetwork, password: password)
  } else {
    printErr("No network matching bssid found!")
  }
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

  let client = CWWiFiClient.shared()
  let interface = client.interface()!

  switch action {
  case "interfaces":
    interfaces()
  case "current":
    current(interface)
  case "scan":
    try! scan(interface)
  case "associate":
    if let bssid = defaults.string(forKey: "bssid") {
      let password = defaults.string(forKey: "password")
      try! associate(interface, bssid: bssid, password: password)
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
