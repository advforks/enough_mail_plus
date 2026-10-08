import 'dart:typed_data';

/// Crypto that enough_mail needs, supplied by the host app.
///
/// The package ships no crypto implementation. Install one backed by a single
/// library before using APOP, CRAM-MD5, or DKIM signing.
abstract interface class MailCrypto {
  /// MD5, for POP3 APOP and SMTP CRAM-MD5 (both protocols require it).
  Uint8List md5(List<int> data);

  Uint8List hmacMd5(List<int> key, List<int> data);

  Uint8List sha256(List<int> data);

  /// RSASSA-PKCS1-v1_5 with SHA-256. [privateKeyDer] is a PKCS#8 or PKCS#1
  /// DER private key.
  Uint8List rsaSha256Sign(List<int> privateKeyDer, List<int> data);

  static MailCrypto? _installed;

  static void install(MailCrypto crypto) {
    _installed = crypto;
  }

  static MailCrypto get current =>
      _installed ??
      (throw StateError(
        'MailCrypto.install must run before APOP, CRAM-MD5, or DKIM signing.',
      ));
}
