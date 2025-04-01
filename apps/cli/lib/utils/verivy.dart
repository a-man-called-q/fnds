part of 'utils.dart';

Future<void> verify({
  required String connectedMessage,
  required String notConnectedMessage,
}) async {
  if (await _isConnectedToAddress('brickhub.dev')) {
    print(connectedMessage);
    return;
  }
  print(notConnectedMessage);
  exit(1);
}

Future<bool> _isConnectedToAddress(String address) async {
  try {
    final result = await InternetAddress.lookup(address);
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}
