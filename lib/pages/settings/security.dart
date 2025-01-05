import 'package:passwordmanager/global_dirs.dart';
import 'package:passwordmanager/pages/settings/security_questions.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({
    super.key,
  });

  @override
  _GeneralSettings createState() => _GeneralSettings();
}

class _GeneralSettings extends State<GeneralSettings> {
  final TextEditingController _textController = TextEditingController();
  bool isButtonEnabled = false;
  final BiometricHelper biometricHelper = BiometricHelper();
  final dbHelper = UserDatabaseHelper();

  void onDeletePressed() {
    toastification.show(
      context: context,
      style: ToastificationStyle.flat,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      title: const Text('Logged out successfully.'),
      autoCloseDuration: const Duration(seconds: 2),
    );
    Navigator.pop(context);
  }

  Future<bool> checkBiometric() async {
    bool isAvailable = await biometricHelper.isBiometricAvailable();
    if (isAvailable) {
      bool isAuthenticated = await biometricHelper.authenticateUser();
      if (isAuthenticated) {
        // Proceed with login or access to secured parts of the app
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Biometric Login enabled'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Global.savedValues['auth'] = true;
        setBool();
        return true;
      } else {
        // Show an error or allow fallback to password-based login
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Authentication failed'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Global.savedValues['auth'] = false;
        setBool();
        return false;
      }
    } else {
      // Fallback if biometrics are not available
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Biometric authentication not available.'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  void getBool() async {
    Map<String, dynamic> user =
        await dbHelper.loginName(Global.savedValues['username']);
    SharedPreferences prefs = await SharedPreferences.getInstance();
      Global.savedValues['auth'] = prefs.getBool('auth${user['id']}') ?? false;
  }

  void setBool() async {
    Map<String, dynamic> user =
        await dbHelper.loginName(Global.savedValues['username']);
    SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool('auth${user['id']}', Global.savedValues['auth']);
      prefs.setBool('rememberUsername', Global.savedValues['rememberUsername']);
      setState(() {
        
      });
  }

  @override
  void initState() {
    getBool();
    super.initState();

    // Listen to changes in the TextFormField
    _textController.addListener(() {
      setState(() {
        // Enable the button if the text is 'DELETE'
        isButtonEnabled = _textController.text == "DELETE";
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title:  Text('Security & Privacy',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: ListTile(
                title: Text(
                  'Biometric Login',
                  style: TextStyle(
                    fontSize: 18,
                    //color: Colors.white, // Text color
                  ),
                ),
                subtitle: Text(
                  'Enable Fingerprint or FaceID login',
                  style: TextStyle(
                    fontSize: 11,
                    //color: Colors.white, // Text color
                  ),
                ),
                leading: Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFF1A32CC),
                ),
                trailing: SizedBox(
                  height: 38,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      // This bool value toggles the switch.
                      value: Global.savedValues['auth'],
                      onChanged: (bool value) async {
                        if (value == true) {
                          value = await checkBiometric();
                        }
                        Global.savedValues['auth'] = value;
                        // This is called when the user toggles the switch.
                        setBool();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: ListTile(
                title: Text(
                  'Remember Username',
                  style: TextStyle(
                    fontSize: 18,
                    //color: Colors.white, // Text color
                  ),
                ),
                subtitle: Text(
                  'Auto-insert Username between logins',
                  style: TextStyle(
                    fontSize: 11,
                    //color: Colors.white, // Text color
                  ),
                ),
                leading: Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF1A32CC),
                ),
                trailing: SizedBox(
                  height: 38,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      // This bool value toggles the switch.
                      value: Global.savedValues['rememberUsername'],
                      onChanged: (bool value) async {
                        if (value == true) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              'username', Global.savedValues['username']);
                        }
                        Global.savedValues['rememberUsername'] = value;
                        // This is called when the user toggles the switch.
                        setBool();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeUsername(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.perm_identity_rounded,
                  color: Color(0xFF1A32CC),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                ),
                title: Text(
                  'Change Username',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.lock_rounded,
                  color: Color(0xFF1A32CC),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                ),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecurityQuestions(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.question_mark_rounded,
                  color: Color(0xFF1A32CC),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                ),
                title: Text(
                  'Security Questions',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => DeleteDialog());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.no_accounts_rounded,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
