import 'package:passwordmanager/global_dirs.dart';

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
    print('Done');
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
        Global.auth = true;
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
        Global.auth = false;
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

  void getParams() async {
    Map<String,dynamic> user = await dbHelper.loginName(Global.username);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Global.auth = prefs.getBool(user['id'].toString()) ?? false;
    });
  }

  void reset() async {
    Map<String,dynamic> user = await dbHelper.loginName(Global.username);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Global.firstTime = true;
    setState(() {
      (prefs.setBool(user['id'].toString(), Global.auth));
    });
  }

  void setBool() async {
    Map<String,dynamic> user = await dbHelper.loginName(Global.username);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool(user['id'].toString(), Global.auth);
    });
  }

  @override
  void initState() {
    getParams();
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
        title: const Text('Security and Privacy',
            style: TextStyle(fontSize: (28))),
        // Show delete button if any card is selected
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
                      value: Global.auth,
                      onChanged: (bool value) async {
                        if (value == true) {
                          value = await checkBiometric();
                        }
                        Global.auth = value;
                        // This is called when the user toggles the switch.
                        setState(() {
                          setBool();
                        });
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

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({super.key});

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  final TextEditingController _textController = TextEditingController();
  bool isButtonEnabled = false;
  final dbHelper = UserDatabaseHelper();
  final dbDataHelper = DatabaseHelper();

  @override
  void initState() {
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

  Future<void> _onDeletePressed() async {
    toastification.show(
      context: context,
      style: ToastificationStyle.flat,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      title: const Text('User deleted successfully.'),
      autoCloseDuration: const Duration(seconds: 2),
    );
    Map<String,dynamic> user = await dbHelper.loginName(Global.username);
    dbDataHelper.deleteDatabaseFile(user['id'].toString());
    dbHelper.deleteUser(id: user['id']);
    Navigator.of(context).pushAndRemoveUntil(
        LeftPageRoute(page: const LoginPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning',
          style: TextStyle(fontSize: 25, color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "You are about to delete your account. ALL your data will be lost. Please consider exporting your data first. Do you want to continue?",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _textController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              label: const Text('Type "DELETE" to continue'),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            //onSaved: (value) => _name = value!,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: Text('Cancel', style: TextStyle(fontSize: 18)),
        ),
        ElevatedButton(
          onPressed: isButtonEnabled ? _onDeletePressed : null,
          child: Text('Continue',
              style: TextStyle(
                  fontSize: 18,
                  color: isButtonEnabled ? Colors.red : Colors.grey)),
        ),
      ],
    );
  }
}
