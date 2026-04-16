import 'package:shared_preferences/shared_preferences.dart';

/// Low-level SharedPreferences access.
/// Uses a String key because SharedPreferences has no BigInt support;
/// BigInt.toString() / BigInt.tryParse() handle the conversion losslessly.
class CounterLocalDatasource {
  static const String _key = 'manul_counter_v1';

  Future<BigInt> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return BigInt.zero;
    return BigInt.tryParse(stored) ?? BigInt.zero;
  }

  Future<void> saveCounter(BigInt count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, count.toString());
  }
}
