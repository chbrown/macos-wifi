import Foundation
/**
 Most Core WLAN members are prefixed with "CW"

 The `*Labels` mappings below come from one of:
 {/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer,
  /Library/Developer/CommandLineTools}
  /SDKs/MacOSX.sdk/System/Library/Frameworks/CoreWLAN.framework/Versions/A/Headers/CoreWLANTypes.h
 */
import CoreWLAN

/**
 Mapping from all CWChannelBand values to string representation.
 */
let ChannelBandLabels: [CWChannelBand: String] = [
    .bandUnknown: "Unknown", // 0
    .band2GHz: "2GHz", // 1
    .band5GHz: "5GHz", // 2
]

/**
 Mapping from all CWChannelWidth values to string representation.
 */
let ChannelWidthLabels: [CWChannelWidth: String] = [
    .widthUnknown: "Unknown", // 0
    .width20MHz: "20MHz", // 1
    .width40MHz: "40MHz", // 2
    .width80MHz: "80MHz", // 3
    .width160MHz: "160MHz", // 4
]

/**
 Mapping from all CWPHYMode (IEEE 802.11 physical layer mode) values to string representation.
 */
let PHYModeLabels: [CWPHYMode: String] = [
    .modeNone: "", // 0
    .mode11a: "802.11a", // 1
    .mode11b: "802.11b", // 2
    .mode11g: "802.11g", // 3
    .mode11n: "802.11n", // 4
    .mode11ac: "802.11ac", // 5
]

/**
 Mapping from all CWInterfaceMode (Wi-Fi interface operating modes) values to string representation.
 */
let InterfaceModeLabels: [CWInterfaceMode: String] = [
  /** Not in any mode */
  .none: "None", // 0
  /** Participating in an infrastructure network as a non-AP station */
  .station: "Station", // 1
  /** Participating in an IBSS network */
  .IBSS: "IBSS", // 2
  /** Participating in an infrastructure network as an access point */
  .hostAP: "HostAP", // 3
]

/**
 Mapping from all CWSecurity (security types) values to string representation.
 */
let SecurityLabels: [CWSecurity: String] = [
  /** No authentication required */
  .none: "None", // 0
  /** WEP security */
  .WEP: "WEP", // 1
  /** WPA personal authentication */
  .wpaPersonal: "WPAPersonal", // 2
  /** WPA/WPA2 personal authentication */
  .wpaPersonalMixed: "WPAPersonalMixed", // 3
  /** WPA2 personal authentication */
  .wpa2Personal: "WPA2Personal", // 4
  .personal: "Personal", // 5
  /** Dynamic WEP security */
  .dynamicWEP: "DynamicWEP", // 6
  /** WPA enterprise authentication */
  .wpaEnterprise: "WPAEnterprise", // 7
  /** WPA/WPA2 enterprise authentication */
  .wpaEnterpriseMixed: "WPAEnterpriseMixed", // 8
  /** WPA2 enterprise authentication */
  .wpa2Enterprise: "WPA2Enterprise", // 9
  .enterprise: "Enterprise", // 10
  /** WPA3 Personal authentication */
  .wpa3Personal: "WPA3Personal", // 11
  /** WPA3 Enterprise authentication */
  .wpa3Enterprise: "WPA3Enterprise", // 12
  /** WPA3 Transition (WPA3/WPA2 Personal) authentication */
  .wpa3Transition: "WPA3Transition", // 13
  /** Unknown security type */
  .unknown: "Unknown", // Int.max
]
