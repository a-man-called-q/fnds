import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:cli/utils/utils.dart';
import 'package:fnds_cli/fnds_cli.dart';

export 'messages/messages.dart';
export 'utils/utils.dart';

StateManager<String> dir = StateManager<String>('');
StateManager<String> stateManager = StateManager<String>('');
void dialogues() {
  ask<String>(
    label: () => print(chalk.black.onMagenta.bold(' dir ')),
    question: () => print('Where do you want to put the project: '),
    defaultValue: generateProjectName(),
    gap: 2,
    width: 20,
    callback: (value) => dir.update(value),
  );

  select(
    label: () => print(chalk.black.onGreen.bold(' state_manager ')),
    question: () => print("Select your favorite fruit:"),
    options: ["Apple", "Banana", "Cherry"],
    recommendedOption: "Banana",
    width: 20,
    gap: 2,
    callback: (value) => stateManager.update(value),
  );

  ask<String>(
    label: () => print(chalk.black.onMagenta.bold(' dir ')),
    question: () => print('Where do you want to put the project: '),
    defaultValue: generateProjectName(),
    gap: 2,
    width: 20,
    callback: (value) => dir.update(value),
  );

  ask<String>(
    label: () => print(chalk.black.onMagenta.bold(' dir ')),
    question: () => print('This is password: '),
    defaultValue: 'secret-or-us',
    isSecretive: true,
    gap: 2,
    width: 20,
    callback: (value) => dir.update(value),
  );

  List<String> selectedFruits = multipleSelect(
    label: () => print(chalk.black.onGreen.bold(' state_manager ')),
    question: () => print('Select your favorite fruits multiple:'),
    options: ["Apple", "Banana", "Cherry"],
    gap: 2,
    width: 20,
    callback: (selected) {
      print('Selected fruits: ${selected.join(", ")}');
    },
  );

  print('Selected fruits: ${selectedFruits.join(", ")}');
  print(stateManager.state);
  stdout.writeln();
  print(dir.state);
}
