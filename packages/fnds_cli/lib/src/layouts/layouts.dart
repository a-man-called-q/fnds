/// Provides layout components for structured terminal output.
///
/// The layouts module contains utilities for formatting and displaying
/// text in the terminal with precise control over spacing, alignment,
/// and visual presentation.
///
/// The main component in this module is the [row] function, which creates
/// horizontally aligned columns of text with customizable widths and alignments.
/// This is particularly useful for creating tables, aligned prompts, and other
/// structured terminal output.
///
/// Use this module in conjunction with the inputs module to create
/// well-formatted, interactive CLI applications.
library;

import 'dart:io';

import 'package:ansi_strip/ansi_strip.dart';

import '../utils/utils.dart';

part 'row.dart';
