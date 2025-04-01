part of 'utils.dart';

class Indicators {
  final String selectedIndicator;
  final String defaultIndicator;
  final String confirmedIndicator;
  final String selectedConfirmedIndicator;

  const Indicators({
    this.confirmedIndicator = '\x1B[32m☑\x1B[0m',
    this.defaultIndicator = '\x1B[35m○\x1B[0m',
    this.selectedConfirmedIndicator = '\x1B[38;5;214m☑\x1B[0m',
    this.selectedIndicator = '\x1B[38;5;214m●\x1B[0m',
  });
}
