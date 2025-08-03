import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {
  static Future<void> saveUserData(
      String photoUrl, String username, String gmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('photoUrl', photoUrl);
    await prefs.setString('username', username);
    await prefs.setString('gmail', gmail);
  }

  static Future<String?> getPhotoUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('photoUrl');
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getGmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gmail');
  }
}
