import 'package:chalkdart/chalk.dart';
import 'package:fnds_cli/fnds_cli.dart';

void main() {
  StateManager statesManager = StateManager([]);

  ask<String>(
    label: chalk.black.onMagenta.bold(' testing-ask '),
    question:
        'You can ask anything and making sure the response is the correct type',
    defaultValue: 'the reply is supposed to be a string',
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  ask<double>(
    label: chalk.black.onPink.bold(' testing-ask-double '),
    question: 'Now the reply is supposed to be a double',
    defaultValue: 10,
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  ask<String>(
    label: chalk.black.onBlue.bold(' use-secretive'),
    question:
        'This is when you are using password mode (isSecretive set to true): ',
    defaultValue: 'secret-or-us',
    isSecretive: true,
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  confirm(
    label: chalk.black.onMagenta.bold(' confirmation-test '),
    question: "It's a question of yes and no, nothing more",
    defaultValue: true,
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  select(
    label: chalk.black.onGreen.bold(' fruit-checker '),
    question: "Select your favorite fruit:",
    options: ["Apple", "Banana", "Cherry"],
    recommendedOption: "Banana",
    width: 20,
    gap: 2,
    callback: (result) => statesManager.addMember(result),
  );

  multipleSelect(
    label: chalk.black.onGreen.bold(' multi-select '),
    question: 'Select your favorite fruits multiple:',
    options: ["Apple", "Banana", "Cherry"],
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  // Display collected states
  print('\nAll states:');
  for (var state in statesManager.states) {
    print('Label: ${state.label}');

    if (state is GroupCLIState) {
      print('Values: ${state.selectedOptions.join(", ")}');
    } else if (state is SingleCLIState) {
      print('Value: ${state.value}');
    }
    print('---');
  }

  print('\nQuick access examples:');
  print(
    'By label "fruit-checker": ${statesManager.getStateValueByLabel("fruit-checker")}',
  );
  print('By index 2: ${statesManager.getStateValueByIndex(2)}');
}
