import 'package:passwordmanager/global_dirs.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({super.key});

  @override
  State<ChangeUsername> createState() => _ChangeUsername();
}

class _ChangeUsername extends State<ChangeUsername> {
  final formKey = GlobalKey<FormState>();
  String oldUsername = '';
  String newUsername = '';
  String password = '';
  bool passwordVisible = true;
  final dbHelper = UserDatabaseHelper();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = await dbHelper.loginUser(oldUsername, password);
      print(user);
      if (user != null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title:
            const Text('Warning', style: TextStyle(fontSize: 25)),
            content: const Text('Are you sure you want to change your Username?',
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
                  await dbHelper.editUser(user['id'], null, newUsername, null);
                  Global.savedValues['username'] = newUsername;
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    style: ToastificationStyle.flat,
                    alignment: Alignment.bottomCenter,
                    showProgressBar: false,
                    title: const Text('Username changed'),
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
          title: const Text('Invalid Password'),
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
                  SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      label: const Text('Old Username'),
                      filled: true,
                      prefixIcon: const Icon(Icons.perm_identity_rounded),
                      //fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSaved: (value) => oldUsername = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Username';
                      } else if (value != Global.savedValues['username']) {
                        return 'Wrong Username.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: const Text('New Username'),
                      prefixIcon: const Icon(Icons.perm_identity_rounded),
                      filled: true,
                      //fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSaved: (value) => newUsername = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Please enter a Username with 6 characters or more';
                      } else if (value == usernameController.text) {
                        return 'New Username must be different';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: passwordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      prefixIcon: const Icon(Icons.lock),
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saveChanges,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
