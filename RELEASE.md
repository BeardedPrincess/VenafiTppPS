- issue #92, add offset parameter to Find-TppCertificate
- fix issue #95, allow inclusion of private key for format Base64 (PKCS #8) in Get-TppCertificate.  Earlier versions of Venafi documentation listed this incorrectly, but has been resolved.
- fix issue #96, Get-TppCertificate failing when pipilining due to adding a key to a hashtable that already exists
- fix issue #97, linux style paths which use / instead of \ were failing path check due to invalid regex
- pssa fix for Read-TppLog