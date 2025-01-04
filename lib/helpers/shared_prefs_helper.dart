import 'package:passwordmanager/global_dirs.dart';

class SharedPrefsHelper {
  final dbHelper = UserDatabaseHelper();

  void getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user =
        await dbHelper.loginName(Global.savedValues['username']);
    Global.savedValues['auth'] = prefs.getBool('auth${user['id']}') ?? false;
    Global.savedValues['rememberUsername'] = prefs.getBool('remember${user['id']}') ?? false;
  }
}
