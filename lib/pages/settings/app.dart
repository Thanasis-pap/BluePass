import 'package:passwordmanager/global_dirs.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({
    super.key,
  });

  @override
  _AccountSettings createState() => _AccountSettings();
}

class _AccountSettings extends State<AccountSettings> {
  List<String> theme = ['System', 'Light', 'Dark'];

  Future<void> saveThemeToPreferences(String themeModeString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeModeString);
  }

  void navigateToEditCard() async {
    // Push the EditCard page and wait for the result
    final bool? isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditName(),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title:  Text('App Settings',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),),
        // Show delete button if any card is selected
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                navigateToEditCard();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFF1A32CC),
                ),
                trailing: SizedBox(
                    width: 130,
                    child: Text(
                      Global.savedValues['name'],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    )),
                title: Text(
                  'Edit Name',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          // Padding of 10 between buttons
          child: SizedBox(
            height: 70,
            child: ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Border radius of 35
                ),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.light_mode,
                  color: Color(0xFF1A32CC),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (String newValue) {
                    setState(() {
                      Global.savedValues['themeMode'] = newValue;
                      saveThemeToPreferences(newValue);
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Theme changed',
                              style: TextStyle(fontSize: 25)),
                          content: const Text(
                            'Changes will take effect next time you open the app.',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0), // Rounded button
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // Adjust the size to fit content
                      children: [
                        Text(
                      Global.savedValues['themeMode'],
                          style: const TextStyle(
                              fontSize: 14), // Text style
                        ),
                        const SizedBox(width: 0), // Space between text and icon
                        const Icon(
                          Icons.keyboard_arrow_down,
                           // Icon color
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (BuildContext context) {
                    return theme.map((String items) {
                      return PopupMenuItem<String>(
                        value: items,
                        child: Text(items),
                      );
                    }).toList();
                  },
                ),
                title: Text(
                  'Theme',
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
