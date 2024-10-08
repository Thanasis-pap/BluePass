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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SizedBox(
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GeneralSettings()));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- Radius
              ),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              title: Text(
                overflow: TextOverflow.ellipsis,
                'General Settings',
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  //color: Colors.white, // Text color
                ),
              ),
              leading: Icon(
                Icons.settings_rounded,
                // Use the password icon
                size: 30, // Scale the icon larger than the button
                //color: Colors.blue, // Set the color of the icon
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SizedBox(
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AccountSettings()));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- Radius
              ),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              title: Text(
                overflow: TextOverflow.ellipsis,
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  //color: Colors.white, // Text color
                ),
              ),
              leading: Icon(
                Icons.manage_accounts_rounded,
                // Use the password icon
                size: 30, // Scale the icon larger than the button
                //color: Colors.blue, // Set the color of the icon
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SizedBox(
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Temporary()));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- Radius
              ),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              title: Text(
                overflow: TextOverflow.ellipsis,
                'Security & Privacy Settings',
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  //color: Colors.white, // Text color
                ),
              ),
              leading: Icon(
                Icons.privacy_tip_rounded,
                // Use the password icon
                size: 30, // Scale the icon larger than the button
                //color: Colors.blue, // Set the color of the icon
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
