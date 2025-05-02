import 'package:args/args.dart';
import 'package:fnds_cli/fnds_cli.dart';

void main(List<String> args) async {
  // Create a command runner for a culinary adventure CLI
  final runner = CliCommandRunner(
    'food-adventure',
    'A culinary adventure CLI application using fnds_cli framework',
    // Enable logging by default
    enableLogging: true,
    // Enable interactive fallback by default (use -c to disable)
    useInteractiveFallback: true,
  );

  // Add first-level commands
  runner.addBaseCommand(EatCommand());
  runner.addBaseCommand(DrinkCommand());
  runner.addBaseCommand(TalkCommand());
  runner.addBaseCommand(SeeCommand());

  // Add a custom option to disable interactive mode with -c flag
  runner.argParser.addFlag(
    'console-only',
    abbr: 'c',
    help: 'Disable interactive fallback mode',
    negatable: false,
    callback: (value) {
      if (value) {
        // Override the interactive flag if -c is provided
        cliStateManager.addMember(SingleCLIState<bool>('interactive', false));
      }
    },
  );

  // Run the command
  await runner.run(args);
}

/// Second-level command under Talk
class ChefCommand extends BaseCommand {
  @override
  String get description => 'Talk to the chef';

  @override
  String get name => 'chef';

  @override
  Future<int> execute() async {
    final compliment = getArg<String>('compliment') ?? '';
    final feedback = getArg<String>('feedback') ?? '';

    logger.info('Complimenting chef: $compliment');
    logger.info('Feedback: $feedback');

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add compliment option
    argParser.addOption('compliment', help: 'Compliment for the chef');
    // Configure interactive fallback for compliment
    setInteractiveFallback(
      'compliment',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'What would you like to compliment the chef on?',
        defaultValue: 'Excellent meal',
      ),
    );

    // Add feedback option
    argParser.addOption('feedback', help: 'Specific feedback for the chef');
    // Configure interactive fallback for feedback with validation logic
    // (The validation happens in the CommandRunner before it reaches here)
    setInteractiveFallback(
      'feedback',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'Any specific feedback for the chef?',
        defaultValue: 'The meal was perfect',
      ),
    );
  }
}

/// Second-level command under Drink
class ColdDrinkCommand extends BaseCommand {
  @override
  String get description => 'Order a cold drink';

  @override
  String get name => 'cold';

  @override
  Future<int> execute() async {
    // Remove defaults here to ensure interactive prompts appear
    final drinkChoice = getArg<String>('drink-choice');
    final ice = getArg<String>('ice');
    final withStraw = getArg<bool>('with-straw');
    final discountCode = getArg<String>('discount-code') ?? '';

    logger.info(
      'Ordering ${drinkChoice ?? "Unknown drink"} with ${ice ?? "no"} ice',
    );
    logger.info('With straw: ${withStraw ?? false}');
    if (discountCode.isNotEmpty) {
      logger.info('Discount code applied');
    }

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add drink-choice option - remove defaultsTo
    argParser.addOption(
      'drink-choice',
      help: 'Type of cold drink',
      allowed: ['Cola', 'Lemonade', 'Iced tea', 'Water'],
      // Remove defaultsTo to force interactive prompt
    );
    // Configure interactive fallback for drink-choice
    setInteractiveFallback(
      'drink-choice',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'Select a cold drink:',
        options: <String>['Cola', 'Lemonade', 'Iced tea', 'Water'],
        defaultValue: 'Water',
        label: 'Drink',
      ),
    );

