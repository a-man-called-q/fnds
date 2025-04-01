part of '../auth_layout.dart';

class AuthDesktopWidget extends StatelessWidget {
  const AuthDesktopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AuthMobileWidget extends StatelessWidget {
  final Widget logo;
  final EdgeInsets padding;
  final Form form;
  final double spacing;
  final Widget? additionalContent;
  const AuthMobileWidget({
    super.key,
    required this.logo,
    required this.padding,
    required this.form,
    this.additionalContent,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        direction: Axis.vertical,
        spacing: spacing,
        children: [
          logo,
          form,
          if (additionalContent != null) additionalContent!,
        ],
      ),
    );
  }
}

class AuthTabletWidget extends StatelessWidget {
  final Widget logo;
  final EdgeInsets padding;
  final Form form;
  final double spacing;
  final Widget? additionalContent;
  const AuthTabletWidget({
    super.key,
    required this.logo,
    required this.padding,
    required this.form,
    required this.spacing,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AuthMobileWidget(
          logo: logo,
          padding: padding,
          form: form,
          spacing: spacing,
        ),
        Expanded(child: Center(child: additionalContent)),
      ],
    );
  }
}
