import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String userIdKey = "USERKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";
  static const String userWalletKey = "USERWALLETKEY";
  static const String userProfileKey = "USERPROFILEKEY";
  static const String userRoleKey = "USERROLEKEY";

  // Helper method to get the SharedPreferences instance
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Generic method to save data to SharedPreferences
  Future<bool> saveData(String key, String? value) async {
    SharedPreferences prefs = await _getPrefs();
    if (value == null) return prefs.remove(key); // If value is null, remove the key
    return prefs.setString(key, value); // Save the value for the key
  }

  // Generic method to get data from SharedPreferences
  Future<String?> getData(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.getString(key);
  }

  // Save user data
  Future<bool> saveUserId(String userId) => saveData(userIdKey, userId);
  Future<bool> saveUserName(String userName) => saveData(userNameKey, userName);
  Future<bool> saveUserEmail(String userEmail) => saveData(userEmailKey, userEmail);
  Future<bool> saveUserWallet(String userWallet) => saveData(userWalletKey, userWallet);
  Future<bool> saveUserProfile(String userProfile) => saveData(userProfileKey, userProfile);
  Future<bool> saveUserRole(String userRole) => saveData(userRoleKey, userRole);

  // Get user data
  Future<String?> getUserId() => getData(userIdKey);
  Future<String?> getUserName() => getData(userNameKey);
  Future<String?> getUserEmail() => getData(userEmailKey);
  Future<String?> getUserWallet() => getData(userWalletKey);
  Future<String?> getUserProfile() => getData(userProfileKey);
  Future<String?> getUserRole() => getData(userRoleKey);

  // Remove user data
  Future<bool> removeUserData(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.remove(key); // Removes the value for the key
  }

  // Remove all user data
  Future<bool> clearAllData() async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.clear(); // Clears all the stored preferences
  }
}
