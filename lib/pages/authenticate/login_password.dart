import 'package:passwordmanager/global_dirs.dart';

class LoginPassword extends StatefulWidget {
  const LoginPassword({super.key});

  @override
  State<LoginPassword> createState() => _LoginPassword();
}

class _LoginPassword extends State<LoginPassword> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  String password = '';
  final dbHelper = UserDatabaseHelper();
  final BiometricHelper biometricHelper = BiometricHelper();

  void getParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = await dbHelper.loginName(Global.username);
    setState(() {
      Global.auth = prefs.getBool(user['id'].toString()) ?? false;
    });
    if (Global.auth) {
      checkBiometricAndAuthenticate();
    }
  }

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = await dbHelper.loginUser(Global.username, password);
      if (user != null) {
        DatabaseHelper().setUser(user['id'].toString());
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Login Successful'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
            (Route<dynamic> route) => false);
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Invalid Password'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Check if biometric authentication is available and authenticate
  Future<void> checkBiometricAndAuthenticate() async {
    bool userExists = await dbHelper.loginBiometric(Global.username);
    bool isAvailable = await biometricHelper.isBiometricAvailable();
    if (isAvailable) {
      bool isAuthenticated = await biometricHelper.authenticateUser();
      if (isAuthenticated && userExists) {
        Map<String, dynamic> user = await dbHelper.loginName(Global.username);
        DatabaseHelper().setUser(user['id'].toString());
        // Proceed with login or access to secured parts of the app
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Login Successful'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Navigator.of(context).pushAndRemoveUntil(
            LeftPageRoute(
              page: MyHomePage(),
            ),
            (Route<dynamic> route) => false);
      } else {
        // Show an error or allow fallback to password-based login
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Authentication Failed'),
          autoCloseDuration: const Duration(seconds: 3),
        );
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
    }
  }

  @override
  void initState() {
    super.initState();
    getParams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF1A32CC),
                          radius: 30,
                          child: Text(Global.name[0].capitalize!,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          Global.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(Global.username),
                      ],
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        filled: true,
                        //fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => password = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        else if (value.contains(' ')) {
                          return 'Spaces are not acceptable';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: loginUser,
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 10),
                    Global.auth
                        ? ElevatedButton(
                            onPressed: checkBiometricAndAuthenticate,
                            child: const Text('Biometric Login'),
                          )
                        : Text(''),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
