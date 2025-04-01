part of 'inputs.dart';

bool confirm({
  String? label,
  required Function() question,
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
