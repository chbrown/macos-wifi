# MacOS Wi-Fi (CoreWLAN) tools

Pure Swift CLI to access the [`CoreWLAN`](https://developer.apple.com/documentation/corewlan) API in macOS.


## Installation

    make install


## Usage

* `wifi -action interfaces`

  List the available Wi-Fi interfaces in the system.

* `wifi -action current [-format json|tty]` (or simply `wifi`, since `current` is the default action)

  Print connection information for the default Wi-Fi interface.
  
* `wifi -action scan [-format json|tty]`

  Scan for available Wi-Fi networks.

* `wifi -action associate -bssid bssid [-password password]`

  Associate with the Wi-Fi network with the given BSSID.
  (Or attempt to do so; it doesn't seem to work reliably.)


* parameter `-format json|tty` (default to `tty`) available for the actions `scan` or `current`
  - `wifi -action current -format json`
  - `wifi -action scan -format json`
    
  Example usage: you can print a list of available SSID in plain format with [`jq`](https://github.com/stedolan/jq) with this command:
  
  `wifi -action scan -format json | jq '.SSID' -r`




## License

Copyright © 2018–2020 Christopher Brown.
[MIT Licensed](https://chbrown.github.io/licenses/MIT/#2018-2020).
