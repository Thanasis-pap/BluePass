
import '../../global_dirs.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController answerController1 = TextEditingController();
  final TextEditingController answerController2 = TextEditingController();
  final TextEditingController answerController3 = TextEditingController();
  int currentPage = 0;
  late PageController _pageViewController;
  List<dynamic> securityQuestions = ['Loading...', 'Loading...', 'Loading...'];
  List<dynamic> correctAnswers = [];

  final formKey = GlobalKey<FormState>();
  String newPassword = '';
  bool isStrong = false;
  bool newPasswordVisible = true;
  bool repeatPasswordVisible = true;
  final dbHelper = UserDatabaseHelper();
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = await dbHelper.loginName(Global.savedValues['username']);
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
        }
  }

  void goToNextPage() {
    if (currentPage < 2) {
      setState(() {
        currentPage++;
      });
    }
    _pageViewController.animateToPage(
      currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
    _pageViewController.animateToPage(
      currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSecurityQuestions();
    _pageViewController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    //_tabController.dispose();
  }

  Future<void> fetchSecurityQuestions() async {
    try {
      // Fetch questions and answers from the database
      final questions = await UserDatabaseHelper().getSecurityQuestions();

      if (questions.length == 3) {
        setState(() {
          securityQuestions = questions.map((q) => q['question']).toList();
          correctAnswers = questions.map((q) => q['answer']).toList();
        });
      } else {
        throw Exception('Unexpected number of questions.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching security questions: $e')),
      );
    }
  }

  void validateAnswers() {
    if (answerController1.text.isNotEmpty &&
        answerController2.text.isNotEmpty &&
        answerController3.text.isNotEmpty) {
      if (answerController1.text.trim() == correctAnswers[0] &&
          answerController2.text.trim() == correctAnswers[1] &&
          answerController3.text.trim() == correctAnswers[2]) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Answers validated. Proceed to reset password'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        goToNextPage();
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.bottomCenter,
          showProgressBar: false,
          title: const Text('Incorrect answers. Please try again.'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Please answer all questions'),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 75,
          backgroundColor: Theme.of(context).colorScheme.surface,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Reset Password', style: TextStyle(fontSize: (28))),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                /// Use [Axis.vertical] to scroll vertically.
                controller: _pageViewController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Security Questions',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:Text(securityQuestions[0])),
                        ),
                        TextFormField(
                          controller: answerController1,
                          decoration: InputDecoration(
                            labelText: 'Answer 1',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide an answer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:Text(securityQuestions[1])),
                        ),
                        TextFormField(
                          controller: answerController2,
                          decoration: InputDecoration(
                            labelText: 'Answer 2',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide an answer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:Text(securityQuestions[2]),),
                        ),
                        TextFormField(
                          controller: answerController3,
                          decoration: InputDecoration(
                            labelText: 'Answer 3',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide an answer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: validateAnswers,
                    child: Text('Submit Answers'),
                  ),
                ],
              ),
            ),),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: formKey,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
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
                ],
              ),
            ),
          ],
        ));
  }
}
