import 'package:fnds_cli/fnds_cli.dart';

void main(List<String> args) async {
  // Create a command runner
  final runner = CliCommandRunner(
    'example',
    'A sample CLI application using fnds_cli framework',
    // Enable colored logging by default
    enableLogging: true,
  );

  // Add commands to the runner
  runner.addBaseCommand(CreateCommand());

  // Run the command
  await runner.run(args);
}

/// A third-level command with additional arguments
class AuthCommand extends NestedCommand {
  @override
  String get description => 'Create an authentication-related class';

  @override
  String get name => 'auth';

  @override
  void addSubcommands() {
    addSubcommand(LogicCommand());
    addSubcommand(ProviderCommand());
  }

  @override
  void setupArgs(argParser) {
    super.setupArgs(argParser);

    argParser.addOption(
      'role',
      abbr: 'r',
      help: 'The role associated with this auth class',
      allowed: ['user', 'admin', 'guest'],
      defaultsTo: 'user',
    );
  }
}

/// A second-level command that has its own subcommands
class ClassCommand extends NestedCommand {
  @override
  String get description => 'Create a new class';

  @override
  String get name => 'class';

  @override
  void addSubcommands() {
    addSubcommand(AuthCommand());
    addSubcommand(ModelCommand());
    addSubcommand(RepositoryCommand());
  }
}

/// A root-level command that demonstrates nested commands
class CreateCommand extends NestedCommand {
  @override
  String get description => 'Create a new resource';

  @override
  String get name => 'create';

  @override
  void addSubcommands() {
    addSubcommand(ClassCommand());
  }
}

/// A fourth-level command that performs an action
class LogicCommand extends BaseCommand {
  @override
  String get description => 'Create an auth logic class';

  @override
  String get name => 'logic';

  @override
  Future<int> execute() async {
    final output = argResults!['output'] as String;
    final force = argResults!['force'] as bool;
    final role = parent!.argResults!['role'] as String;

    logger.info('Creating auth logic class in $output');
    logger.info('Role: $role');

    if (argResults!['verbose'] as bool) {
      logger.debug('Force overwrite: $force');
    }

    // Simulate file creation
    logger.info('Auth logic class created successfully!');
    return 0;
  }

  @override
  void setupArgs(argParser) {
    super.setupArgs(argParser);

    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The output file path',
      defaultsTo: 'lib/auth/logic.dart',
    );

    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'Force overwrite if file exists',
      negatable: false,
    );
  }
}

/// Alternative third-level commands
class ModelCommand extends BaseCommand {
  @override
  String get description => 'Create a model class';

  @override
  String get name => 'model';

  @override
  Future<int> execute() async {
    logger.info('Creating model class');
    return 0;
  }
}

/// Another fourth-level command
class ProviderCommand extends BaseCommand {
  @override
  String get description => 'Create an auth provider class';

  @override
  String get name => 'provider';

  @override
  Future<int> execute() async {
    logger.info('Creating auth provider class');
    return 0;
  }
}

class RepositoryCommand extends BaseCommand {
  @override
  String get description => 'Create a repository class';

  @override
  String get name => 'repository';

  @override
  Future<int> execute() async {
    logger.info('Creating repository class');
    return 0;
  }
}
