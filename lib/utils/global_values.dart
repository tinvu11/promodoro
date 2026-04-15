import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  const GlobalValues();

  static const boughtNoAdsTimeKey = 'boughtNoAds';
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static int? get boughtNoAdsTime {
    final result = _sharedPreferences?.getInt(boughtNoAdsTimeKey);
    return result;
  }

  static Future<bool>? setBoughtNoAdsTime(int? value) {
    if (value == null) {
      return _sharedPreferences?.remove(boughtNoAdsTimeKey);
    }
    return _sharedPreferences?.setInt(boughtNoAdsTimeKey, value);
  }
}
