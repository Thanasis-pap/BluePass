import 'package:passwordmanager/global_dirs.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureKeyStorage = SecureKeyStorage();
  final aesHelper = AESHelper();

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Global.initialRoute,
      routes: {
        Global.initialRoute: (context) => (const LoginPage()),
      },
      debugShowCheckedModeBanner: false,
      title: 'Password Manager',
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