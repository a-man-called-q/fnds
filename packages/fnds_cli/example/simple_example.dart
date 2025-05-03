import 'package:args/args.dart';
import 'package:fnds_cli/fnds_cli.dart';

void main(List<String> args) async {
  // Create a command runner with a simple name and description
  final runner = CliCommandRunner(
    'simple-cli',
    'A simple CLI demonstrating interactive fallback in fnds_cli',
    // Enable logging and interactive fallback by default
    enableLogging: true,
    useInteractiveFallback: true,
  );

  // Add the project command to the runner
  runner.addBaseCommand(ProjectCommand());

  // Run the command with the provided arguments
  await runner.run(args);
}

/// A simple command that demonstrates various interactive input types
class ProjectCommand extends BaseCommand {
  @override
  String get description => 'Create or configure a project';

  @override
  String get name => 'project';

  @override
  Future<int> execute() async {
    // Get arguments with fallback to interactive prompts if not provided
    final projectName = getArg<String>('name');
    final projectType = getArg<String>('type');
    final isPrivate = getArg<bool>('private') ?? false;

    // Use this approach to handle List<dynamic> correctly
    final dynamicFrameworks = getArg<dynamic>('frameworks');
    final List<String> frameworks;
    if (dynamicFrameworks is List) {
      frameworks = dynamicFrameworks.map((item) => item.toString()).toList();
    } else {
      frameworks = <String>[];
    }

    // Display the project configuration
    logger.info('Creating new project:');
    logger.info('- Name: $projectName');
    logger.info('- Type: $projectType');
    logger.info('- Private: ${isPrivate ? "Yes" : "No"}');

    if (frameworks.isNotEmpty) {
      logger.info('- Frameworks: ${frameworks.join(", ")}');
    } else {
      logger.info('- Frameworks: None');
    }

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Required project name with no default (forces interactive prompt if not provided)
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'Name of the project',
      mandatory: true, // Mark as mandatory to ensure interactive fallback
    );
    // Set up interactive fallback for project name using text input
    setInteractiveFallback(
      'name',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'What would you like to name your project?',
        defaultValue: 'my-awesome-project',
        label: 'Project Name',
      ),
    );

    // Project type with dropdown selection
    argParser.addOption(
      'type',
      abbr: 't',
      help: 'Type of project to create',
      allowed: ['web', 'mobile', 'desktop', 'library'],
      mandatory: true, // Mark as mandatory to ensure interactive fallback
    );
    // Set up interactive fallback for project type using selection menu
    setInteractiveFallback(
      'type',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'What type of project would you like to create?',
        options: <String>['web', 'mobile', 'desktop', 'library'],
        defaultValue: 'web',
        label: 'Project Type',
      ),
    );

    // Boolean flag for project privacy
    argParser.addFlag(
      'private',
      help: 'Whether the project is private',
      defaultsTo: false,
    );
    // Set up interactive fallback for private flag using confirmation dialog
    setInteractiveFallback(
      'private',
      InteractiveFallback<bool>(
        inputType: InteractiveInputType.confirm,
        question: 'Should this project be private?',
        defaultValue: false,
      ),
    );

    // Multiple selection for frameworks
    argParser.addMultiOption(
      'frameworks',
      abbr: 'f',
      help: 'Frameworks to include in the project',
    );
    // Set up interactive fallback for frameworks using multiple selection menu
    setInteractiveFallback(
      'frameworks',
      InteractiveFallback<List<String>>(
        inputType: InteractiveInputType.multipleSelect,
        question: 'Select frameworks to include:',
        options: <String>['React', 'Angular', 'Vue', 'Flutter', 'Express'],
      ),
    );
  }
}
