part of 'utils.dart';

class AutoWidth extends Width {
  const AutoWidth();
}

class CLIState {
  final String? label;

  const CLIState(this.label);
}

class IntWidth extends Width {
  final int value;
  const IntWidth(this.value);
}

class MultipleCLIState<T> extends CLIState {
  final List<T> selectedOptions;

  const MultipleCLIState(super.label, this.selectedOptions);
}

class SingleCLIState<T> extends CLIState {
  final T value;

  const SingleCLIState(super.label, this.value);
}

sealed class Width {
  const Width();
}
