part of 'inputs.dart';

/// Displays a Yes/No confirmation prompt and returns a boolean result.
///
/// The [confirm] function creates a simple selection menu with Yes/No options
/// and returns true for Yes and false for No. It leverages the [select] function
/// for the actual selection UI.
///
/// Parameters:
/// - [label]: Optional label displayed at the start of the prompt
/// - [question]: The question or prompt text shown to the user
/// - [width]: Width for the label column
/// - [gap]: Space between columns
/// - [callback]: Function called with the selected boolean value
/// - [indicators]: Custom indicators for selected/unselected options
/// - [defaultValue]: When true, highlights "Yes" as the recommended option
///
/// Returns a boolean value: true for "Yes" and false for "No".
bool confirm({
  String? label,
  required String question,
  int width = 0,
  int gap = 0,
  Function(SingleCLIState<bool> values)? callback,
  Indicators indicators = const Indicators(),
  bool defaultValue = true, // Added defaultValue parameter
}) {
  final options = ['Yes', 'No'];
  final recommendedOption = defaultValue ? 'Yes' : 'No';

  final selectedValue = select(
    label: label,
    question: question,
    options: options,
    recommendedOption: recommendedOption, // Pass recommendedOption
    width: width,
    gap: gap,
    indicators: indicators,
  );

  final result = selectedValue == 'Yes';
  callback?.call(SingleCLIState<bool>(label, result));
  return result;
}
