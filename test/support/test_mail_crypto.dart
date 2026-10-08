import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:enough_mail/enough_mail.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:pointycastle/asn1.dart';

/// Pure-Dart provider for tests only.
final class TestMailCrypto implements MailCrypto {
  const TestMailCrypto();

  static void install() => MailCrypto.install(const TestMailCrypto());

  @override
  Uint8List md5(List<int> data) =>
      Uint8List.fromList(hash.md5.convert(data).bytes);

  @override
  Uint8List hmacMd5(List<int> key, List<int> data) =>
      Uint8List.fromList(hash.Hmac(hash.md5, key).convert(data).bytes);

  @override
  Uint8List sha256(List<int> data) =>
      Uint8List.fromList(hash.sha256.convert(data).bytes);

  @override
  Uint8List rsaSha256Sign(List<int> privateKeyDer, List<int> data) {
    var seq = ASN1Parser(Uint8List.fromList(privateKeyDer)).nextObject()
        as ASN1Sequence;
    if (seq.elements!.length >= 3 && seq.elements![2] is ASN1OctetString) {
      seq = ASN1Parser((seq.elements![2] as ASN1OctetString).octets!)
          .nextObject() as ASN1Sequence;
    }
    BigInt at(int i) => (seq.elements![i] as ASN1Integer).integer!;
    final key = pc.RSAPrivateKey(at(1), at(3), at(4), at(5));
    final signer = pc.RSASigner(pc.SHA256Digest(), '0609608648016503040201')
      ..init(true, pc.PrivateKeyParameter<pc.RSAPrivateKey>(key));
    return signer.generateSignature(Uint8List.fromList(data)).bytes;
  }
}
