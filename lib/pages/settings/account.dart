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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Temporary(),
                  ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Temporary(),
                  ),
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
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title:
                        const Text('Warning', style: TextStyle(fontSize: 28)),
                    content: const Text('Are you sure you want to log out?',
                        style: TextStyle(fontSize: 18)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: Text('Cancel',
                            style: TextStyle(fontSize: Global.fontSize)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          toastification.show(
                            context: context,
                            style: ToastificationStyle.flat,
                            alignment: Alignment.bottomCenter,
                            showProgressBar: false,
                            title: const Text('Logged out successfully.'),
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                          Navigator.pop(context, 'Yes');
                          Navigator.of(context).pushAndRemoveUntil(
                              LeftPageRoute(
                                  page: const LoginPage()),
                                  (Route<dynamic> route) => false);
                        },
                        child: Text('Yes',
                            style: TextStyle(fontSize: Global.fontSize)),
                      ),
                    ],
                  ),
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
