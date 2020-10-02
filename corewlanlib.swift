import CoreWLAN
import Foundation

/**
 CWChannel instances have these properties:

 - NSInteger channelNumber
 - CWChannelWidth channelWidth
 - CWChannelBand channelBand
 */
func channelDictionary(_ channel: CWChannel) -> [String: String] {
    return [
        "ChannelNumber": channel.channelNumber.description,
        "ChannelBand": channelBandLabels[channel.channelBand]!,
        "ChannelWidth": channelWidthLabels[channel.channelWidth]!,
    ]
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
        "SSID": network.ssid ?? "N/A",
        // "SSIDData": String(data: network.ssidData ?? Data(), encoding: .ascii) ?? "N/A",
        "BSSID": network.bssid ?? "N/A",
        "RSSI": network.rssiValue.description,
        "Noise": network.noiseMeasurement.description,
        // "InformationElement": (network.informationElementData ?? Data()).base64EncodedString(),
        "Country": network.countryCode ?? "N/A",
        "BeaconInterval": network.beaconInterval.description,
        "IBSS": network.ibss.description,
    ].merging(channelDictionary(network.wlanChannel!)) { _, new in new }
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
        "PowerOn": interface.powerOn().description,
        // "SupportedChannels": interface.supportedWLANChannels()!.description,
        "ActivePHYMode": phyModeLabels[interface.activePHYMode()]!,
        "SSID": interface.ssid() ?? "N/A",
        // "SSIDData": interface.ssidData,
        "BSSID": interface.bssid() ?? "N/A",
        "RSSI": interface.rssiValue().description,
        "Noise": interface.noiseMeasurement().description,
        "Security": securityLabels[interface.security()]!,
        "TransmitRate": interface.transmitRate().description,
        "Country": interface.countryCode() ?? "N/A",
        "InterfaceMode": interfaceModeLabels[interface.interfaceMode()]!,
        "TransmitPower": interface.transmitPower().description,
        "HardwareAddress": interface.hardwareAddress() ?? "N/A",
        "ServiceActive": interface.serviceActive().description,
        // "Configuration": interface.configuration(),
    ].merging(optionalChannelDictionary(interface.wlanChannel()) ?? [:]) { _, new in new }
}
