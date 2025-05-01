/// Adapter for the 'args' package.
///
/// This class implements the [ArgumentParser] interface using the 'args'
/// package, providing a default argument parsing implementation for the CLI
/// framework.
library;

import 'package:args/args.dart';

import 'argument_parser.dart';

/// An implementation of [ArgumentParser] that uses the 'args' package.
///
/// This is the default argument parser for the CLI framework.
class ArgsAdapter implements ArgumentParser<ArgResults> {
  final ArgParser _parser;

  /// Creates a new [ArgsAdapter].
  ArgsAdapter() : _parser = ArgParser();

  /// Returns the underlying [ArgParser] instance.
  ///
  /// This can be used to access features of the 'args' package that are not
  /// exposed by the [ArgumentParser] interface.
  ArgParser get parser => _parser;

  @override
  String get usage => _parser.usage;

  @override
  void addFlag(
    String name, {
    String? abbr,
    String? help,
    bool defaultsTo = false,
    bool negatable = true,
    bool hide = false,
  }) {
    _parser.addFlag(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      negatable: negatable,
      hide: hide,
    );
  }

  @override
  void addMultiOption(
    String name, {
    String? abbr,
    String? help,
    List<String>? defaultsTo,
    bool mandatory = false,
    List<String>? allowed,
    Map<String, String>? allowedHelp,
    String? valueHelp,
    bool hide = false,
  }) {
    _parser.addMultiOption(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      allowed: allowed,
      allowedHelp: allowedHelp,
      valueHelp: valueHelp,
      hide: hide,
    );
  }

  @override
  void addOption(
    String name, {
    String? abbr,
    String? help,
    String? defaultsTo,
    bool mandatory = false,
    List<String>? allowed,
    Map<String, String>? allowedHelp,
    String? valueHelp,
    bool hide = false,
  }) {
    _parser.addOption(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      allowed: allowed,
      allowedHelp: allowedHelp,
      valueHelp: valueHelp,
      hide: hide,
    );
  }

  @override
  ArgResults parse(List<String> args) {
    return _parser.parse(args);
  }
}
