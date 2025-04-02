# Friendly CLI for Dart

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

## Installation

### Using CLI Command

```
dart pub get fnds_cli
```

### Manual Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  fnds_cli: ^0.5.0
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
```

or you can directly store it to a variable

```dart
  String answer = ask<String>(
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

  print('answer is: $answer');
```

## Why Use This?

- **Developer-friendly**: Simple API with a smooth UX.
- **Efficient**: Built to be performant and lightweight.
- **Inspired by AstroJS CLI**: Brings a refined selection experience to Dart CLIs.

## Special Thanks

- Those who built **AstroJS** and the CLI that powered it.
- **DCLI package** contributors that became my basic knowledge on how FNDS_CLI 
- My Wife who always encouraged me to always build something for the community.

## License

MIT License (placed at the root of monorepo)

## Changelog
### [0.2.0] - 2025-04-02
#### Added
- Initial release of FNDS CLI with interactive selection and question prompts.
- Support for `ask`, `confirm`, `select`, and `multipleSelect` functions.
- Integration with `StateManager` for structured responses.


