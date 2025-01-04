import 'package:passwordmanager/global_dirs.dart';

class Checker extends StatefulWidget {
  const Checker({super.key});

  @override
  _Checker createState() => _Checker();
}

class _Checker extends State<Checker> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  int length = 12;
  bool _isStrong = false;
  final _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 75,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Password Strength Check',style: TextStyle(fontSize: 24),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      //padding: const EdgeInsets.all(20),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Password length:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text(
                                _passwordController.text.length.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: [
                            Text(
                              'Password contains:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your password here:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                PasswordStrengthFormChecker(
                  minimumStrengthRequired: PasswordStrength.secure,
                  onChanged: (password, notifier) {
                    notifier.value = PasswordStrength.calculate(text: password);
                  },
                  textFormFieldConfiguration: TextFormFieldConfiguration(
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_rounded),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                      text: _passwordController.text))
                                  .then((_) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.bottomCenter,
                                  showProgressBar: false,
                                  title: const Text('Password copied.'),
                                  autoCloseDuration:
                                      const Duration(milliseconds: 1500),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      filled: true,
                      //fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  passwordStrengthCheckerConfiguration:
                      PasswordStrengthCheckerConfiguration(
                    inactiveBorderColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
