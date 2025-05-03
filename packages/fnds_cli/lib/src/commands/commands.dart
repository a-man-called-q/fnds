/// Entry point for the commands module.
///
/// This library provides the foundational classes and utilities for building
/// CLI commands, including support for nested commands, interactive fallbacks,
/// and argument parsing.
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
part 'helpers.dart';
part 'interactive_fallback.dart';
part 'nested_command.dart';

/// Global state manager for CLI flags and options
final cliStateManager = StateManager([]);
