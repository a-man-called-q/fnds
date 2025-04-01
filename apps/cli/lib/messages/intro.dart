part of 'messages.dart';

Future<void> intro() async {
  await typewriter(
    "Welcome ${await getName()}, to ${chalk.black.onOrange.bold('FNDS')} v1.0.0!",
    resetAfterFinished: true,
  );
  await typewriter(
    "Now let's build a cross-platform app !",
    resetAfterFinished: true,
  );
}
