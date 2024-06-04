
# SSL Pinning in iOS

## Table of content

- [Man in The Middle attack](#man-in-the-middle-attack)
- [Secure Socket Layer(SSL) & Transport Security Layer(TSL)](#secure-socket-layer-and-transport-security-layer)
- [Difference between Secure Socket Layer and Transport Layer Security](#difference-between-secure-socket-layer-and-transport-layer-security)
- [Symmetric key cryptography](#symmetric-key-cryptography)
- [Asymmetric key cryptography](#asymmetric-key-cryptography)
- [SSL Pinning](#ssl-pinning)
- [Types of SSL Pinning](#types-of-ssl-pinning)
    + [SSL Pinning via Certificate](#ssl-pinning-via-certificate)
    + [SSL Pinning via Public key](#ssl-pinning-via-public-key)

## Man in The Middle Attack

A `Man in The Middle (MITM)` Attack is a type of cyber attack in which the attacker secretly eavesdrop the message between client and server. It can not only able to eavesdrop but can also potentially alter the communication between two parties who believe they are directly communicating with each other. The attacker positions themselves in between the two parties, hence it is called as Man-in-The-Middle attack.

MitM attack involves three parties: the attacker, the victim and the intended communication recipient.

`Interception` - The attacker intercepts the communication the victim and the intended recipient. This can be done by various means - `eavesdropping on the public WiFi` network, exploiting `vulnerabilities in the network infrastructure` or thourgh `malware`.

`Impersonation` - Once the attacker has intercepted the communication, he can impersonate either the victim or the intended recipient to gain their trust.

`Information Theft or Manipulation` - With the ability to intercept the communication and potentially alter the communication, the attacker can steal the sensitive information exchange between the victim and the intended recipient. The information can include login credentials, financial details, personal information and any data being transmitted. 

`Intercept > Impersonation > Information theft or Manipulation`

This attack posses significant risks to the confidenciality, integrity and authenticity of the communication between the parties. To mitigate the risk of MiTM attack, encription tecknologies such as SSL/TLS are used to secure the communication between the sender and the receiver.

## Secure Socket Layer(SSL) & Transport Security Layer(TSL)

These are the `cryptographic protocol` use to secure communication over the internet. They establish an `encrypted communication` between the client(Web browser) and server(Website) during the communication, and ensure that the data transmission is tamper-proof.

Steps of SSL/TLS communication

- `Handshake` - It is the step when client and the server establish a secure connection. Both negotiate `encryption algorithms` and exchange `cryptographic keys` to encrypt or decrypt the data.

- `Encryption` - Once the handshake is complete, the client and the server begin encrypting the data using symmetric encryption. Symmetric encryption means that the same key is used for both encryption and decryption. SSL/TLS also supports asymmetric cryptography, where different keys are used for encryption and decryption. Which is typically used during the initial handshake to securely exchange the symmetric encription keys.

- `Data Transmission` - With the secure connection established and data encrypted, the client and the server can safely exchange the data without the fear of eavesdroping or tampering by malicious actors.

- `Authentication` - SSL/TLS also provides method for authentication of the identities of client and the server. This authentication is typically done using certificates issued by trusted certificate authorities(CAs). The certificated contains the information about the server's identity and are digitally signed by CA.

## Difference between Secure Socket Layer and Transport Layer Security

SSL & TLS both are cryptographic protocol to provide secure communication over a network. While they serve the same purpose, there are key differences between the two.

- Development: SSL was developed by `Netscape` in the mid-1990s to secure communication over the internet. The first version, SSL 1.0, was never released due to security flaws, but SSL 2.0 was released in 1995. Subsequent versions, SSL 3.0 and SSL 3.1, were released in 1996 and 1999, respectively. TLS was developed as an upgrade to SSL by the `Internet Engineering Task Force (IETF)` to address the security vulnerabilities and shortcomings of SSL. TLS 1.0 was released in 1999 as an improved version of SSL 3.0, and subsequent versions of TLS have been developed since then.

- Protocol Versions: SSL has several versions, including SSL 2.0 and SSL 3.0, but these versions are considered `deprecated` and `insecure` due to various vulnerabilities. TLS has versions starting from TLS 1.0, with subsequent versions such as TLS 1.1, TLS 1.2, and TLS 1.3. TLS 1.3 is the latest version offers improved security and performance compared to earlier versions.

- Security: TLS is considered more secure than SSL due to various improvements and enhancements introduced in later versions. For example, TLS 1.2 and TLS 1.3 have stronger cryptographic algorithms and better resistance against known attacks compared to SSL 3.0 or even earlier versions of TLS.

- Compatibility: While TLS is backward-compatible with SSL to some extent, there are differences in the `handshake process` and `cryptographic algorithms` used. Modern web browsers and servers typically support TLS and may have deprecated or disabled support for older versions of SSL due to security concerns.

- Industry Adoption: Due to security vulnerabilities in SSL and the development of more secure alternatives like TLS, industry adoption has shifted towards TLS. TLS is widely used in various applications and services on the internet, including web browsing, email communication, online banking, e-commerce, and more.

## Symmetric key cryptography

Symmetric key cryptography also know as `secret key cryptography` or `private key cryptography`, is a cryptographic technique where the same key is used for encryption and decryption of the data. In this, both the sender and the recipient of the message share a common secret key which is used to encrypt and decrypt messages.   

- Key Generation: The first step in symmetric cryptography is for both the sender and the recipient to agree on a secret key. This key must be kept confidential and shared securely between the parties.

- Encryption: To encrypt a message, the sender uses the agreed-upon secret key and a symmetric encryption algorithm to transform the `plaintext` message into `ciphertext`. The ciphertext is a scrambled version of the original message, making it unreadable without the secret key.

- Decryption: The recipient uses the same secret key and the symmetric encryption algorithm to decrypt the ciphertext back into plaintext. Because both parties share the same secret key, the recipient can successfully recover the original message.

- Security: The security of symmetric cryptography relies on the secrecy of the shared secret key. If an attacker gains access to the secret key, they can decrypt any intercepted messages encrypted with that key. Therefore, it's essential to use secure key management practices to protect the secrecy of the key.

Symmetric cryptography is commonly used in various applications, including `data encryption`, secure communication protocols (such as SSL/TLS), `file encryption`, `disk encryption`, and more. While symmetric cryptography is efficient and fast, one of its primary challenges is securely sharing the secret key between the communicating parties, especially in scenarios where there is `no prior trust relationship established`. This challenge is typically addressed through `key exchange protocols` or by using `asymmetric cryptography` in combination with symmetric cryptography for key exchange.

## Asymmetric key cryptography

Asymmetric key cryptography, also known as `public-key cryptography`, is a cryptographic approach that uses two separate keys for encryption and decryption: a public key and a private key. Unlike symmetric cryptography, where the same key is used for both encryption and decryption, asymmetric cryptography employs a key pair, with each key serving a different purpose.

- Key Generation: Each participant generates a key pair consisting of a public key and a private key. The public key is freely distributed and can be shared with anyone, while the private key is kept secret and known only to its owner. The keys are mathematically related in such a way that data encrypted with one key can only be decrypted with the other key in the pair.

- Encryption: If Alice wants to send a secure message to Bob, she obtains Bob's public key and uses it to encrypt the message. Once encrypted with Bob's public key, only Bob's private key can decrypt the message.

- Decryption: When Bob receives the encrypted message, he uses his private key to decrypt it. Since only Bob possesses the private key corresponding to his public key, only he can successfully decrypt the message.

- Digital Signatures: Asymmetric cryptography also enables digital signatures, which are used to verify the authenticity and integrity of a message. In this case, the sender signs the message using their private key, and the recipient can verify the signature using the sender's public key. If the signature is valid, it provides assurance that the message was indeed sent by the claimed sender and has not been tampered with.

- Security: The security of asymmetric cryptography relies on the computational difficulty of certain mathematical problems, such as factoring large integers or computing discrete logarithms. These mathematical problems form the basis of asymmetric encryption algorithms, such as RSA, Diffie-Hellman, and Elliptic Curve Cryptography (ECC).

## SSL Pinning

SSL Pinning is a process of introducing SSL Certificate between the Client App and Server (or, API Gateway) so that, each connection is encrypted & secure. It’s more like, a private key is kept at Server and Public key is distributed to the clients such that each conversation can encrypted by the respective key(s).

SSL pinning mitigates the risk of attackers presenting fraudulent or spoofed SSL certificates to intercept or impersonate the server. By pinning the SSL certificate or public key within the app, it becomes more challenging for attackers to impersonate the server, as they would need to possess the specific certificate or key configured in the app.

## Types of SSL Pinning

### SSL Pinning via Certificate 

SSL pinning via certificate in iOS involves embedding a specific SSL certificate within the iOS application and then configuring the app to only trust that certificate when establishing secure connections with the server. 

`Obtain the SSL Certificate`: Obtain the SSL certificate (in PEM or DER format) from the server you wish to communicate with. This can typically be done by accessing the server's endpoint using a web browser and extracting the certificate from the browser's security settings.

`Add the Certificate to the Xcode Project`: Add the SSL certificate to your Xcode project. Ensure that the certificate is included in the app bundle and will be available at runtime. You can simply drag and drop the certificate file into the Xcode project navigator.

`Configure the App to Use SSL Pinning`: In your app code, you'll need to configure the URLSession (or other networking library) to perform SSL pinning. This involves loading the embedded certificate and configuring the URLSession to validate the server's SSL certificate against this pinned certificate.

```
guard let certificatePath = Bundle.main.path(forResource: "server_certificate", ofType: "cer") else {
    // Handle error - certificate not found
    return
}

guard let certificateData = try? Data(contentsOf: URL(fileURLWithPath: certificatePath)) else {
    // Handle error - unable to read certificate data
    return
}

let pinnedCertificates = [certificateData]

let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
    certificates: pinnedCertificates,
    validateCertificateChain: true,
    validateHost: true
)

let serverTrustPolicies: [String: ServerTrustPolicy] = [
    "your.server.com": serverTrustPolicy
]

let sessionManager = Session(configuration: .default, serverTrustManager: ServerTrustManager(policies: serverTrustPolicies))
```

`Handle Certificate Updates`: Keep in mind that SSL certificates may expire or need to be updated periodically. You'll need to handle certificate updates in your app by updating the embedded certificate and releasing app updates as necessary.


### SSL Pinning via Public key 

SSL pinning via public key in iOS involves embedding a specific public key within the iOS application and configuring the app to only trust connections to servers presenting certificates signed with that public key.

`Obtain the Public Key`: Obtain the public key from the server you wish to communicate with. This can typically be done by accessing the server's certificate and extracting the public key from it.

`Add the Public Key to the Xcode Project`: Add the public key to your Xcode project. Ensure that the public key is included in the app bundle and will be available at runtime. You can simply drag and drop the public key file into the Xcode project navigator.

`Configure the App to Use SSL Pinning`: In your app code, you'll need to configure the URLSession (or other networking library) to perform SSL pinning using the public key. This involves loading the embedded public key and configuring the URLSession to validate the server's SSL certificate against this pinned public key.

```
guard let publicKeyPath = Bundle.main.path(forResource: "server_public_key", ofType: "der") else {
    // Handle error - public key not found
    return
}

guard let publicKeyData = try? Data(contentsOf: URL(fileURLWithPath: publicKeyPath)) else {
    // Handle error - unable to read public key data
    return
}

let pinnedPublicKeys = [SecCertificateCopyPublicKey(try! SecCertificate(data: publicKeyData))!]

let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(
    publicKeys: pinnedPublicKeys,
    validateCertificateChain: true,
    validateHost: true
)

let serverTrustPolicies: [String: ServerTrustPolicy] = [
    "your.server.com": serverTrustPolicy
]

let sessionManager = Session(configuration: .default, serverTrustManager: ServerTrustManager(policies: serverTrustPolicies))
```

**Q:** What is SSL pinning?
**A:** SSL Pinning stands for Secure Socket Layer. This creates a foundation of trust by establishing secure connection. This connection ensures that all the data passing between web server and the web browser or mobile app remain private and integral.

**Q:** Digital Certificate?
**A:** A certificate is a file that encapsulates information about the server that owns the certificate. The structure of the certificate uses X.509 standards. X.509 is defined by `International Telecommunication Union`. A Certificate Authority(CA) can issue a certificate or it can be self signed.

There are several common file extensions for X.509 certificates.

- PEM(`Privacy Enhanced Mail`) - A Base64 encoding whose file extension is .pem. The certificate information is enclosed between “ — — -BEGIN CERTIFICATE — — -” and “ — — -END CERTIFICATE — — -”

- PKCS(`Public-Key cryptography standards`) - Used to exchange public and private objects in a single file. Its extensions are .p7b, .p7c, .p12(`Personal Information Exchange`) etc.

- DER(`Distinguished Encoding Rules`) - A binary encoding whose file extensions are .cer, .der and .crt.
