import Foundation
import SystemConfiguration

let NetworkChangedNotificationKey = "NetworkChangedNotificationKey"
let NetworkChangedNotificationNetworkTypeKey = "NetworkChangedNotificationNetworkTypeKey"
let NetworkChangedNotificationNetworkStatusKey = "NetworkChangedNotificationNetworkStatusKey"

public enum NetworkType: CustomStringConvertible {
    case wifi
    case wwan
    case none
    
    public var description: String {
        switch self {
        case .wifi: return "WiFi"
        case .wwan: return "Cellular"
        case .none: return "None"
        }
    }
}

public enum NetworkStatus: CustomStringConvertible  {
    case online
    case offline
    case unknown
    
    public var description: String {
        switch self {
        case .online: return "Online"
        case .offline: return "Offline"
        case .unknown: return "Unknown"
        }
    }
}

public struct Network {

    /// Is the device current online
    ///
    /// - Returns: True if device is online, otherwise false
    func isOnline() -> Bool {
        let state = connectionInfo()
        return state.0 == NetworkStatus.online
    }

    /// Is the device currently on WiFi
    ///
    /// - Returns: True if device is using WiFi, otherwise false
    func isWiFi() -> Bool {
        let state = connectionInfo()
        return state.1 == NetworkType.wifi
    }
    
    /// Parse the network reachability flags
    ///
    /// - Parameter flags: reachability flags
    /// - Returns: Tuple (NetworkStatus, NetworkType)
    private static func parseFlags(reachabilityFlags flags: SCNetworkReachabilityFlags) -> (NetworkStatus, NetworkType) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)

        let networkType = isWWAN ? NetworkType.wwan : NetworkType.wifi
        
        if !connectionRequired && isReachable {
            return (NetworkStatus.online, networkType)
        }

        return (NetworkStatus.offline, networkType)
    }
    
    /// Obtain the current device connection information
    ///
    /// - Returns: Tuple (NetworkStatus, NetworkType)
    public func connectionInfo() -> (NetworkStatus, NetworkType) {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return (.unknown, .none)
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return (.unknown, .none)
        }
        
        return Network.parseFlags(reachabilityFlags: flags)
    }
    
    /// Monitor network reachability to a hostname
    ///
    /// - Parameter host: String with hostname to monitor
    public func monitorReachabilityChanges(host: String) {
        var scContext = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)

        let scReachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(scReachability, { (_, flags, _) in
            let state = Network.parseFlags(reachabilityFlags: flags)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NetworkChangedNotificationKey),
                                            object: nil,
                                            userInfo: [
                                                NetworkChangedNotificationNetworkStatusKey: state.0.description,
                                                NetworkChangedNotificationNetworkTypeKey: state.1.description
                                            ])

        }, &scContext)
        
        SCNetworkReachabilityScheduleWithRunLoop(scReachability, CFRunLoopGetMain(), RunLoopMode.commonModes as CFString)
    }

    /// Monitor network reachability to an IP address
    ///
    /// - Parameter address: [Int] with IPV4 or IPV6 address to monitor
    public func monitorReachabilityChanges(address: [Int]) {
        var scContext = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)

        var dnsAddress = sockaddr_in()
        dnsAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        dnsAddress.sin_family = sa_family_t(address.count == 4 ? AF_INET : AF_INET6)
        dnsAddress.sin_port = self.htonsPort(port: 53)

        // TODO: get rid of the hardcoded 8.8.8.8
//        var ipAddressString = [CChar](repeating: 8, count:Int(address.count == 4 ? INET_ADDRSTRLEN : INET6_ADDRSTRLEN))
//        dnsAddress.sin_addr.s_addr = UnsafePointer(ipAddressString) // CFSwapInt32HostToBig([8,8,8,8])
//        dnsAddress.sin_addr.s_addr = (8,8,8,8,8,8,8,8)
        dnsAddress.sin_addr = in_addr(s_addr: inet_addr("8.8.8.8"))

        guard let scReachability = withUnsafePointer(to: &dnsAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return
            }
    
        SCNetworkReachabilitySetCallback(scReachability, { (_, flags, _) in
            let state = Network.parseFlags(reachabilityFlags: flags)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NetworkChangedNotificationKey),
                                            object: nil,
                                            userInfo: [
                                                NetworkChangedNotificationNetworkStatusKey: state.0.description,
                                                NetworkChangedNotificationNetworkTypeKey: state.1.description
                                            ])
        }, &scContext)
        
        SCNetworkReachabilityScheduleWithRunLoop(scReachability, CFRunLoopGetMain(), RunLoopMode.commonModes as CFString)
    }
    
    /// Indicates if the current platform uses little endian
    public var littleEndian: Bool {
        return Int(OSHostByteOrder()) == OSLittleEndian
    }
    
    /// Convert a host in_port_t to network endiness
    ///
    /// - Parameter port: in_port_t with host endianess
    /// - Returns: in_port_t with network endianess
    public func htonsPort(port: in_port_t) -> in_port_t {
        if self.littleEndian {
            return _OSSwapInt16(port)
        }
        
        return port
    }
    
    /// Convert a host Uint32 to network endianess
    ///
    /// - Parameter intValue: UInt32 with host endianess
    /// - Returns: UInt32 with network endianess
    public func htonl(intValue: UInt32) -> UInt32 {
        return CFSwapInt32HostToBig(intValue)
    }
}

let x = Network()
print(x.connectionInfo())
print(x.isOnline())
print(x.isWiFi())

