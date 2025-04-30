/// Utilities and state management for CLI applications.
///
/// The utils module provides core functionality for managing state and data structures
/// within CLI applications. It includes:
///
/// - The [StateManager] class for tracking and retrieving CLI inputs
/// - State model classes ([CLIState], [SingleCLIState], [GroupCLIState]) to represent different types of input states
/// - Width specifications ([Width], [AutoWidth], [IntWidth]) for layout calculations
///
/// This module works alongside the inputs and layouts modules to create robust,
/// state-aware CLI applications that can track user inputs across multiple prompts.
library;

import 'dart:async';

part 'models.dart';
part 'state_manager.dart';
