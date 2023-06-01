// 18.05.23, Swift 5.0, macOS 13.1, Xcode 12.4
// Copyright © __YEAR__ amaider. All rights reserved.

import SwiftUI

struct ContentView: View {
    
    @AppStorage("httpMethod") var httpMethod: String = "GET"
    @AppStorage("ipAdress") var ipAddress: String = GitIgnore.ipAddress
    @AppStorage("resourceType") var resourceType: String?
    @AppStorage("resourceID") var resourceID: String?
    
    @AppStorage("hueApplicationKey") var hueApplicationKey: String = GitIgnore.hueApplicationKey
    @AppStorage("httpBody") var httpBody: String = #"{ "on": { "on": true } }"#
    @State var response: String = "response"
    
    let httpMethods: [String] = ["GET", "PUT", "POST", "DELETE"]
    @State var resourceTypes: [String] = []
    @State var resourceIDs: [(String, String)] = []
    
    var body: some View {
        VStack(content: {
            HStack(spacing: 4, content: {
                Picker("method", selection: $httpMethod, content: {
                    ForEach(httpMethods, id: \.self, content: {
                        Text($0)
                    })
                }).fixedSize()
                Text("https://")
                TextField("ipAddress", text: $ipAddress).fixedSize()
                Text("/clip/v2/resource/")
                Picker("rType", selection: $resourceType, content: {
                    Text("nil").tag(nil as String?)
                    ForEach(resourceTypes, id: \.self, content: {
                        Text($0).tag($0 as String?)
                    })
                })
                
                Text("/")
                Picker("rType", selection: $resourceID, content: {
                    Text("nil").tag(nil as String?)
                    ForEach(resourceIDs.indices, id: \.self, content: {
                        Text("\(resourceIDs[$0].1): \(resourceIDs[$0].0)").tag(resourceIDs[$0].0 as String?)
                    })
                })
                .disabled(resourceType == nil)
            })
            .labelsHidden()
            .onAppear(perform: refreshBridge)
            .onChange(of: resourceType, {
                refreshIDs()
            })
            
            TextField("hueApplicationKey", text: $hueApplicationKey)
            
            HStack(content: {
                TextField("Body", text: $httpBody)
                    .disabled(httpMethod == "GET" || httpMethod == "DELETE")
                
                Button("Go", action: fetchData)
            })
            
            TextEditor(text: $response)
                .onChange(of: response, cleanJSON)
        })
        .padding()
    }
    
    
    func refreshBridge() {
        Task {
            resourceTypes = await getResourceTypes(ipAddress: ipAddress, hueApplicationKey: hueApplicationKey)
            refreshIDs()
        }
    }
    func refreshIDs() {
        if let resourceType {
            Task {
                resourceIDs = await getResourceIDs(ipAddress: ipAddress, hueApplicationKey: hueApplicationKey, resourceType: resourceType)
            }
        }
    }
    func cleanJSON() {
        response = response.replacingOccurrences(of: #",""#, with: #",\n""#)
        ///{"on": { "on": true }, "dynamics": { "duration": 1000 } }
    }
    func fetchData() {
        Task {
            do {
                let httpBody: String? = (httpMethod == "GET" || httpMethod == "DELETE") ? nil : httpBody
                response = try await HueAPI2.fetchData(httpMethod: httpMethod, ipAddress: ipAddress, hueApplicationKey: hueApplicationKey, resourceType: resourceType, resourceIdentifier: resourceID, httpBody: httpBody)
            } catch {
                response = "\(error)"
            }
//            if httpBody.contains(#""on": true"#) {
//                httpBody = httpBody.replacingOccurrences(of: #""on": true"#, with: #""on": false"#)
//            } else {
//                httpBody = httpBody.replacingOccurrences(of: #""on": false"#, with: #""on": true"#)
//            }
            if httpBody.contains(#""x": 0.5267, "y": 0.4136"#) {
                httpBody = httpBody.replacingOccurrences(of: #""x": 0.5267, "y": 0.4136"#, with: #""x": 0.6175, "y": 0.3644"#)
            } else {
                httpBody = httpBody.replacingOccurrences(of: #""x": 0.6175, "y": 0.3644"#, with: #""x": 0.5267, "y": 0.4136"#)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
