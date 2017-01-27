#Host.swift is no longer maintained

Please use Hostess.swift: https://github.com/rjstelling/Hostess.swift 

[![Host.swift](https://github.com/rjstelling/Host.swift/blob/master/Resources/Hero.png)](#)

[![Swift](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](#)
[![Platform](https://img.shields.io/badge/Platform-iOS, macOS & tvOS-lightgrey.svg?style=flat)](#)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/rjstelling/Host.swift/blob/master/LICENSE)

A Swift implementation of NSHost that works on iOS, OS X and tvOS. 

Host.swift is safe to use in a framework because it does not require a bridging header.

##Motivation

Host.swift was created because NSHost is unavailable on iOS and CFHost does not offer the full functionality of it OS X counterpart.
  					
In addition, those developers hoping for a pure-Swift solution were out of luck without using a bridging header.
  					
Host.swift does not use a bridging header, so is safe to use in Framework development. It is 100% Swift and tries to maintain as much type safety as the low level networking C API will allow.

## Example

``` swift
let host = Host()
let deviceIP = host.addresses.first
print("IP: \(deviceIP)") // Will print a dot-separated IP address, e.g: 17.24.2.55
```
