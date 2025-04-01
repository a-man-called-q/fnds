import 'dart:io';

import 'package:cli/cli.dart';

void main() async {
  // await verify(
  //   connectedMessage:
  //       '${chalk.white.onOrange.bold(' Fondasi version 1.0.0 ')}  Construction site ready to initialize.\n',
  //   notConnectedMessage:
  //       'Ouch, ${chalk.white.onDarkRed.bold(" we can't reach the internet. ")} Please check your connection.\n',
  // );
  // await intro();
  stdout.writeln();

  dialogues();
}
