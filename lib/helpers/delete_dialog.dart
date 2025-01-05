import 'package:passwordmanager/global_dirs.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({super.key});

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  final TextEditingController _textController = TextEditingController();
  bool isButtonEnabled = false;
  final dbHelper = UserDatabaseHelper();
  final dbDataHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    // Listen to changes in the TextFormField
    _textController.addListener(() {
      setState(() {
        // Enable the button if the text is 'DELETE'
        isButtonEnabled = _textController.text == "DELETE";
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onDeletePressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasOpened', false);
    toastification.show(
      context: context,
      style: ToastificationStyle.flat,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      title: const Text('User deleted successfully.'),
      autoCloseDuration: const Duration(seconds: 2),
    );
    Map<String,dynamic> user = await dbHelper.loginName(Global.savedValues['username']);
    dbDataHelper.deleteDatabaseFile(user['id'].toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dbHelper.deleteUser(id: user['id']);
    dbHelper.deleteSecurityQuestions();
    await preferences.clear();
    Global.savedValues= {
      'username':'',
      'name':'I am awesome, but this code would also be awesome after a good refactoring',
      'auth': false,
      'rememberUsername': false,
      'authUsername': '',
      'storage': false,
      'themeMode':'System',
      'recovery':false,
      'questions':false,
    };
    Navigator.of(context).pushAndRemoveUntil(
        LeftPageRoute(page: const OnBoardingPage()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning',
          style: TextStyle(fontSize: 25, color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "You are about to delete your account. ALL your data will be lost. Please consider exporting your data first. Do you want to continue?",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _textController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              label: const Text('Type "DELETE" to continue'),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: Text('Cancel', style: TextStyle(fontSize: 18)),
        ),
        ElevatedButton(
          onPressed: isButtonEnabled ? _onDeletePressed : null,
          child: Text('Continue',
              style: TextStyle(
                  fontSize: 18,
                  color: isButtonEnabled ? Colors.red : Colors.grey)),
        ),
      ],
    );
  }
}