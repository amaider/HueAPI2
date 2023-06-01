// 2024-06-02, Swift 5.0, macOS 14.4, Xcode 15.2
// Copyright © 2024 amaider. All rights reserved.

import Foundation

func fetchData(httpMethod: String, ipAddress: String, hueApplicationKey: String, resourceType: String?, resourceIdentifier: String?, httpBody: String?) async throws -> String {
    /// create hue URL
    guard !ipAddress.isEmpty else { throw NSError(domain: Bundle.main.bundleIdentifier!, code: 0) }
    
    /// dont include backslash if no value
    let rtypeString: String = resourceType == nil ? "" : "/\(resourceType!)"
    let ridString: String = resourceIdentifier == nil ? "" : "/\(resourceIdentifier!)"
    let urlString: String = "https://\(ipAddress)/clip/v2/resource\(rtypeString)\(ridString)"
    guard let url: URL = URL(string: urlString) else { throw NSError(domain: Bundle.main.bundleIdentifier!, code: 0) }
    
    /// configure request
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.addValue(hueApplicationKey, forHTTPHeaderField: "hue-application-key")
    request.httpBody = httpBody?.data(using: .utf8)
    
    /// execute request
    let (data, response) = try await URLSession(configuration: .default, delegate: HueAPIv2URLSessioDelegate(), delegateQueue: nil).data(for: request)
    guard let answer: String = String(data: data, encoding: .utf8) else { throw NSError(domain: "response not utf8: \(response)", code: Int(response.expectedContentLength)) }
    
    return answer
}

func getResourceTypes(ipAddress: String, hueApplicationKey: String) async -> [String] {
    guard
        let response: String = try? await fetchData(
            httpMethod: "GET", ipAddress: ipAddress,
            hueApplicationKey: hueApplicationKey,
            resourceType: nil,
            resourceIdentifier: nil,
            httpBody: nil),
        let responseData: Data = response.data(using: .utf8),
        let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
        let data: [[String: Any]] = json["data"] as? [[String: Any]]
    else { return [] }
    
    /// get all the types
    let rtypes: [String] = data.compactMap({ $0["type"] as? String })
    let rtypesUnique: [String] = Array(Set(rtypes)).sorted()
    return rtypesUnique
}

/// returns (rid, name)
func getResourceIDs(ipAddress: String, hueApplicationKey: String, resourceType: String) async -> [(String, String)] {
    guard
        let response: String = try? await fetchData(
            httpMethod: "GET", ipAddress: ipAddress,
            hueApplicationKey: hueApplicationKey,
            resourceType: resourceType,
            resourceIdentifier: nil,
            httpBody: nil),
        let responseData: Data = response.data(using: .utf8),
        let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
        let data: [[String: Any]] = json["data"] as? [[String: Any]]
    else { return [] }
    
    /// get all the types
    let rids: [(String, String)] = data.compactMap({
        guard
            let rtype: String = $0["type"] as? String,
            rtype == resourceType,
            let rid: String = $0["id"] as? String
        else { return nil }
        
        let name: String? = ($0["metadata"] as? [String: Any])?["name"] as? String
        let productName: String? = (($0["product_data"] as? [String: Any])?["product_name"] as? String)
        
        return (rid, name ?? productName ?? "")
    })
    
    return rids.sorted(by: { $0.0 < $1.0 })
}
