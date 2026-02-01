import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static Future<void> saveUserData(String userName, String vehicleType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
    await prefs.setString('vehicle_type', vehicleType);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<String?> getVehicleType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('vehicle_type');
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
