# Your Friendly CLI for Dart

[![pub version](https://img.shields.io/pub/v/fnds_cli.svg)](https://pub.dev/packages/fnds_cli)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/amancalledq)

> **Note:** This package is still in early development (pre-0.10.0) and may not function as expected in all scenarios. The examples provided are for reference, and we encourage you to test them and report any issues. Feedback and feature requests are highly appreciated in the [GitHub issue tracker](https://github.com/a-man-called-q/fnds/issues).

A lightweight and intuitive CLI package for Dart, inspired by the user-friendly experience of the **AstroJS** CLI.

I am not an expert programmer and it's been a while since I start learning Flutter. Out of nowhere, I decided to build a boilerplate for starting Flutter project and I decided to build somekind of CLI to help scaffold and helps the project. I learned that there are not many CLI Framework in Dart ecosystem that suits me.

## Why FNDS ?

FNDS actually meant **"Fondasi" /fɔnˈdasi/**, an Indonesian word for *Foundation*. and it fits me well since it can be also meant *Flutter N Dart Stuff*. (Yes, I'm bad at naming things).

Fondasi is meant to be a starter for things built in Dart to make Dart and Flutter apps. I Hope this can help you as well.

## Features

- **Lightweight**: Minimal dependencies for fast execution.
- **Interactive Selection**: Navigate using arrow keys, select with enter, and support for mouse interactions.
- **Non-intrusive Rendering**: Renders only the selection UI without affecting previous lines.
- **Formatted Output**: Works seamlessly with the `row` function for structured results.
- **Consistent API**: Follows the structure of the `ask` function for a familiar developer experience.
- **Non-interactive Mode**: Support for automated and scripted workflows with CLI flags.
- **Deep Command Nesting**: Create complex command hierarchies with unlimited nesting levels.

## Installation

### Using CLI Command

```
dart pub get fnds_cli
```

### Manual Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  fnds_cli: ^0.3.0
```

Then run:

```sh
dart pub get
```

## Usage

You can use the `StateManager` to make things easier

```dart
StateManager statesManager = StateManager([]);

  ask<String>(
    label: chalk.black.onMagenta.bold(' testing-ask '),
    question: 'You can ask anything and making sure the response is the correct type',
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
    question: 'This is when you are using password mode ${chalk.bold('(isSecretive set to true)')}:',
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
```

or you can directly store it to a variable

```dart
  String answer = ask<String>(
    label: chalk.black.onMagenta.bold(' testing-ask '),
    question: 'You can ask anything and making sure the response is the correct type',
    defaultValue: 'the reply is supposed to be a string',
    gap: 2,
    width: 20,
    callback: (result) => statesManager.addMember(result),
  );

  print('answer is: $answer');
```

## Non-Interactive CLI Usage

For automated or scripted workflows, you can run commands in non-interactive mode:

```dart
void main(List<String> args) async {
  // Create a command runner with interactive mode disabled
  final runner = CliCommandRunner(
    'my-cli',
    'A CLI application with non-interactive support',
    enableLogging: true,
    useInteractiveFallback: false, // Disable interactive mode
  );

  // Add commands
  runner.addBaseCommand(MyCommand());
  
  // Run the command with all arguments provided
  await runner.run(['command', '--option1', 'value1', '--flag1']);
}

// Example command implementation
class MyCommand extends BaseCommand {
  @override
  String get name => 'command';

  @override
  String get description => 'An example command';

  @override
  Future<int> execute() async {
    // Get arguments without interactive fallback
    final option1 = getArg<String>('option1');
    final flag1 = getArg<bool>('flag1');
    
    logger.info('Running command with option1=$option1 and flag1=$flag1');
    
    // Do something with the arguments
    return 0; // Success exit code
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);
    
    // Define command arguments
    argParser.addOption('option1', help: 'An example option');
    argParser.addFlag('flag1', help: 'An example flag');
  }
}
```

You can also toggle interactive mode with a CLI flag:

```dart
void main(List<String> args) async {
  // Create a command runner with interactive mode enabled by default
  final runner = CliCommandRunner(
    'my-cli',
    'A CLI application with configurable interactive mode',
    enableLogging: true,
    useInteractiveFallback: true,
  );

  // Add custom flag to disable interactive mode
  runner.argParser.addFlag(
    'non-interactive',
    abbr: 'n',
    help: 'Disable interactive prompts',
    negatable: false,
    callback: (value) {
      if (value) {
        // Override the interactive flag if -n is provided
        cliStateManager.addMember(SingleCLIState<bool>('interactive', false));
      }
    },
  );
  
  // Add commands
  runner.addBaseCommand(MyCommand());
  
  // Run with arguments
  await runner.run(args);
}
```

## Creating a CLI Application

You can create a full-featured CLI application with commands and subcommands:

```dart
void main(List<String> args) async {
  // Create a command runner with logging and interactive fallback
  final runner = CliCommandRunner(
    'my-cli',
    'A CLI application using fnds_cli framework',
    enableLogging: true,
    useInteractiveFallback: true,
  );

  // Add commands
  runner.addBaseCommand(MyCommand());
  
  // Run the command with the provided arguments
  await runner.run(args);
}
```

## Platform Support

This package supports desktop platforms:
- Windows
- macOS
- Linux

## Why Use This?

- **Developer-friendly**: Simple API with a smooth UX.
- **Efficient**: Built to be performant and lightweight.
- **Inspired by AstroJS CLI**: Brings a refined selection experience to Dart CLIs.
- **Command Framework**: Built-in support for complex command hierarchies.

## Special Thanks

- Those who built **AstroJS** and the CLI that powered it.
- **DCLI package** contributors that became my basic knowledge on how to create FNDS_CLI 
- My Wife who always encouraged me to always build something for the community.

## License

MIT License (placed at the root of monorepo)


