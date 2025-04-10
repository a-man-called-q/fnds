# fnds_logger

💡 A multi-platform, plug-and-play, ultra-lightweight logger for Flutter & Dart backend apps.

Powered by [Drift](https://drift.simonbinder.eu/) with conditional platform support, it's ideal for saving logs locally and shipping them to servers.

---

## ✨ Features

- ✅ Works on both Flutter *and* backend
- ✅ Stores logs using SQLite
- ✅ Auto-prunes logs older than 7 days
- ✅ Upload/export logs easily
- ✅ Tiny footprint

---

## 🚀 Getting Started

### 1. Install
```yaml
dependencies:
  fnds_logger:
    git:
      url: https://github.com/yourusername/fnds_logger.git
```

### 2. Generate Database Code
Run this **before publishing**, not on user side:
```bash
dart run build_runner build --delete-conflicting-outputs
```

If using locally in a Flutter project, your users also need to run the build runner once.

---

## 🛠️ Usage

```dart
import 'package:fnds_logger/fnds_logger.dart';

void main() async {
  final logger = FndsLogger.instance;

  await logger.info("Everything is fine 😌", tag: 'init');
  await logger.warning("Heads up!", tag: 'auth');
  await logger.error("Boom 💥", error: Exception("Crash!"));
}
```

---

## 🧪 Export Logs to File
```dart
final file = await FndsLogger.instance.exportLogsToFile('logs.txt');
print('Logs exported to: \${file.path}');
```

## ☁️ Upload Logs
```dart
await FndsLogger.instance.uploadLogs(Uri.parse('https://example.com/logs'));
```

---

## 🔎 Query Logs
```dart
final logs = await FndsLogger.instance.queryLogs(tag: 'auth');
```

## ❤️ Credits
My wife who always encourage me to contribute back to society