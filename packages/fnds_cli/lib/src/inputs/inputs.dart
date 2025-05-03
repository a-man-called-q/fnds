/// Interactive input components for command-line interfaces.
///
/// The inputs module provides a collection of functions for collecting user input
/// through interactive CLI prompts with features like:
///
/// - Type-safe input prompts with [ask]
/// - Yes/No confirmation dialogs with [confirm]
/// - Single selection menus with [select]
/// - Multiple selection interfaces with [multipleSelect]
///
/// Each function supports customization options like labels, default values,
/// and formatting preferences. The module also includes the [Indicators] class
/// for customizing the visual indicators used in selection interfaces.
///
/// This module integrates with the state management utilities to track user
/// responses across multiple prompts.
library;

import 'dart:io';

import '../layouts/layouts.dart';
import '../utils/utils.dart';

part 'ask.dart';
part 'confirm.dart';
part 'helpers.dart';
part 'models.dart';
part 'multiple_selection.dart';
part 'select.dart';
