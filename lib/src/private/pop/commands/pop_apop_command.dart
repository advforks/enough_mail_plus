import 'dart:convert';

import '../../../mail_crypto.dart';
import '../pop_command.dart';

/// The `APOP` command signs in the user
class PopApopCommand extends PopCommand<String> {
  /// Creates a new `APOP` command
  PopApopCommand(this.user, String pass, String serverTimestamp)
      : super('APOP $user ${toMd5(serverTimestamp + pass)}');

  /// The user ID
  final String user;

  /// Generates the MD5 hash from the [input]
  static String toMd5(String input) {
    final inputBytes = utf8.encode(input);
    final digest = MailCrypto.current.md5(inputBytes);

    return _hex(digest);
  }

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  @override
  String toString() => 'APOP $user <MD5 scrambled>';
}
