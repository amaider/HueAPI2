// 18.05.23, Swift 5.0, macOS 13.1, Xcode 12.4
// Copyright © __YEAR__ amaider. All rights reserved.

import SwiftUI

struct ContentView: View {
    @AppStorage("urlInput") var urlInput: String = "https://192.168.178.56/clip/v2/resource/light/afdce4a4-3d37-4c4c-8113-0c101613b768"
    @AppStorage("hueApplicationKey") var hueApplicationKey: String = "pIb5fpHSs58Bo8xw9LF-2Fn748hbDL1iMPXxjKvz"
    
    @AppStorage("httpMethod") var httpMethod: String = "GET"
    @AppStorage("httpBody") var httpBody: String = ""
    @State var response: String = "response"
    
    
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                Button("HTTP", action: loadHTTP)
                Button("HTTPS", action: loadHTTPS2)
            })
            
            HStack(content: {
                Button("ON", action: hueOn)
                Button("OFF", action: hueOff)
            })
            
            Divider()
            
            Group(content: {
                Picker("method", selection: $httpMethod, content: {
                    Text("GET").tag("GET")
                    Text("POST").tag("POST")
                    Text("PUT").tag("PUT")
                })
                .pickerStyle(.segmented)
                .labelsHidden()
                .fixedSize()
                
                TextField("URL", text: $urlInput)
                TextField("hueApplicationKey", text: $hueApplicationKey)
                TextField("Body", text: $httpBody)
                    .disabled(httpMethod == "GET")
                
                HStack(content: {
                    Button("GO", action: getRequest)
                })
            })
            
            TextEditor(text: $response)
        })
        .padding()
    }
    func getRequest() {
        guard let url: URL = URL(string: self.urlInput) else {
            print("bad getRequest")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValue(self.hueApplicationKey, forHTTPHeaderField: "hue-application-key")
        request.httpBody = self.httpBody.data(using: .utf8)
        
        URLSession(configuration: URLSessionConfiguration.default, delegate: NSURLSessionPinningDelegate(), delegateQueue: OperationQueue.main).dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            
            // self.response = String(decoding: data, as: UTF8.self)
            var result: String = String(decoding: data, as: UTF8.self)
            // result = result.replacingOccurrences(of: ",", with: ",\n")
            // result = result.replacingOccurrences(of: "{", with: "{\n\t")
            // result = result.replacingOccurrences(of: "}", with: "\n}")
            self.response = result
        }).resume()
    }
}

extension ContentView {
    func loadHTTP() {
        guard let url: URL = URL(string: "http://192.168.178.56/api/0/config") else {
            print("bad URL1")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print(type(of: data), type(of: response), type(of: error))
            guard let data = data else {
                print("no data")
                return
            }
            
            self.response = String(decoding: data, as: UTF8.self)
        }).resume()
    }
    
    func loadHTTPS() {
        guard let url: URL = URL(string: "https://192.168.178.56/clip/v2/resource/light/afdce4a4-3d37-4c4c-8113-0c101613b768") else {
            print("bad URL2")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(hueApplicationKey, forHTTPHeaderField: "hue-application-key")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print(type(of: data), type(of: response), type(of: error))
            guard let data = data else {
                print("no data")
                return
            }
            
            self.response = String(decoding: data, as: UTF8.self)
        }).resume()
    }
    
    func loadHTTPS1() {
        guard let url: URL = URL(string: "https://192.168.178.56/clip/v2/resource/light/afdce4a4-3d37-4c4c-8113-0c101613b768") else {
            print("bad URL2")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(hueApplicationKey, forHTTPHeaderField: "hue-application-key")
        
        URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: NSURLSessionPinningDelegate(), delegateQueue: OperationQueue.main).dataTask(with: request, completionHandler: { (data, response, error) in
            print(type(of: data), type(of: response), type(of: error))
            guard let data = data else {
                print("no data")
                return
            }
            
            self.response = String(decoding: data, as: UTF8.self)
        }).resume()
    }
    
    func loadHTTPS2() {
        guard let url: URL = URL(string: "https://192.168.178.56/clip/v2/resource/light/afdce4a4-3d37-4c4c-8113-0c101613b768") else {
            print("bad URL2")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(hueApplicationKey, forHTTPHeaderField: "hue-application-key")
        
        // guard let data: Data = try? JSONEncoder().encode(httpBody) else {
        //     print("fail data")
        //     return
        // }
        // request.httpBody = data
        
        URLSession(configuration: URLSessionConfiguration.default, delegate: NSURLSessionPinningDelegate(), delegateQueue: OperationQueue.main).dataTask(with: request, completionHandler: { (data, response, error) in
            print(type(of: data), type(of: response), type(of: error))
            guard let data = data else {
                print("no data")
                return
            }
            
            self.response = String(decoding: data, as: UTF8.self)
        }).resume()
    }
    func hueOn() {
        guard let url: URL = URL(string: "https://192.168.178.56/clip/v2/resource/light/afdce4a4-3d37-4c4c-8113-0c101613b768") else {
            print("bad URL2")
            return
        }
        
        let httpBodyOn: String = "{\"on\": {\"on\": true}}"
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(hueApplicationKey, forHTTPHeaderField: "hue-application-key")
        request.httpBody = httpBodyOn.data(using: .utf8)
        
        URLSession(configuration: URLSessionConfiguration.default, delegate: NSURLSessionPinningDelegate(), delegateQueue: OperationQueue.main).dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            
            self.response = String(decoding: data, as: UTF8.self)
        }).resume()
    }
    func hueOff() {
        guard let url: URL = URL(string: "https://192.168.178.56/clip/v2/resource/light/afdce4a4-3d37-4c4c-8113-0c101613b768") else {
            print("bad URL2")
            return
        }
        
        let httpBodyOff: String = "{\"on\": {\"on\": false}}"
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(hueApplicationKey, forHTTPHeaderField: "hue-application-key")
        request.httpBody = httpBodyOff.data(using: .utf8)
        
        URLSession(configuration: URLSessionConfiguration.default, delegate: NSURLSessionPinningDelegate(), delegateQueue: OperationQueue.main).dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            
            self.response = String(decoding: data, as: UTF8.self)
        }).resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
