import 'package:passwordmanager/global_dirs.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _username = '';
  String _password = '';
  bool _isStrong = false;
  bool passwordVisible = true;
  bool repeatPasswordVisible = true;
  final dbHelper = UserDatabaseHelper();
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  final _passwordController = TextEditingController();
  final BiometricHelper biometricHelper = BiometricHelper();

  void getBool() async {
    Map<String, dynamic> user =
    await dbHelper.loginName(Global.savedValues['username']);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Global.savedValues['auth'] = prefs.getBool('auth${user['id']}') ?? false;
    });
  }

  void setBool() async {
    Map<String, dynamic> user =
    await dbHelper.loginName(Global.savedValues['username']);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('auth${user['id']}', Global.savedValues['auth']);
      prefs.setBool('rememberUsername', Global.savedValues['rememberUsername']);
    });
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

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Insert the user data into the database
        await dbHelper.registerUser(_name, _username, _password);
        Map<String, dynamic> user = await dbHelper.loginName(_username);
        DatabaseHelper().setUser(user['id'].toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasOpened', true);
        Global.savedValues['username'] = _username;
        Global.savedValues['name'] = _name;

        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title:
                const Text('Password Recovery', style: TextStyle(fontSize: 25)),
            content: const Text(
                'To recover your Master Password in the future, please enable Biometric Authentication and set Security Questions. Would you like to set them up now?',
                style: TextStyle(fontSize: 16)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flat,
                    alignment: Alignment.bottomCenter,
                    showProgressBar: false,
                    title: const Text('Registration Successful'),
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                  Navigator.pop(context, 'Skip for now');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                child: Text('Skip for now', style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Yes');
                  checkBiometric();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                  Navigator.of(context).push(
                      LeftPageRoute(page: SecurityQuestions()),
                      );
                },
                child: Text('Yes', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
        // Navigate to HomePage after successful registration
      } catch (e) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('User already exists'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/password.png',
                      width: 45,
                    ),
                    Text(
                      'Create your account',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: const Text('Name'),
                        filled: true,
                        prefixIcon: const Icon(Icons.title_rounded),
                        //fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _name = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: const Text('Username'),
                        prefixIcon: const Icon(Icons.perm_identity_rounded),
                        filled: true,
                        //fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _username = value!,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Please enter a Username with 6 characters or more';
                        } else if (value.contains(' ')) {
                          return 'Spaces are not acceptable';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passwordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        label: const Text('Master Password'),
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
                      onSaved: (value) => _password = value!,
                      onChanged: (value) {
                        passNotifier.value =
                            PasswordStrength.calculate(text: value);
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            _isStrong == false) {
                          return 'Please enter a valid Password';
                        } else if (value.contains(' ')) {
                          return 'Spaces are not acceptable';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: repeatPasswordVisible,
                      decoration: InputDecoration(
                        label: const Text('Confirm Master Password'),
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(repeatPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                          onPressed: () {
                            setState(
                              () {
                                repeatPasswordVisible = !repeatPasswordVisible;
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
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PasswordStrengthChecker(
                      configuration: PasswordStrengthCheckerConfiguration(
                        inactiveBorderColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                      strength: passNotifier,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text('Password must contain:'),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: AnimatedBuilder(
                        animation: _passwordController,
                        builder: (context, child) {
                          final password = _passwordController.text;

                          return PasswordChecker(
                            onStrengthChanged: (bool value) {
                              setState(() {
                                _isStrong = value;
                              });
                            },
                            password: password,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerUser,
                      child: const Text('Register'),
                    ),
                    Column(
                      children: [
                        Text(
                          'By pressing "Register" you agree to the ',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Terms()));
                          },
                          child: const Text(
                            'Terms & Conditions',
                            style: TextStyle(fontSize: 11, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    /*TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            LeftPageRoute(page: const LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text('Already have an account? Login'),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
