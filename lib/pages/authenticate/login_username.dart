import 'package:passwordmanager/global_dirs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = UserDatabaseHelper();
  final _passwordController = TextEditingController();
  final BiometricHelper biometricHelper = BiometricHelper();

  void checkUsernameSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Global.savedValues['rememberUsername'] = prefs.getBool('rememberUsername') ?? false;
    if (Global.savedValues['rememberUsername']) {
      Global.savedValues['username'] = prefs.getString('username');
      _passwordController.text = Global.savedValues['username'];
      loginUser(Global.savedValues['username']);
    }
  }

  void loginUser(String username) async {
    if (_formKey.currentState!.validate() &&
        await dbHelper.loginBiometric(username)) {
      _formKey.currentState!.save();
      Map<String, dynamic> user = await dbHelper.loginName(username);
      Global.savedValues['name'] = user['name'];
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.push(
        context,
        LeftPageRoute(
          page: LoginPassword(),
        ),
      );
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Invalid Username'),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUsernameSaved();
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
                          'assets/password.png',
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
                    const SizedBox(height: 50),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
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
                      onSaved: (value) =>
                          Global.savedValues['username'] = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Username';
                        } else if (value.contains(' ')) {
                          return 'Spaces are not acceptable';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        loginUser(_passwordController.text);
                      },
                      child: const Text('Next'),
                    ),
                    const SizedBox(height: 10),
                    /*TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            LeftPageRoute(
                                page: const RegisterPage()),
                                (Route<dynamic> route) => false);
                      },

                      child: const Text('No account? Register'),
                    ),*/
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
