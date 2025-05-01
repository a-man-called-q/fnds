part of "../inputs_tests.dart";

/// Adapter to convert IOSink to Stdout
class StdoutAdapter implements Stdout {
  final IOSink _sink;

  @override
  Encoding encoding = utf8;

  StdoutAdapter(this._sink);

  @override
  Future get done => _sink.done;

  @override
  bool get hasTerminal => true;

  @override
  String get lineTerminator =>
      throw UnimplementedError('lineTerminator getter not implemented in mock');

  @override
  set lineTerminator(String value) =>
      throw UnimplementedError('lineTerminator setter not implemented in mock');

  @override
  IOSink get nonBlocking => _sink; // Return the wrapped sink

  @override
  bool get supportsAnsiEscapes => true;

  @override
  int get terminalColumns => 80;

  @override
  int get terminalLines => 25;

  @override
  void add(List<int> data) => _sink.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sink.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _sink.addStream(stream);

  @override
  Future close() => _sink.close();

  @override
  Future flush() => _sink.flush();

  @override
  void write(Object? object) => _sink.write(object);

  @override
  void writeAll(Iterable objects, [String separator = ""]) =>
      _sink.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _sink.writeCharCode(charCode);

  void writeError(Object? object) => write(object);

  void writeErrorAll(Iterable objects, [String separator = ""]) =>
      _sink.writeAll(objects, separator);

  void writeErrorCharCode(int charCode) => _sink.writeCharCode(charCode);

  void writeErrorln([Object? object = ""]) => _sink.writeln(object);

  @override
  void writeln([Object? object = ""]) => _sink.writeln(object);
}
