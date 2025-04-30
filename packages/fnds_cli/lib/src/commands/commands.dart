/// Command-related classes and utilities for the CLI framework.
///
/// This library provides the base structure for creating command-line
/// interfaces with nested command support.
library;

import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../errors/errors.dart';
import '../inputs/inputs.dart';
import '../logging/logging.dart';
import '../utils/utils.dart';

part 'base_command.dart';
part 'command_runner.dart';
part 'interactive_fallback.dart';
part 'nested_command.dart';

/// Global state manager for CLI flags and options
final cliStateManager = StateManager([]);
