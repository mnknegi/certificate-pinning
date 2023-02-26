# **Certificate Pinning**

It is critical to protect the privacy and integrity of the data which we send or receive over the network and protect it from any breach or attack. We should use the `Transport Layer Security(TLS)` to protect content in transit and authenticate the server receiving the data.

When we connect through TLS the server provides a certificate or certificate chain to establish its identity. We can limit the number of certificates which our app can trust by pinning their public-key identity in our app.

While HTTPS is effective to some extent, it is an SSL protocol which is known to make users safe by being unbreakable and largely secure. But Man-In-The-Middle(MITM) attack breach this too.

## Index
* [Types of Certificate Pinning](#Types-of-Certificate-Pinning)
    + [Pin the ceritficate](#Pin-the-ceritficate)
    + [Pin the public key](#Pin-the-public-key)
* [How to Implement SSL Pinning in your iOS App](#How-to-ImplementSSL-Pinning-in-your-iOS-App)
    + [NSURLSession](#NSURLSession)

## Types of Certificate Pinning

* Pin the certificate
* Pin the public key

### Pin the ceritficate

You can download the server's certificates and bundle them in your app. At runtime the app compares the server certificates the one that have embedded in the app.

### Pin the public key

you can retrieve the public key of the certificate as a string and hard code it in your code. At runtime the public key of the certificate is compared with the string you have hard coded in you app.

***Note :-*** Choosing the way to pin your certificate is totally up to us and the server configuration. There is a trade-off in both the ways. If you choose first option, then you need to upload your app on every certificate change which at least happen once in a year. If you choose second option the you violate key rotation policy as the public key won't change.


## How to Implement SSL Pinning in your iOS App

### NSURLSession

The primary method to implement SSL Pinning using NSURLSession is 
```
URLSession:didReceiveChallenge:completionHandler:delegate
```
