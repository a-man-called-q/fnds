import 'package:chalkdart/chalk.dart';
import 'package:fnds_cli/fnds_cli.dart';

export 'messages/messages.dart';
export 'utils/utils.dart';

StateManager statesManager = StateManager([]);

void dialogues() {
  ask<String>(
    label: chalk.black.onMagenta.bold(' testing-ask '),
    question:
        () => print(
          'You can ask anything and making sure the response is the correct type',
        ),
    defaultValue: 'the reply is supposed to be a string',
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  ask<double>(
    label: chalk.black.onPink.bold(' testing-ask-double '),
    question: () => print('Now the reply is supposed to be a double'),
    defaultValue: 10,
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  ask<String>(
    label: chalk.black.onBlue.bold(' use-secretive'),
    question:
        () => print(
          'This is when you are using password mode ${chalk.bold('(isSecretive set to true)')}: ',
        ),
    defaultValue: 'secret-or-us',
    isSecretive: true,
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  confirm(
    label: chalk.black.onMagenta.bold(' confirmation-test '),
    question: () => print("It's a question of yes and no, nothing more"),
    defaultValue: true,
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  select(
    label: chalk.black.onGreen.bold(' fruit-checker '),
    question: () => print("Select your favorite fruit:"),
    options: ["Apple", "Banana", "Cherry"],
    recommendedOption: "Banana",
    width: 20,
    gap: 2,
    callback: (result) => statesManager.addMember(result),
  );

  multipleSelect(
    label: chalk.black.onGreen.bold(' multi-select '),
    question: () => print('Select your favorite fruits multiple:'),
    options: ["Apple", "Banana", "Cherry"],
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  print('All The states:');
  for (var state in statesManager.states) {
    print(chalk.blue('The label is: ${state.label}'));
    if (state is GroupCLIState) {
      print(
        chalk.blue(
          'The selected options are: ${state.selectedOptions.join(', ')}',
        ),
      );
    } else if (state is SingleCLIState) {
      print(chalk.blue('The value is: ${state.value}'));
    }
  }
  print('');
  print('All the state values:');
  for (var state in statesManager.stateValues) {
    print(chalk.blue(state));
  }
  print('');
  print('get state value using the label:');
  print(chalk.blue(statesManager.getStateValueByLabel('fruit-checker')));
  print('');
  print('get state value using the index:');
  print(chalk.blue(statesManager.getStateValueByIndex(2)));
}
