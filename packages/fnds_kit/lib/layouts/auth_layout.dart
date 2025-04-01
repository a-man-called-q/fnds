import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

part 'widgets/auth_layout_widgets.dart';

class AuthLayout extends StatelessWidget {
  final Widget logo;
  final EdgeInsets padding;
  final Form form;
  final Widget? additionalContent;
  final double spacing;

  const AuthLayout({
    super.key,
    required this.form,
    this.spacing = 5,
    required this.logo,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoints = context.theme.breakpoints; // FBreakpoints
    final width = MediaQuery.sizeOf(context).width; // double

    return switch (width) {
      _ when width < breakpoints.sm => AuthMobileWidget(
        logo: logo,
        padding: padding,
        form: form,
        additionalContent: additionalContent,
        spacing: spacing,
      ),
      _ when width < breakpoints.lg => AuthTabletWidget(
        logo: logo,
        padding: padding,
        form: form,
        additionalContent: additionalContent,
        spacing: spacing,
      ),
      _ => AuthTabletWidget(
        logo: logo,
        padding: padding,
        form: form,
        additionalContent: additionalContent,
        spacing: spacing,
      ),
    };
  }
}
