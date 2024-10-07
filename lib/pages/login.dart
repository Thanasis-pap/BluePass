import 'package:passwordmanager/global_dirs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final dbHelper = UserDatabaseHelper();
  final BiometricHelper biometricHelper = BiometricHelper();

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = await dbHelper.loginUser(_email, _password);

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
  Future<void> _checkBiometricAndAuthenticate() async {
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
                key: _formKey,
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
                    const SizedBox(height: 62),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        //fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _email = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                      onSaved: (value) => _password = value!,
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
                      onPressed: _checkBiometricAndAuthenticate,
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