    // Add ice option - remove defaultsTo
    argParser.addOption(
      'ice',
      help: 'Amount of ice',
      allowed: ['none', 'light', 'normal', 'extra'],
      // Remove defaultsTo to force interactive prompt
    );
    // Add interactive fallback for ice
    setInteractiveFallback(
      'ice',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'How much ice would you like?',
        options: <String>['none', 'light', 'normal', 'extra'],
        defaultValue: 'normal',
        label: 'Ice Amount',
      ),
    );

    // Add with-straw flag - remove defaultsTo
    argParser.addFlag('with-straw', help: 'Include a straw');
    // Add interactive fallback for with-straw
    setInteractiveFallback(
      'with-straw',
      InteractiveFallback<bool>(
        inputType: InteractiveInputType.confirm,
        question: 'Would you like a straw?',
        defaultValue: true,
      ),
    );

    // Add discount-code option
    argParser.addOption('discount-code', help: 'Discount code (if any)');
    // Configure interactive fallback for discount-code
    // Using ask with secretive=true for password-like input
    setInteractiveFallback(
      'discount-code',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'Enter discount code (if any):',
        defaultValue: '',
      ),
    );
  }
}

/// First-level command: Drink
class DrinkCommand extends NestedCommand {
  @override
  String get description => 'Commands related to drinks';

  @override
  String get name => 'drink';

  @override
  void addSubcommands() {
    addSubcommand(HotDrinkCommand());
    addSubcommand(ColdDrinkCommand());
  }
}

/// First-level command: Eat
class EatCommand extends NestedCommand {
  @override
  String get description => 'Commands related to eating food';

  @override
  String get name => 'eat';

  @override
  void addSubcommands() {
    addSubcommand(MealCommand());
    addSubcommand(SnackCommand());
  }
}

/// Second-level command under Drink
class HotDrinkCommand extends BaseCommand {
  @override
  String get description => 'Order a hot drink';

  @override
  String get name => 'hot';

  @override
  Future<int> execute() async {
    final drinkName = getArg<String>('drink-name') ?? 'coffee';
    final temperature = getArg<String>('temperature') ?? 'hot';
    final toGo = getArg<bool>('to-go') ?? false;
    final confirm = getArg<bool>('confirm') ?? true;

    if (confirm) {
      logger.info('Ordering $temperature $drinkName');
      logger.info('To go: $toGo');
    } else {
      logger.info('Order cancelled');
    }

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add drink-name option
    argParser.addOption('drink-name', help: 'Type of hot drink');
    // Configure interactive fallback for drink-name
    setInteractiveFallback(
      'drink-name',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'What hot drink would you like?',
        defaultValue: 'coffee',
        label: 'Drink',
      ),
    );

    // Add temperature option
    argParser.addOption(
      'temperature',
      help: 'Drink temperature',
      allowed: ['hot', 'very-hot', 'warm'],
      defaultsTo: 'hot',
    );

    // Add to-go flag
    argParser.addFlag('to-go', help: 'Get drink to go', defaultsTo: false);

    // Add confirm flag
    argParser.addFlag('confirm', help: 'Confirm your order', defaultsTo: true);
    // Configure interactive fallback for confirm
    setInteractiveFallback(
      'confirm',
      InteractiveFallback<bool>(
        inputType: InteractiveInputType.confirm,
        question: 'Confirm your order?',
        defaultValue: true,
      ),
    );
  }
}

/// Second-level command under See
class LocationsCommand extends BaseCommand {
  @override
  String get description => 'View restaurant locations';

  @override
  String get name => 'locations';

  @override
  Future<int> execute() async {
    final nearby = getArg<bool>('nearby') ?? false;
    final zipCode = getArg<String>('zip-code') ?? '10001';
    final confirmSearch = getArg<bool>('confirm-search') ?? true;

    if (confirmSearch) {
      logger.info(
        'Searching for ${nearby ? "nearby " : ""}locations near $zipCode',
      );
    } else {
      logger.info('Location search cancelled');
    }

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add nearby flag
    argParser.addFlag(
      'nearby',
      help: 'Show only nearby locations',
      defaultsTo: false,
    );

    // Add zip-code option
    argParser.addOption('zip-code', help: 'ZIP code to search near');
    // Configure interactive fallback for zip-code
    // Using ask for potentially sensitive data
    setInteractiveFallback(
      'zip-code',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'Enter your zip code to find nearby locations:',
        defaultValue: '10001',
      ),
    );

