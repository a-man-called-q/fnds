part of "../inputs_tests.dart";

/// Mock implementation of IOSink that captures output in a StringBuffer
class MockIOSink implements IOSink {
  final StringBuffer _buffer;

  MockIOSink(this._buffer);

  @override
  Future<void> get done => Future.value();

  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  void add(List<int> data) {
    _buffer.write(String.fromCharCodes(data));
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await for (final chunk in stream) {
      add(chunk);
    }
  }

  @override
  Future<void> close() async {}

  @override
  Future<void> flush() async {}

  @override
  void write(Object? obj) {
    _buffer.write(obj);
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    _buffer.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    _buffer.writeCharCode(charCode);
  }

  @override
  void writeln([Object? obj = ""]) {
    _buffer.writeln(obj);
  }
}
