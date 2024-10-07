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

export 'package:passwordmanager/helpers/biometric_helper.dart';
export 'package:passwordmanager/widgets/title.dart';
export 'package:passwordmanager/pages/login.dart';
export 'package:passwordmanager/pages/register.dart';
export 'package:passwordmanager/pages/home.dart';
export 'package:passwordmanager/pages/password/password.dart';
export 'package:passwordmanager/pages/card/card.dart';
export 'package:passwordmanager/pages/password/edit_password.dart';
export 'package:passwordmanager/user_database_enc.dart';
export 'package:passwordmanager/pages/card/edit_card.dart';
export 'package:passwordmanager/data_enc.dart';
export 'package:passwordmanager/helpers/secure_storage.dart';
export 'package:passwordmanager/helpers/aes_helper.dart';
export 'package:passwordmanager/pages/card/cards_list.dart';
export 'package:passwordmanager/pages/password/passwords_list.dart';
export 'package:passwordmanager/helpers/recent_helper.dart';
export 'package:passwordmanager/pages/settings/general.dart';
export 'package:passwordmanager/pages/settings/account.dart';
export 'package:passwordmanager/widgets/settings.dart';
export 'package:passwordmanager/widgets/tools.dart';

class Global {
  static List<Map<String, dynamic>?> recentItems = [];
  static List<Map<String, dynamic>?> favorItems = [];
  static double fontSize = 18;
  static bool auth = true;
  static String initialRoute = "/login";
  static Queue<int> recent = Queue<int>();
  static List<int> recentCards = [];
  static List<int> recentPasswords = [];
  static List<String> user = ['example@email.com', 'Name', 'Password'];
  static Map<String, dynamic> password = {
    'name': '',
    'webpage': '',
    'username': '',
    'password': '',
    'notes': '',
    'color': '',
    'favorite': false,
  };
  static Map<String, dynamic> card = {
    'name': '',
    'card_holder': '',
    'card_number': '',
    'expiration_date': '',
    'cvv': '',
    'notes': '',
    'color': '',
    'favorite': false,
  };
}
