import 'package:passwordmanager/global_dirs.dart';

class LoginPassword extends StatefulWidget {


  const LoginPassword({super.key});

  @override
  State<LoginPassword> createState() => _LoginPassword();
}

class _LoginPassword extends State<LoginPassword> {
  final formKey = GlobalKey<FormState>();

  String password = '';
  final dbHelper = UserDatabaseHelper();
  final BiometricHelper biometricHelper = BiometricHelper();

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = await dbHelper.loginUser(Global.username, password);

      if (user != null) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Login Successful'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: user['name'],
            ),
          ),
        );
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Invalid Email or Password'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Check if biometric authentication is available and authenticate
  Future<void> checkBiometricAndAuthenticate() async {
    bool userExists = await dbHelper.loginBiometric(Global.username, password);
    bool isAvailable = await biometricHelper.isBiometricAvailable();
    if (isAvailable) {
      bool isAuthenticated = await biometricHelper.authenticateUser();
      if (isAuthenticated && userExists) {
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: 'there',
            ),
          ),
        );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Image.asset(
                          'assets/logo.png',
                          width: 60,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'BluePass',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        //fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => password = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
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
                        ?ElevatedButton(
                      onPressed: checkBiometricAndAuthenticate,
                      child: const Text('Biometric Login'),
                    )
                        :Text(''),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterPage()));
                      },
                      child: const Text('No account? Register'),
                    ),
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
