// 18.05.23, Swift 5.0, macOS 13.1, Xcode 12.4
// Copyright © __YEAR__ amaider. All rights reserved.

import Foundation

// class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
//     let certFileName = "philips-hue-cert"
//     let certFileType = "pem"
//     func urlSession(_ session: URLSession,
//                       didReceive challenge: URLAuthenticationChallenge,
//                       completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
//         if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//             if let serverTrust = challenge.protectionSpace.serverTrust {
//                 var secresult = SecTrustResultType.invalid
//                 let status = SecTrustEvaluate(serverTrust, &secresult)
//                 if(errSecSuccess == status) {
//                     if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
//                         let serverCertificateData = SecCertificateCopyData(serverCertificate)
//                         let data = CFDataGetBytePtr(serverCertificateData);
//                         let size = CFDataGetLength(serverCertificateData);
//                         let certificateOne = NSData(bytes: data, length: size)
//                         let filePath = Bundle.main.path(forResource: self.certFileName,
//                                                              ofType: self.certFileType)
//                         if let file = filePath {
//                             if let certificateTwo = NSData(contentsOfFile: file) {
//                                     completionHandler(URLSession.AuthChallengeDisposition.useCredential,
//                                                       URLCredential(trust:serverTrust))
//                                     return
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//         completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
//     }
// }

class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    // let certFileName = "philips-hue-cert"
    // let certFileType = "pem"
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                if(errSecSuccess == status) {
                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                    return
                }
            }
        }
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}
