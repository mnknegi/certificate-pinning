//
//  NetworkManager.swift
//  SSLPinningDemo
//
//  Created by Mayank Negi on 31/05/24.
//

import Foundation
import Security
import CommonCrypto

final class NetworkManager: NSObject {

    var session: URLSession!

    override init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }

    func getTemp(urlString: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            // handle invalid URL.
            return
        }

        let urlRequest = URLRequest(url: url)
        self.session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                // client error
                print(error)
                return
            }

            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                // Invalid data
                return
            }

            guard let data else {
                // Invalid data
                return
            }

            do {
                let decoder = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(decoder))
            } catch {
                // Error while decoding.
            }

        }.resume()
    }
}

/*
extension NetworkManager: URLSessionDelegate {

    private func logCertificates(in trust: SecTrust) {
        print("############## Certificates in Request Trust ###############")

        if let certificates = SecTrustCopyCertificateChain(trust) as? [SecCertificate] {
            for index in 0..<certificates.count {
                let subject = SecCertificateCopySubjectSummary(certificates[index]) as? String ?? "unknown"
                let prefix = String(repeating: "\t", count: index)

                print("Certificate -> \(prefix), \(subject)")
            }
        }

        print("############################################################")
    }

    // Load your certificates
    private func getPinnedCertificates() -> [Data] {
        let cerPaths = ["openweathermap.org.cer"] // Add your certificate file names here
        var certificates: [Data] = []

        for path in cerPaths {
            if let cerPath = Bundle.main.path(forResource: path, ofType: nil), let certData = try? Data(contentsOf: URL(filePath: cerPath)) {
                certificates.append(certData)
            }
        }
        return certificates
    }

    private func compareCertificate(serverCertificatesData: [Data], pinnedCertificateData: Data, completion: (Bool) -> Void) {
        if serverCertificatesData.contains(pinnedCertificateData) {
            completion(true)
        } else {
            completion(false)
        }
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        /**
         - Check if the challenge is a server trust challenge.
         - Extract the server's certificate from the challenge.
         - Compare the server's certificate data with the pinned certificates.
         - If there's a match, create a URLCredential and use it.
         - If there's no match, cancel the authentication challenge.
         */

        // Check if the challenge is a server trust challenge
        // Create a server trust.
        guard
            let serverTrust = challenge.protectionSpace.serverTrust else {
            // Handle error - Perform Default Handling.
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // SSL Policies for domain name check.
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))

        // Evaluate server certificate.
        guard SecTrustEvaluateWithError(serverTrust, nil) else {
            completionHandler(.rejectProtectionSpace, nil)
            return
        }

        // Local and Remote Certificate Data.

        // Get the server's certificate
        guard
            let serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
            return
        }
        let serverCertificatesData = serverCertificates.map{ SecCertificateCopyData($0) as Data }

        self.logCertificates(in: serverTrust)

        // Get the pinned certificates
        let pinnedCertificatesData = getPinnedCertificates()

        // Compate the server's certificate with the pinned certificates.
        for pinnedCertificateData in pinnedCertificatesData {
            self.compareCertificate(serverCertificatesData: serverCertificatesData, pinnedCertificateData: pinnedCertificateData, completion: { success in
                if success {
                    let urlCredential = URLCredential(trust: serverTrust)
                    completionHandler(.useCredential, urlCredential)
                } else {
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
            })
        }
    }
}
 */


// ################# Public Key Pinning ################# //

/*
 1. Get the certificate in .pem format.
 > openssl x509 -inform der -in openweathermap.org.cer -pubkey -noout > openweathermap.org.pem

 2. Hash and encode it using base64 encoding. Use this command to get the public key in SHA256 format.
 > cat openweathermap.org.pem | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64

 publicKeyHash = axmGTWYycVN5oCjh3GJrxWVndLSZjypDO6evrHMwbXg=
*/

extension NetworkManager: URLSessionDelegate {

    static let publicKeyHashes = ["axmGTWYycVN5oCjh3GJrxWVndLSZjypDO6evrHMwbXg="]

    private static let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ];

    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(NetworkManager.rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }

    private func compareHashes(serverPublicKeyHashes: [String], pinnedHashKey: String, completion: (Bool) -> Void) {
        if serverPublicKeyHashes.contains(pinnedHashKey) {
            completion(true)
        } else {
            completion(false)
        }
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard
            let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.rejectProtectionSpace, nil)
            return
        }

        // SSL Policies for domain name check.
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))

        // Evaluate server certificate.
        guard SecTrustEvaluateWithError(serverTrust, nil) else {
            completionHandler(.rejectProtectionSpace, nil)
            return
        }

        // Local and Remote Public key.

        guard
            let serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
            return
        }
        let serverPublicKeys = serverCertificates.map{ SecCertificateCopyKey($0) }

        let serverPublicKeysData = serverPublicKeys.map{ SecKeyCopyExternalRepresentation($0!, nil) as? Data }

        // Remote hash key
        let serverHashkeys = serverPublicKeysData.map{ sha256(data: $0!) }

        // Local hash key
        let pinnedHashKeys = type(of: self).publicKeyHashes

        // Compate the server's certificate with the pinned certificates.
        for pinnedHashKey in pinnedHashKeys {
            self.compareHashes(serverPublicKeyHashes: serverHashkeys, pinnedHashKey: pinnedHashKey, completion: { success in
                if success {
                    let urlCredential = URLCredential(trust: serverTrust)
                    completionHandler(.useCredential, urlCredential)
                } else {
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
            })
        }
    }
}
