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

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Insert the user data into the database
        await dbHelper.registerUser(_name, _username, _password);
        Map<String, dynamic> user = await dbHelper.loginName(_username);
        DatabaseHelper().setUser(user['id'].toString());
        Global.username = _username;
        Global.name = _name;
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Registration Successful'),
          autoCloseDuration: const Duration(seconds: 3),
        );

        // Navigate to HomePage after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/password.png',
                      width: 45,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'BluePass',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    /*const SizedBox(height: 32),
                    Text(
                      'Hello, stranger!',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),*/
                    const SizedBox(height: 30),
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
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: repeatPasswordVisible,
                      decoration: InputDecoration(
                        label: const Text('Confirm Password'),
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
                    const SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text('Password must contain:'),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            LeftPageRoute(page: const LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text('Already have an account? Login'),
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
