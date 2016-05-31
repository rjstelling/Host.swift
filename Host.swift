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
    
    private func getHostname() -> String? {
        
        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0x0)
        
        guard gethostname(&hostname, Int(NI_MAXHOST)) == noErr else {
            return nil
        }
        
        return String(CString: hostname, encoding: NSUTF8StringEncoding)
    }
    
    private func getAddresses() -> [String] {
        
        var addresses: [String] = []
        
        guard let hostname = self.name else {
            return []
        }
        
        let host = CFHostCreateWithName(kCFAllocatorDefault, hostname).takeUnretainedValue()
        
        // Resolve all addresses
        guard CFHostStartInfoResolution(host, .Addresses, nil) else {
            return []
        }
        
        var resolved: DarwinBoolean = false
        if let sockaddrs = CFHostGetAddressing(host, &resolved)?.takeRetainedValue() {
            
            let count = CFArrayGetCount(sockaddrs)
            
            for i in 0..<count {
                
                let data = unsafeBitCast(CFArrayGetValueAtIndex(sockaddrs, i), NSData.self)
                
                var storage = sockaddr_storage()
                data.getBytes(&storage, length: sizeof(sockaddr_storage))
                
                if Int32(storage.ss_family) == AF_INET {
                    let addrIP4 = withUnsafePointer(&storage) { UnsafePointer<sockaddr_in>($0).memory }
                    
                    if let address = String(CString: inet_ntoa(addrIP4.sin_addr), encoding: NSUTF8StringEncoding) {
                        addresses.append(address)
                    }
                }
            }
        }
        
        return addresses
    }
}