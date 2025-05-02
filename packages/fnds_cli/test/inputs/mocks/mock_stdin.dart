part of "../inputs_tests.dart";

/// Mock implementation of Stdin for testing CLI inputs
class MockStdin implements Stdin {
  final StreamController<List<int>> _controller =
      StreamController<List<int>>.broadcast();
  final List<String> simulatedInputs = [];
  final List<KeyPress> simulatedKeyPresses = [];
  int _currentInputIndex = 0;
  int _currentKeyPressIndex = 0;
  int _currentCharIndexInInput = 0;

  @override
  bool echoMode = false;

  @override
  bool echoNewlineMode = false;

  @override
  bool lineMode = false;

  MockStdin();

  // Stream interface implementations
  @override
  Future<List<int>> get first => _baseStream.first;

  @override
  bool get hasTerminal => true;

  @override
  bool get isBroadcast => _baseStream.isBroadcast;

  @override
  Future<bool> get isEmpty => _baseStream.isEmpty;

  @override
  Future<List<int>> get last => _baseStream.last;

  @override
  Future<int> get length => _baseStream.length;

  @override
  Future<List<int>> get single => _baseStream.single;

  @override
  bool get supportsAnsiEscapes => true;

  Stream<List<int>> get _baseStream => _controller.stream;

  @override
  Future<bool> any(bool Function(List<int> element) test) =>
      _baseStream.any(test);

  @override
  Stream<List<int>> asBroadcastStream({
    void Function(StreamSubscription<List<int>> subscription)? onListen,
    void Function(StreamSubscription<List<int>> subscription)? onCancel,
  }) => _baseStream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) =>
      _baseStream.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) =>
      _baseStream.asyncMap(convert);

  @override
  Stream<R> cast<R>() => _baseStream.cast<R>();

  @override
  Future<bool> contains(Object? needle) => _baseStream.contains(needle);

  @override
  Stream<List<int>> distinct([
    bool Function(List<int> previous, List<int> next)? equals,
  ]) => _baseStream.distinct(equals);

  @override
  Future<E> drain<E>([E? futureValue]) => _baseStream.drain(futureValue);

  @override
  Future<List<int>> elementAt(int index) => _baseStream.elementAt(index);

  @override
  Future<bool> every(bool Function(List<int> element) test) =>
      _baseStream.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) =>
      _baseStream.expand(convert);

  @override
  Future<List<int>> firstWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) => _baseStream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
    S initialValue,
    S Function(S previous, List<int> element) combine,
  ) => _baseStream.fold(initialValue, combine);

  @override
  Future forEach(void Function(List<int> element) action) =>
      _baseStream.forEach(action);

  @override
  Stream<List<int>> handleError(
    Function onError, {
    bool Function(dynamic error)? test,
  }) => _baseStream.handleError(onError, test: test);

  @override
  Future<String> join([String separator = ""]) => _baseStream.join(separator);

  @override
  Future<List<int>> lastWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) => _baseStream.lastWhere(test, orElse: orElse);

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _baseStream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) =>
      _baseStream.map(convert);

  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) =>
      _baseStream.pipe(streamConsumer);

  @override
  int readByteSync() {
    // Process key presses first if any are available
    if (_currentKeyPressIndex < simulatedKeyPresses.length) {
      final keyPress = simulatedKeyPresses[_currentKeyPressIndex++];
      return keyPress.code; // Use the new extension method to get the code
    }

    // Then process text inputs if any are available
    if (_currentInputIndex < simulatedInputs.length) {
      final currentInput = simulatedInputs[_currentInputIndex];

      if (currentInput.isEmpty) {
        _currentInputIndex++;
        _currentCharIndexInInput = 0;
        return 10; // Line feed / Enter
      }

      if (_currentCharIndexInInput < currentInput.length) {
        final charCode = currentInput.codeUnitAt(_currentCharIndexInInput);
        _currentCharIndexInInput++;
        return charCode;
      } else {
        _currentInputIndex++;
        _currentCharIndexInInput = 0;
        return 10; // Line feed / Enter
      }
    }

    return -1; // No more input available
  }

  @override
  String? readLineSync({
    Encoding encoding = systemEncoding,
    bool retainNewlines = false,
  }) {
    if (_currentInputIndex < simulatedInputs.length) {
      final line = simulatedInputs[_currentInputIndex++];
      _currentKeyPressIndex = simulatedKeyPresses.length;
      _currentCharIndexInInput = 0;
      return line + (retainNewlines ? '\n' : '');
    }
    return null;
  }

  @override
  Future<List<int>> reduce(
    List<int> Function(List<int> previous, List<int> element) combine,
  ) => _baseStream.reduce(combine);

  /// Adds a key press to the simulation queue
  void simulatedKeyPress(KeyPress keyPress) {
    simulatedKeyPresses.add(keyPress);
  }

  @override
  Future<List<int>> singleWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) => _baseStream.singleWhere(test, orElse: orElse);

  @override
  Stream<List<int>> skip(int count) => _baseStream.skip(count);

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) =>
      _baseStream.skipWhile(test);

  @override
  Stream<List<int>> take(int count) => _baseStream.take(count);

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) =>
      _baseStream.takeWhile(test);

  @override
  Stream<List<int>> timeout(
    Duration timeLimit, {
    void Function(EventSink<List<int>> sink)? onTimeout,
  }) => _baseStream.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<List<List<int>>> toList() => _baseStream.toList();

  @override
  Future<Set<List<int>>> toSet() => _baseStream.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) =>
      _baseStream.transform(streamTransformer);

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) =>
      _baseStream.where(test);
}
