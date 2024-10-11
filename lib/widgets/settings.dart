import 'package:passwordmanager/global_dirs.dart';

class Settings {
  static List<Widget> settingsCategories(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => Temporary()));
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
                      child: Text('Cancel',
                          style: TextStyle(fontSize: 18)),
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
                      child: Text('Yes',
                          style: TextStyle(fontSize: 18)),
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
              leading: Icon(Icons.logout_rounded,color: Colors.red,),
              title: Text(
                overflow: TextOverflow.ellipsis,
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
