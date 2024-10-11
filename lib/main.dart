import 'package:passwordmanager/global_dirs.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureKeyStorage = SecureKeyStorage();
  final aesHelper = AESHelper();
  await FlutterDisplayMode.setHighRefreshRate();
  // Check if the AES key is already stored
  String? existingKey = await secureKeyStorage.retrieveKey();
  if (existingKey == null) {
    // Generate a new AES key and store it securely
    String newAESKey = generateAESKey();
    await secureKeyStorage.storeKey(newAESKey);
  }

  runApp(const MyApp());
}

String generateAESKey() {
  final key = encrypt.Key.fromLength(32); // 256-bit key
  return key.base64;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstTime = true;  // Default value assuming first-time launch
  ThemeMode _themeMode = ThemeMode.system;

  // Convert a string to a ThemeMode
  ThemeMode _themeFromString(String themeString) {
    Global.themeMode = themeString;
    switch (themeString) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      case 'System':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('themeMode') ?? 'System';
    _themeMode = _themeFromString(themeString);
  }

  Future<void> _checkFirstTimeOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasOpened = prefs.getBool('hasOpened');

    if (hasOpened == null || hasOpened == false) {
      // First time open, show intro page
      setState(() {
        _isFirstTime = true;
      });
      // Mark the app as opened for next time
      await prefs.setBool('hasOpened', true);
    } else {
      // App has already been opened before
      setState(() {
        _isFirstTime = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTimeOpen();
    loadThemeFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Manager',
      home: _isFirstTime ? OnBoardingPage() : LoginPage(),
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade400,
        ),
        textTheme: GoogleFonts.robotoFlexTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade300,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );
  }
}