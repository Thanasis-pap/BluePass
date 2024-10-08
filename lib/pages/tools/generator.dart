import 'package:passwordmanager/global_dirs.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  _Generator createState() => _Generator();
}

class _Generator extends State<Generator> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  int length = 12;
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 75,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 170,
                  child: Card.filled(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Password strength:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Text(
                                  length < 12 ? 'Weak' : 'Secure',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
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
                                  length.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Slider(
                            value: length.toDouble(),
                            min: 8,
                            max: 18,
                            divisions: 10,
                            //label: Global.fontSize.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                length = value.round();
                              });
                            },
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                PasswordStrengthFormChecker(
                  minimumStrengthRequired: PasswordStrength.secure,
                  onChanged: (password, notifier) {
                    // Don't forget to update the notifier!
                    notifier.value = PasswordStrength.calculate(text: password);
                  },
                  passwordGeneratorConfiguration:
                      PasswordGeneratorConfiguration(
                    length: length,
                  ),
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
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
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
                  showGenerator: true,
                  generateButtonStyle: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPasswordGenerated: (password, notifier) {
                    debugPrint('$password - length: ${password.length}');
                    // Don't forget to update the notifier!
                    notifier.value = PasswordStrength.calculate(text: password);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
