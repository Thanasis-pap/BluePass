import 'package:passwordmanager/global_dirs.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({
    super.key,
  });

  @override
  _GeneralSettings createState() => _GeneralSettings();
}

class _GeneralSettings extends State<GeneralSettings> {
  //List<String> theme = ['System', 'Light', 'Dark'];

  final BiometricHelper biometricHelper = BiometricHelper();

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
          title: const Text('Biometric authentication enabled'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Global.auth = true;
        setBool(true);
        return true;
      } else {
        // Show an error or allow fallback to password-based login
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Biometric authentication not enabled'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Global.auth = false;
        setBool(false);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Global.auth = (prefs.getBool('auth') ?? true);
    });
  }

  void reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Global.firstTime = true;
    setState(() {
      (prefs.setBool('auth', Global.auth));
    });
  }

  void setBool(bool auth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('auth', auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: const Text('General Settings',
            style: TextStyle(fontSize: (28))),
        // Show delete button if any card is selected
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 80,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- Radius
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Biometric Authentication',
                    style: TextStyle(
                      fontSize: 18,
                      //color: Colors.white, // Text color
                    ),
                  ),
                  Switch(
                    // This bool value toggles the switch.
                    value: Global.auth,
                    onChanged: (bool value) async {
                      if (value == true) {
                        value = await checkBiometric();
                      }
                      Global.auth = value;
                      // This is called when the user toggles the switch.
                      setState(() {
                        setBool(value);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
