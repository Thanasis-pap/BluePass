import 'package:passwordmanager/global_dirs.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: SizedBox(
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AccountSettings()));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                ),
                child: const ListTile(
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'App Settings',
                    style: TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      //color: Colors.white, // Text color
                    ),
                  ),
                  leading: Icon(
                    Icons.settings_rounded,
                    color: Color(0xFF1A32CC),
                  ),
                  trailing: Icon(
                    Icons.navigate_next,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: SizedBox(
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GeneralSettings()));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                ),
                child: const ListTile(
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Security & Privacy',
                    style: TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      //color: Colors.white, // Text color
                    ),
                  ),
                  trailing: Icon(
                    Icons.navigate_next,
                  ),
                  leading: Icon(
                    Icons.security_rounded,
                    color: Color(0xFF1A32CC), // Set the color of the icon
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: SizedBox(
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => About()));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                ),
                child: const ListTile(
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      //color: Colors.white, // Text color
                    ),
                  ),
                  trailing: Icon(
                    Icons.navigate_next,
                  ),
                  leading: Icon(
                    Icons.info_rounded,
                    color: Color(0xFF1A32CC), // Set the color of the icon
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: SizedBox(
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title:
                          const Text('Warning', style: TextStyle(fontSize: 25)),
                      content: const Text('Are you sure you want to log out?',
                          style: TextStyle(fontSize: 16)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                          child: Text('Cancel', style: TextStyle(fontSize: 18)),
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
                                LeftPageRoute(page: const LoginPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: Text('Yes', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Border radius of 35
                  ),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Log Out',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