    // Add confirm-search flag
    argParser.addFlag(
      'confirm-search',
      help: 'Confirm location search',
      defaultsTo: true,
    );
    // Configure interactive fallback for confirm-search
    setInteractiveFallback(
      'confirm-search',
      InteractiveFallback<bool>(
        inputType: InteractiveInputType.confirm,
        question: 'Search for locations?',
        defaultValue: true,
      ),
    );
  }
}

/// Second-level command under Eat
class MealCommand extends BaseCommand {
  @override
  String get description => 'Order a complete meal';

  @override
  String get name => 'meal';

  @override
  Future<int> execute() async {
    final cuisine = getArg<String>('cuisine') ?? 'italian';
    final mealType = getArg<String>('meal-type') ?? 'dinner';
    final sides = getArg<List<String>>('sides') ?? ['salad', 'bread'];
    final specialRequests = getArg<String>('special-requests') ?? 'None';
    final drink = getArg<String>('drink') ?? 'Water';
    final dessert = getArg<bool>('dessert') ?? false;

    logger.info('Ordering $cuisine $mealType:');
    logger.info('- Side dishes: ${sides.join(", ")}');
    logger.info('- Drink pairing: $drink');
    logger.info('- Dessert: ${dessert ? "Yes" : "No"}');
    logger.info('- Special requests: $specialRequests');

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add cuisine option
    argParser.addOption(
      'cuisine',
      abbr: 'u',
      help: 'Type of cuisine',
      allowed: ['italian', 'mexican', 'japanese', 'indian'],
    );
    // Configure interactive fallback for cuisine
    setInteractiveFallback(
      'cuisine',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'What type of cuisine would you like?',
        options: <String>['italian', 'mexican', 'japanese', 'indian'],
        label: 'Cuisine',
      ),
    );

    // Add meal-type option
    argParser.addOption(
      'meal-type',
      help: 'Type of meal',
      allowed: ['breakfast', 'lunch', 'dinner'],
    );
    // Configure interactive fallback for meal-type
    setInteractiveFallback(
      'meal-type',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'Which meal are you ordering?',
        options: <String>['breakfast', 'lunch', 'dinner'],
        label: 'Meal Type',
      ),
    );

    // Add sides option
    argParser.addMultiOption(
      'sides',
      help: 'Side dishes to include',
      defaultsTo: ['salad', 'bread'],
    );

    // Add special requests option
    argParser.addOption(
      'special-requests',
      help: 'Any special requests for your meal',
    );
    // Configure interactive fallback for special-requests
    setInteractiveFallback(
      'special-requests',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.ask,
        question: 'Any special requests for your meal?',
        defaultValue: 'None',
      ),
    );

    // Add drink option
    argParser.addOption(
      'drink',
      help: 'Drink pairing for your meal',
      allowed: ['Wine', 'Beer', 'Water', 'Juice', 'Coffee'],
      defaultsTo: 'Water',
    );
    // Configure interactive fallback for drink
    setInteractiveFallback(
      'drink',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'Choose a drink pairing:',
        options: <String>['Wine', 'Beer', 'Water', 'Juice', 'Coffee'],
        defaultValue: 'Water',
        label: 'Drink',
      ),
    );

    // Add dessert flag
    argParser.addFlag(
      'dessert',
      help: 'Include dessert with your meal',
      defaultsTo: false,
    );
    // Configure interactive fallback for dessert
    setInteractiveFallback(
      'dessert',
      InteractiveFallback<bool>(
        inputType: InteractiveInputType.confirm,
        question: 'Would you like dessert with your meal?',
        defaultValue: false,
      ),
    );
  }
}

/// Second-level command under See
class MenuCommand extends BaseCommand {
  @override
  String get description => 'View the menu';

  @override
  String get name => 'menu';

  @override
  Future<int> execute() async {
    final category = getArg<String>('category') ?? 'all';
    final showPrices = getArg<bool>('prices') ?? true;

    logger.info('Showing $category menu');
    if (showPrices) {
      logger.info('Prices included');
    }

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add category option
    argParser.addOption(
      'category',
      help: 'Menu category to view',
      allowed: ['appetizers', 'mains', 'desserts', 'drinks', 'all'],
      defaultsTo: 'all',
    );

    // Add prices flag
    argParser.addFlag('prices', help: 'Show prices', defaultsTo: true);
  }
}

