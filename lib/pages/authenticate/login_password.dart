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
    Map<String, dynamic> user =
        await dbHelper.loginName(Global.savedValues['username']);
    setState(() {
      Global.savedValues['auth'] = prefs.getBool('auth${user['id']}') ?? false;
    });
    if (Global.savedValues['auth']) {
      checkBiometricAndAuthenticate();
    }
  }

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user =
          await dbHelper.loginUser(Global.savedValues['username'], password);
      if (user != null) {
        DatabaseHelper().setUser('auth${user['id']}');
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
    bool userExists =
        await dbHelper.loginBiometric(Global.savedValues['username']);
    bool isAvailable = await biometricHelper.isBiometricAvailable();
    if (isAvailable) {
      bool isAuthenticated = await biometricHelper.authenticateUser();
      if (isAuthenticated && userExists) {
        Map<String, dynamic> user =
            await dbHelper.loginName(Global.savedValues['username']);
        DatabaseHelper().setUser('auth${user['id']}');
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
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
                          child: Text(Global.savedValues['name'][0],
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          Global.savedValues['name'],
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(Global.savedValues['username']),
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
                        } else if (value.contains(' ')) {
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
                    Global.savedValues['auth']
                        ? ElevatedButton(
                            onPressed: checkBiometricAndAuthenticate,
                            child: const Text('Biometric Login'),
                          )
                        : Text(''),
                    Global.savedValues['auth']
                        ? TextButton(
                            onPressed: () {
                              checkBiometric();
                            },
                            child: Text('Forgot Password?',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          )
                        : Text(''),
                    SizedBox(
                      height: 40,
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
