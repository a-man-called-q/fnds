part of 'utils.dart';

class StateManager<T> {
  T _state;
  final StreamController<T> _controller = StreamController<T>.broadcast();

  StateManager(this._state);

  T get state => _state; // Last known value
  Stream<T> get stream => _controller.stream;

  void update(T newState) {
    _state = newState;
    _controller.add(newState);
  }
}