/// First-level command: See
class SeeCommand extends NestedCommand {
  @override
  String get description =>
      'Commands related to viewing restaurant information';

  @override
  String get name => 'see';

  @override
  void addSubcommands() {
    addSubcommand(MenuCommand());
    addSubcommand(LocationsCommand());
  }
}

/// Second-level command under Eat
class SnackCommand extends BaseCommand {
  @override
  String get description => 'Get a quick snack';

  @override
  String get name => 'snack';

  @override
  Future<int> execute() async {
    final snackType = getArg<String>('snack-type') ?? 'sweet';
    final toGo = getArg<bool>('to-go') ?? true;
    final toppings = getArg<List<String>>('toppings') ?? <String>[];

    logger.info('Getting a $snackType snack');
    logger.info('To go: $toGo');
    if (toppings.isNotEmpty) {
      logger.info('Toppings: ${toppings.join(", ")}');
    }

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add snack-type option
    argParser.addOption(
      'snack-type',
      help: 'Type of snack',
      allowed: ['sweet', 'savory', 'healthy', 'indulgent'],
    );
    // Configure interactive fallback for snack-type
    setInteractiveFallback(
      'snack-type',
      InteractiveFallback<String>(
        inputType: InteractiveInputType.select,
        question: 'What type of snack would you like?',
        options: <String>['sweet', 'savory', 'healthy', 'indulgent'],
        label: 'Snack Type',
      ),
    );

    // Add to-go flag
    argParser.addFlag('to-go', help: 'Get snack to go', defaultsTo: true);

    // Add toppings option
    argParser.addMultiOption(
      'toppings',
      help: 'Toppings for your snack',
      defaultsTo: [],
    );
    // Configure interactive fallback for toppings
    setInteractiveFallback(
      'toppings',
      InteractiveFallback<List<String>>(
        inputType: InteractiveInputType.multipleSelect,
        question: 'Choose toppings for your snack:',
        options: <List<String>>[
          ['Chocolate'],
          ['Nuts'],
          ['Fruit'],
          ['Caramel'],
          ['Sprinkles'],
        ],
      ),
    );
  }
}

/// First-level command: Talk
class TalkCommand extends NestedCommand {
  @override
  String get description => 'Commands related to talking to staff';

  @override
  String get name => 'talk';

  @override
  void addSubcommands() {
    addSubcommand(WaiterCommand());
    addSubcommand(ChefCommand());
  }
}

/// Second-level command under Talk
class WaiterCommand extends BaseCommand {
  @override
  String get description => 'Talk to a waiter';

  @override
  String get name => 'waiter';

  @override
  Future<int> execute() async {
    final urgency = getArg<String>('urgency') ?? 'low';
    final topics = getArg<List<String>>('topics') ?? <String>[];

    logger.info('Calling waiter with $urgency urgency');
    logger.info('Topics to discuss: ${topics.join(", ")}');

    return 0;
  }

  @override
  void setupArgs(ArgParser argParser) {
    super.setupArgs(argParser);

    // Add urgency option
    argParser.addOption(
      'urgency',
      help: 'Level of urgency',
      allowed: ['low', 'medium', 'high'],
      defaultsTo: 'low',
    );

    // Add topics option
    argParser.addMultiOption('topics', help: 'Topics to discuss with waiter');
    // Configure interactive fallback for topics
    setInteractiveFallback(
      'topics',
      InteractiveFallback<List<String>>(
        inputType: InteractiveInputType.multipleSelect,
        question: 'What would you like to talk about?',
        options: <List<String>>[
          ['Menu recommendations'],
          ['Special dietary requests'],
          ['Wine pairing suggestions'],
          ['Dessert options'],
        ],
        label: 'Topics',
      ),
    );
  }
}
