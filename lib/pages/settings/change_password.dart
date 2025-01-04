import 'package:passwordmanager/global_dirs.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String oldPassword = '';
  String newPassword = '';
  bool isStrong = false;
  bool oldPasswordVisible = true;
  bool newPasswordVisible = true;
  bool repeatPasswordVisible = true;
  final dbHelper = UserDatabaseHelper();
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = await dbHelper.loginUser(Global.savedValues['username'], oldPassword);
      print(user);
      if (user != null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title:
            const Text('Warning', style: TextStyle(fontSize: 25)),
            content: const Text('Are you sure you want to change your Password?',
                style: TextStyle(fontSize: 16)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: Text('Cancel',
                    style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () async {
                  int result =
                      await dbHelper.editUser(user['id'], null, null, newPassword);
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flat,
                    alignment: Alignment.bottomCenter,
                    showProgressBar: false,
                    title: const Text('Password changed'),
                    autoCloseDuration: const Duration(milliseconds: 1500),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Yes',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Current Password is incorrect'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: const Text('Change Username', style: TextStyle(fontSize: (28))),
        // Show delete button if any card is selected
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: oldPasswordVisible,
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      label: const Text('Current Password'),
                      filled: true,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(oldPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                        onPressed: () {
                          setState(
                                () {
                              oldPasswordVisible = !oldPasswordVisible;
                            },
                          );
                        },
                      ),
                      //fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSaved: (value) => oldPassword = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: newPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      label: const Text('New Password'),
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(newPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                        onPressed: () {
                          setState(
                                () {
                              newPasswordVisible = !newPasswordVisible;
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
                    onSaved: (value) => newPassword = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty ||
                          isStrong == false) {
                        return 'Please enter a valid Password';
                      } else if (value == oldPasswordController.text) {
                        return 'New Password must be different';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      passNotifier.value =
                          PasswordStrength.calculate(text: value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                          value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  PasswordStrengthChecker(
                    configuration: PasswordStrengthCheckerConfiguration(
                      inactiveBorderColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                    ),
                    strength: passNotifier,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text('Password must contain:'),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: AnimatedBuilder(
                      animation: passwordController,
                      builder: (context, child) {
                        final password = passwordController.text;

                        return PasswordChecker(
                          onStrengthChanged: (bool value) {
                            setState(() {
                              isStrong = value;
                            });
                          },
                          password: password,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveChanges,
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
