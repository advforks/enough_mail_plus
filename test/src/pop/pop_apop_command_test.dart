import 'package:enough_mail/src/private/pop/commands/pop_apop_command.dart';
import 'package:test/test.dart';

import '../../support/test_mail_crypto.dart';

void main() {
  setUpAll(TestMailCrypto.install);

  test('APOP digest matches the RFC 1939 example', () {
    expect(
      PopApopCommand.toMd5('<1896.697170952@dbc.mtview.ca.us>tanstaaf'),
      'c4c9334bac560ecc979e58001b3e22fb',
    );
  });
}
