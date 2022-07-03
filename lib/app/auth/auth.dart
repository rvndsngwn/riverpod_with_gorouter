import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String name;
  final String email;

  const User({required this.name, required this.email});
}

class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> login(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('email', true);
    // This mocks some sort of request / response
    state = const User(
      name: "My Name",
      email: "My Email",
    );
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('email', false);
    // In this example user==null iff we're logged out
    state = null; // No request is mocked here but I guess we could
  }

  Future<void> isAuthenticated() async {
    final SharedPreferences prefs = await _prefs;
    final bool isData = prefs.getBool('email') ?? false;

    if (!isData) {
      state = null;
      return;
    }
    state = const User(
      name: "My Name",
      email: "My Email",
    );
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});
