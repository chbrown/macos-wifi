import Foundation
/** Most Core WLAN members are prefixed with "CW" */
import CoreWLAN

let ChannelBandLabels: [CWChannelBand: String] = [
    .bandUnknown: "Unknown", // 0
    .band2GHz:       "2GHz", // 1
    .band5GHz:       "5GHz", // 2
]

let ChannelWidthLabels: [CWChannelWidth: String] = [
    .widthUnknown: "Unknown", // 0
    .width20MHz:     "20MHz", // 1
    .width40MHz:     "40MHz", // 2
    .width80MHz:     "80MHz", // 3
    .width160MHz:   "160MHz", // 4
]

/** IEEE 802.11 physical layer mode */
let PHYModeLabels: [CWPHYMode: String] = [
    .modeNone:         "", // 0
    .mode11a:   "802.11a", // 1
    .mode11b:   "802.11b", // 2
    .mode11g:   "802.11g", // 3
    .mode11n:   "802.11n", // 4
    .mode11ac: "802.11ac", // 5
]

/** Wi-Fi interface operating modes returned by CWInterface#interfaceMode() */
let InterfaceModeLabels: [CWInterfaceMode: String] = [
  /** Not in any mode */
  .none:       "None", // 0
  /** Participating in an infrastructure network as a non-AP station */
  .station: "Station", // 1
  /** Participating in an IBSS network */
  .IBSS:       "IBSS", // 2
  /** Participating in an infrastructure network as an access point */
  .hostAP:   "HostAP", // 3
]

/** Labels describing the IEEE 802.11 physical layer mode */
let SecurityLabels: [CWSecurity: String] = [
  /** No authentication required */
  .none:               "None",               // 0
  /** WEP security */
  .WEP:                "WEP",                // 1
  /** WPA personal authentication */
  .wpaPersonal:        "WPAPersonal",        // 2
  /** WPA/WPA2 personal authentication */
  .wpaPersonalMixed:   "WPAPersonalMixed",   // 3
  /** WPA2 personal authentication */
  .wpa2Personal:       "WPA2Personal",       // 4
  .personal:           "Personal",           // 5
  /** Dynamic WEP security */
  .dynamicWEP:         "DynamicWEP",         // 6
  /** WPA enterprise authentication */
  .wpaEnterprise:      "WPAEnterprise",      // 7
  /** WPA/WPA2 enterprise authentication */
  .wpaEnterpriseMixed: "WPAEnterpriseMixed", // 8
  /** WPA2 enterprise authentication */
  .wpa2Enterprise:     "WPA2Enterprise",     // 9
  .enterprise:         "Enterprise",         // 10
  /** Unknown security type */
  .unknown:            "Unknown",            // Int.max
]

/**
 CWChannel instances have these properties:

 - NSInteger channelNumber
 - CWChannelWidth channelWidth
 - CWChannelBand channelBand
*/
func channelDictionary(_ channel: CWChannel) -> [String: String] {
  return [
    "ChannelNumber": channel.channelNumber.description,
    "ChannelBand":   ChannelBandLabels[channel.channelBand]!,
    "ChannelWidth":  ChannelWidthLabels[channel.channelWidth]!]
}
func optionalChannelDictionary(_ channel: CWChannel?) -> [String: String]? {
  if let channelValue = channel {
    return channelDictionary(channelValue)
  } else {
    return nil
  }
}

/**
 CWNetwork has instance properties:

 - NSString? *ssid
 - NSData? *ssidData
 - NSString? *bssid
 - CWChannel *wlanChannel
 - NSInteger rssiValue
 - NSInteger noiseMeasurement
 - NSData? *informationElementData
 - NSString? *countryCode
 - NSInteger beaconInterval
 - BOOL ibss
 */
func networkDictionary(_ network: CWNetwork) -> [String: String] {
  return [
    "SSID":               network.ssid ?? "N/A",
    "SSIDData":           String(data: network.ssidData ?? Data(), encoding: .ascii) ?? "N/A",
    "BSSID":              network.bssid ?? "N/A",
    "RSSI":               network.rssiValue.description,
    "Noise":              network.noiseMeasurement.description,
    "InformationElement": (network.informationElementData ?? Data()).base64EncodedString(),
    "Country":            network.countryCode ?? "N/A",
    "BeaconInterval":     network.beaconInterval.description,
    "IBSS":               network.ibss.description,
  ].merging(optionalChannelDictionary(network.wlanChannel) ?? [:]) { _, new in new }
}

/**
 CWInterface has instance methods rather than properties:

 - powerOn()               -> BOOL
 - supportedWLANChannels() -> NSSet<CWChannel>?
 - wlanChannel()           -> CWChannel?
 - activePHYMode()         -> CWPHYMode
 - ssid()                  -> NSString?
 - ssidData()              -> NSData?
 - bssid()                 -> NSString?
 - rssiValue()             -> NSInteger
 - noiseMeasurement()      -> NSInteger
 - security()              -> CWSecurity
 - transmitRate()          -> double
 - countryCode()           -> NSString?
 - interfaceMode()         -> CWInterfaceMode
 - transmitPower()         -> NSInteger
 - hardwareAddress()       -> NSString?
 - serviceActive()         -> BOOL
 - cachedScanResults()     -> NSSet<CWNetwork>?
 - configuration()         -> CWConfiguration?
*/
func interfaceDictionary(_ interface: CWInterface) -> [String: String] {
  return [
    "PowerOn":            interface.powerOn().description,
    //"SupportedChannels":  interface.supportedWLANChannels()!.description,
    "ActivePHYMode":      PHYModeLabels[interface.activePHYMode()]!,
    "SSID":               interface.ssid() ?? "N/A",
    // "SSIDData":           interface.ssidData,
    "BSSID":              interface.bssid() ?? "N/A",
    "RSSI":               interface.rssiValue().description,
    "Noise":              interface.noiseMeasurement().description,
    "Security":           SecurityLabels[interface.security()]!,
    "TransmitRate":       interface.transmitRate().description,
    "Country":            interface.countryCode() ?? "N/A",
    "InterfaceMode":      InterfaceModeLabels[interface.interfaceMode()]!,
    "TransmitPower":      interface.transmitPower().description,
    "HardwareAddress":    interface.hardwareAddress() ?? "N/A",
    "ServiceActive":      interface.serviceActive().description,
    // "Configuration":      interface.configuration(),
  ].merging(optionalChannelDictionary(interface.wlanChannel()) ?? [:]) { _, new in new }
}
