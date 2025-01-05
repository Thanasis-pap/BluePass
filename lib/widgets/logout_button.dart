import '../global_dirs.dart';

class Logout {
  PopupMenuItem<SampleItem> button(BuildContext context) {
    return PopupMenuItem<SampleItem>(
      value: SampleItem.logOut,
      child: const ListTile(
        leading: Icon(
          Icons.logout_rounded,
          size: 24,
          color: Colors.red,
        ),
        title: Text(
          'Log Out',
          style: TextStyle(fontSize: 16),
        ),
      ),
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Warning',
                style: TextStyle(fontSize: 25)),
            content: const Text('Are you sure you want to log out?',
                style: TextStyle(fontSize: 16)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child:
                Text('Cancel', style: TextStyle(fontSize: 18)),
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
    );}
}