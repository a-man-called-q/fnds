part of 'utils.dart';

class AutoWidth extends Width {
  const AutoWidth();
}

class CLIState {
  final String? label;

  const CLIState(this.label);
}

class GroupCLIState<T> extends CLIState {
  final List<T> selectedOptions;

  const GroupCLIState(super.label, this.selectedOptions);
}

class IntWidth extends Width {
  final int value;
  const IntWidth(this.value);
}

class SingleCLIState<T> extends CLIState {
  final T value;

  const SingleCLIState(super.label, this.value);
}

sealed class Width {
  const Width();
}
