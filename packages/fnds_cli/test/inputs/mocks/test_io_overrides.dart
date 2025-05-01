part of "../inputs_tests.dart";

/// IO overrides for testing that replace stdin/stdout with mocked versions
class TestIOOverrides extends IOOverrides {
  final MockStdin mockStdin;
  final MockIOSink mockStdout;

  TestIOOverrides({required this.mockStdin, required this.mockStdout});

  @override
  Stdout get stderr => StdoutAdapter(mockStdout);

  @override
  Stdin get stdin => mockStdin;

  @override
  Stdout get stdout => StdoutAdapter(mockStdout);
}
