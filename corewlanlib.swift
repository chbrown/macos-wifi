import CoreWLAN
import Foundation

/**
 CWChannel instances have these properties:

 - NSInteger channelNumber
 - CWChannelWidth channelWidth
 - CWChannelBand channelBand
 */
func channelDictionary(_ channel: CWChannel) -> [String: Any] {
    return [
        "ChannelNumber": channel.channelNumber,
        "ChannelBand": channelBandLabels[channel.channelBand]!,
        "ChannelWidth": channelWidthLabels[channel.channelWidth]!,
    ]
}

func optionalChannelDictionary(_ channel: CWChannel?) -> [String: Any]? {
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
func networkDictionary(_ network: CWNetwork) -> [String: Any?] {
    return [
        "SSID": network.ssid,
        // "SSIDData": network.ssidData,
        "BSSID": network.bssid,
        "RSSI": network.rssiValue,
        "Noise": network.noiseMeasurement,
        // "InformationElement": network.informationElementData,
        "Country": network.countryCode,
        "BeaconInterval": network.beaconInterval,
        "IBSS": network.ibss,
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
func interfaceDictionary(_ interface: CWInterface) -> [String: Any?] {
    return [
        "PowerOn": interface.powerOn(),
        // "SupportedChannels": interface.supportedWLANChannels()!,
        "ActivePHYMode": phyModeLabels[interface.activePHYMode()]!,
        "SSID": interface.ssid(),
        // "SSIDData": interface.ssidData,
        "BSSID": interface.bssid(),
        "RSSI": interface.rssiValue(),
        "Noise": interface.noiseMeasurement(),
        "Security": securityLabels[interface.security()]!,
        "TransmitRate": interface.transmitRate(),
        "Country": interface.countryCode(),
        "InterfaceMode": interfaceModeLabels[interface.interfaceMode()]!,
        "TransmitPower": interface.transmitPower(),
        "HardwareAddress": interface.hardwareAddress(),
        "ServiceActive": interface.serviceActive(),
        // "Configuration": interface.configuration(),
    ].merging(optionalChannelDictionary(interface.wlanChannel()) ?? [:]) { _, new in new }
}
