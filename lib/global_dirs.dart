import 'dart:collection';
import 'global_dirs.dart';
export 'package:flutter/services.dart';
export 'package:after_layout/after_layout.dart';
export 'package:flutter/material.dart';
export 'package:auto_size_text/auto_size_text.dart';
export 'package:get/get.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:local_auth/local_auth.dart';
export 'package:sqflite/sqflite.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:palette_generator/palette_generator.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:toastification/toastification.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
export 'package:password_strength_checker/password_strength_checker.dart';
export 'package:flutter_displaymode/flutter_displaymode.dart';
export 'package:flutter_animate/flutter_animate.dart';
export 'package:provider/provider.dart';
export 'package:path_provider/path_provider.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:introduction_screen/introduction_screen.dart';
export 'package:file_picker/file_picker.dart';
export 'package:gif/gif.dart';
export 'package:device_info_plus/device_info_plus.dart';

export 'package:passwordmanager/helpers/password_check.dart';
export 'package:passwordmanager/helpers/biometric_helper.dart';
export 'package:passwordmanager/widgets/title.dart';
export 'package:passwordmanager/pages/authenticate/login_username.dart';
export 'package:passwordmanager/pages/authenticate/register.dart';
export 'package:passwordmanager/pages/home.dart';
export 'package:passwordmanager/pages/password/password.dart';
export 'package:passwordmanager/pages/card/card.dart';
export 'package:passwordmanager/pages/password/edit_password.dart';
export 'package:passwordmanager/db/user_database_enc.dart';
export 'package:passwordmanager/pages/card/edit_card.dart';
export 'package:passwordmanager/db/data_enc.dart';
export 'package:passwordmanager/helpers/secure_storage.dart';
export 'package:passwordmanager/helpers/aes_helper.dart';
export 'package:passwordmanager/pages/card/cards_list.dart';
export 'package:passwordmanager/pages/password/passwords_list.dart';
export 'package:passwordmanager/helpers/recent_helper.dart';
export 'package:passwordmanager/pages/settings/security.dart';
export 'package:passwordmanager/pages/settings/app.dart';
export 'package:passwordmanager/widgets/settings.dart';
export 'package:passwordmanager/widgets/tools.dart';
export 'package:passwordmanager/pages/authenticate/login_password.dart';
export 'package:passwordmanager/pages/settings/about.dart';
export 'package:passwordmanager/helpers/fade_helper.dart';
export 'package:passwordmanager/pages/tools/generator.dart';
export 'package:passwordmanager/pages/tools/checker.dart';
export 'package:passwordmanager/pages/intro.dart';
export 'package:passwordmanager/pages/settings/change_username.dart';
export 'package:passwordmanager/pages/settings/change_password.dart';
export 'package:passwordmanager/pages/settings/edit_name.dart';
export 'package:passwordmanager/pages/tools/export.dart';
export 'package:passwordmanager/pages/tools/import.dart';
export 'package:passwordmanager/helpers/delete_dialog.dart';
export 'package:passwordmanager/helpers/export_dialog.dart';
export 'package:passwordmanager/helpers/import_dialog.dart';
export 'package:passwordmanager/pages/settings/terms.dart';
export 'package:passwordmanager/pages/settings/security_questions.dart';
export 'package:passwordmanager/pages/authenticate/reset_password.dart';
class Global {
  static String initialRoute = "/login";
  static Queue<int> recent = Queue<int>();
  static List<Map<String, dynamic>?> recentItems = [];
  static List<Map<String, dynamic>?> favorItems = [];
  static List<int> recentCards = [];
  static List<int> recentPasswords = [];
  static Map<String, dynamic> savedValues = {
    'username':'',
    'name':'Hello',
    'auth': false,
    'rememberUsername': false,
    'authUsername': '',
    'storage': false,
    'themeMode':'System',
    'recovery':false,
  };
  static Map<String, dynamic> password = {
    'name': '',
    'webpage': '',
    'username': '',
    'password': '',
    'notes': '',
    'color': Colors.blue.shade600.value.toString(),
    'favorite': false,
  };
  static Map<String, dynamic> card = {
    'name': '',
    'card_holder': '',
    'card_number': '',
    'expiration_date': '',
    'cvv': '',
    'notes': '',
    'color': Colors.blue.shade600.value.toString(),
    'favorite': false,
  };
}
