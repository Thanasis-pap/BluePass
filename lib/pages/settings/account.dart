import 'package:passwordmanager/global_dirs.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({
    super.key,
  });

  @override
  _AccountSettings createState() => _AccountSettings();
}

class _AccountSettings extends State<AccountSettings> {
  //List<String> theme = ['System', 'Light', 'Dark'];

  void getParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Global.auth = (prefs.getBool('auth') ?? true);
    });
  }

  void reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Global.firstTime = true;
    setState(() {
      (prefs.setBool('auth', Global.auth));
    });
  }

  void setBool(bool auth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('auth', auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: const Text('General Settings', style: TextStyle(fontSize: (28))),
        // Show delete button if any card is selected
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                title: Text(
                  'Change Username',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginPage()));
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                  alignment: Alignment.bottomCenter,
                  showProgressBar: false,
                  title: const Text('Logged Out Successfully'),
                  autoCloseDuration: const Duration(seconds: 3),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: const ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
