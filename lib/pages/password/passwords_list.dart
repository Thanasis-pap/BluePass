import 'package:passwordmanager/global_dirs.dart';

class PasswordsList extends StatefulWidget {
  final List<Map<String, dynamic>> passData;

  const PasswordsList({super.key, required this.passData});

  @override
  _PasswordsList createState() => _PasswordsList();
}

class _PasswordsList extends State<PasswordsList> {
  final dbHelper = DatabaseHelper();
  final _key = GlobalKey<ExpandableFabState>();
  Set<int> selectedPasswords = {};

  // Toggle card selection
  void togglePasswordSelection(int cardId) {
    setState(() {
      if (selectedPasswords.contains(cardId)) {
        selectedPasswords.remove(cardId);
      } else {
        selectedPasswords.add(cardId);
      }
    });
  }

  // Delete selected cards
  void deleteSelectedPasswords() async {
    for (var cardId in selectedPasswords) {
      await dbHelper.deletePassword(cardId);
    }
    setState(() {
      widget.passData
          .removeWhere((card) => selectedPasswords.contains(card['id']));
      selectedPasswords.clear(); // Clear selection after deletion
    });
  }

  void navigateToPassword(Map<String, dynamic> password) async {
    // Push the EditCard page and wait for the result
    final bool? isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordPage(password: password),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedPasswords.isNotEmpty) {
          // If any card is selected, unselect them when back is pressed
          setState(() {
            selectedPasswords.clear();
          });
          return false; // Prevent the back navigation
        } else {
          return true; // Allow normal back navigation if no cards are selected
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          title: Text('Passwords',
              style: TextStyle(fontSize: (28))),
          actions: selectedPasswords.isNotEmpty
              ? [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Warning',
                                  style: TextStyle(fontSize: 28)),
                              content: const Text(
                                  'Are you sure you want to delete these passwords?',
                                  style: TextStyle(fontSize: 18)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: Text('Cancel',
                                      style:
                                          TextStyle(fontSize: 18)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    deleteSelectedPasswords();
                                    toastification.show(
                                      context: context,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.bottomCenter,
                                      showProgressBar: false,
                                      title: const Text(
                                          'Selected passwords have been deleted'),
                                      autoCloseDuration:
                                          const Duration(seconds: 2),
                                    );
                                    Navigator.pop(context, 'Yes');
                                  },
                                  child: Text('Yes',
                                      style:
                                          TextStyle(fontSize: 18)),
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                ]
              : [], // Show delete button if any card is selected
        ),
        body: widget.passData.isNotEmpty
            ? ListView(
                children: widget.passData.map((password) {
                  Color cardColor = Color(int.parse(password['color']));
                  bool isSelected = selectedPasswords.contains(password['id']);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    // Padding of 10 between buttons
                    child: SizedBox(
                      height: 85,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: isSelected
                              ? cardColor.withOpacity(0.8)
                              : cardColor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Border radius of 35
                          ),
                        ),
                        onPressed: () {
                          if (selectedPasswords.isEmpty) {
                            Recent.openPassword(password['id']);
                            navigateToPassword(password);
                          } else {
                            // Toggle selection if a card is already selected
                            togglePasswordSelection(password['id']);
                          }
                        },
                        onLongPress: () {
                          // Long press to select card
                          togglePasswordSelection(password['id']);
                        },
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 0, 20, 0),
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            password['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Colors.white, // Text color
                            ),
                          ),
                          subtitle: Text(
                            overflow: TextOverflow.ellipsis,
                            password['webpage'].replaceAll('_', ' '),
                            style: const TextStyle(
                              fontSize: 16,
                              //color: Colors.white, // Text color
                            ),
                          ),
                          trailing: const Text(
                            "********",
                            style: TextStyle(
                              fontSize: 16,
                              //color: Colors.white, // Text color
                            ),
                          ),
                          leading: const Icon(
                            Icons.lock_outline_rounded, // Use the password icon
                            size: 40, // Scale the icon larger than the button
                            //color: Colors.blue, // Set the color of the icon
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.key_off_rounded,size: 50,color: Colors.grey,),
                    SizedBox(height: 10,),
                    Text(
                      'Nothing here yet.',
                      style: TextStyle(fontSize: 18,color: Colors.grey),
                      maxLines: 2,
                    ),
                    SizedBox(height: 100,)
                  ],
                ),
              ),
      ),
    );
  }
}
