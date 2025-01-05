import 'package:passwordmanager/global_dirs.dart';

class PasswordPage extends StatefulWidget {
  final Map<String, dynamic> password;

  const PasswordPage({super.key, required this.password});

  @override
  State<PasswordPage> createState() => _PasswordPage();
}

class _PasswordPage extends State<PasswordPage> {
  final dbHelper = DatabaseHelper();
  bool _obscureText = true;

  void _launchURL(String url) async {
    if (await launchUrl(Uri.parse("https://$url"))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid link')));
    }
  }

  void navigateToEditPassword(Map<String, dynamic> password) async {
    // Push the Editpassword page and wait for the result
    final bool? isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditPassword(title: 'Edit Password', data: password),
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Global.password = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(Global.password['name'],overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal:10.0),
              child: Row(

                children: [
                  IconButton(
                    icon: Icon(
                        size: 30,
                        Global.password['favorite']
                            ? Icons.star_rounded
                            : Icons.star_border_rounded),
                    color: const Color(0xFF3F7BD7),
                    onPressed: () {
                      setState(() {
                        Global.password['favorite'] =
                        !Global.password['favorite'];
                        toastification.show(
                          context: context,
                          style: ToastificationStyle.flat,
                          alignment: Alignment.bottomCenter,
                          showProgressBar: false,
                          title: Text(Global.password['favorite']
                              ? 'Added to favorites'
                              : 'Removed from favorites'),
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        dbHelper.editPassword(
                            Global.password['id'], Global.password);
                      }); // Handle delete action
                    },
                  ),
                  IconButton(
                    icon: const Icon(size: 30, Icons.edit_rounded),
                    color: const Color(0xFF3F7BD7),
                    onPressed: () {
                      navigateToEditPassword(Global.password);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: const Color(0xFF3F7BD7),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Warning',
                              style: TextStyle(fontSize: 28)),
                          content: const Text(
                              'Are you sure you want to delete this password?',
                              style: TextStyle(fontSize: 18)),
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
                                await dbHelper.deletePassword(Global.password['id']);
                                toastification.show(
                                  context: context,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.bottomCenter,
                                  showProgressBar: false,
                                  title: const Text(
                                      'Password has been deleted'),
                                  autoCloseDuration: const Duration(seconds: 2),
                                );
                                Navigator.pop(context);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(),
                                    ),
                                        (Route<dynamic> route) => false);
                              },
                              child:
                                  Text('Yes', style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ]),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  child: Center(
                    child: ListTile(
                      title: Text(
                        'Username / E-mail',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                text: Global.password['username'],
                              )).then((_) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.bottomCenter,
                                  showProgressBar: false,
                                  title: const Text('Copied successfully'),
                                  autoCloseDuration:
                                      const Duration(milliseconds: 1500),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      subtitle: Text(
                        Global.password['username'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: Center(
                    child: ListTile(
                      title: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                      text: Global.password['password']))
                                  .then((_) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.bottomCenter,
                                  showProgressBar: false,
                                  title: const Text('Copied successfully'),
                                  autoCloseDuration:
                                      const Duration(milliseconds: 1500),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      subtitle: Text(
                        _obscureText ? '********' : Global.password['password'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: Center(
                    child: ListTile(
                      title: Text(
                        'Webpage',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              _launchURL(Global.password['webpage']);
                            },
                          ),
                        ],
                      ),
                      subtitle: Text(
                        Global.password['webpage'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 380,
                  child: Card.filled(
                    elevation: 0,
                    color: Color(int.parse(Global.password['color']))
                        .withOpacity(0.1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          Global.password['notes'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
} //Timestamps
