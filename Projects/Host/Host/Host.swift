//
//  Host.swift
//
//  Created by Richard Stelling on 20/05/2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Richard Stelling (@rjstelling)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

// TODO:    - IPv6 Support
//          - WAN Address

@available(iOS 9.3, OSX 10.11, *)
final public class Host {
    
    /// Host name if available
    public var name: String? {
        return getHostname()
    }
    
    /// Unordered list of IPv4 addresses
    public var addresses: [String] {
        return getAddresses()
    }
    
    public init() {
        
    }
    
    private func getHostname() -> String? {
        
        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0x0)
        
        guard gethostname(&hostname, Int(NI_MAXHOST)) == noErr else {
            return nil
        }
        
        return String(CString: hostname, encoding: NSUTF8StringEncoding)
    }
    
    private func getAddresses() -> [String] {
        
        var addresses: [String] = []
        var interfaces = UnsafeMutablePointer<ifaddrs>(nil)
        
        // Use `getifaddrs()` to fill the ifaddrs struct, this is a linked list
        guard getifaddrs(&interfaces) == 0 else {
            return []
        }
        
        // Our first address was returned above
        var currentInterface: ifaddrs! = interfaces.memory
        
        repeat {
            
            let addressInfo = unsafeBitCast(currentInterface.ifa_addr.memory, sockaddr_in.self)
            
            if let ipAddress = String(CString: inet_ntoa(addressInfo.sin_addr), encoding: NSUTF8StringEncoding) where Int(addressInfo.sin_family) == Int(AF_INET) {
                addresses.append(ipAddress)
            }
            
            if currentInterface.ifa_next != nil {
                currentInterface = currentInterface.ifa_next.memory
            }
            else {
                currentInterface = nil
            }
            
        } while currentInterface != nil
        
        return addresses
    }
}