import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('launched', true);
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('launched') ?? false);
  }
}
