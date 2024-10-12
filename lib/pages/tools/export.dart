import 'package:passwordmanager/global_dirs.dart';

class Export extends StatefulWidget {
  const Export({super.key});

  @override
  State<Export> createState() => _Export();
}

class _Export extends State<Export> {
  final dbHelper = DatabaseHelper();

  late PageController _pageViewController;
  int currentPage = 0;



  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Storage Access granted successfully'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      goToNextPage();
      return true;
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Access Denied. Please try again to continue'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  void goToNextPage() {
    if (currentPage < 2) {
      setState(() {
        currentPage++;
      });
    }
    _pageViewController.animateToPage(
      currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
    _pageViewController.animateToPage(
      currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    currentPage = Global.storage ? 1 : 0;
    _pageViewController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    currentPage = Global.storage ? 1 : 0;
    _pageViewController.dispose();
    //_tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 75,
          backgroundColor: Theme.of(context).colorScheme.surface,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Export Data', style: TextStyle(fontSize: (28))),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                /// Use [Axis.vertical] to scroll vertically.
                controller: _pageViewController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30),
                          child: Text(
                            'Grant Access',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 200,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      20) // Adjust the radius as needed
                                  ),
                              child: Image.asset(
                                "assets/allow_access.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 30),
                            child: Text(
                              "1. In order to save your data locally, you need to provide access to Android's local storage. \n\n"
                              "2. Press the Button \"Grand Storage Access\" below, and then press the \"Allow\" button in the Android dialog that will appear. \n\n"
                              "3. You can also grant access by heading to your Android's phone Settings. Navigate to Apps -> BluePass -> Permissions -> Files & media and press \"Allow access to media only\".\n\n",
                              style: TextStyle(fontSize: 14),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              Global.storage = await requestStoragePermission();
                            },
                            child: Text(
                              'Request Storage Access',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30),
                          child: Text(
                            'Encryption Key',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Text(
                            "1. Press \"Show Encryption Key\" to reveal your encryption key. You need this key to import your data to another device.\n\n"
                            "2. Be VERY careful with your encryption key. DO NOT upload it anywhere or store it in a Notebook app. Otherwise you risk exposing your data. \n\n"
                            "3. After you store your encryption key, press \"Export Data\" to save your data on your local storage.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      KeyDialog());
                            },
                            child: Text(
                              'Show Encryption Key',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class KeyDialog extends StatefulWidget {
  const KeyDialog({super.key});

  @override
  _KeyDialogState createState() => _KeyDialogState();
}

class _KeyDialogState extends State<KeyDialog> {
  final TextEditingController _textController = TextEditingController();
  bool isButtonEnabled = false;
  final dbHelper = UserDatabaseHelper();
  final dbDataHelper = DatabaseHelper();
  final SecureKeyStorage _keyStorage = SecureKeyStorage();

  Future<String?> get _key async {
    String? keyBase64 = await _keyStorage.retrieveKey();
    return keyBase64;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void enabledCancel() {
    Navigator.pop(context, 'Cancel');
  }

  Future<void> _onKeyPressed() async {
    toastification.show(
      context: context,
      style: ToastificationStyle.flat,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      title: const Text('Database saved successfully'),
      autoCloseDuration: const Duration(seconds: 2),
    );
    await dbDataHelper.exportDatabaseToDownloads();

    String newKey = _keyStorage.generateAESKey();
    await dbHelper.reEncryptAllUserData(newKey);
    await dbDataHelper.reencryptPasswords(newKey);
    await dbDataHelper.reencryptCards(newKey);
    await _keyStorage.storeKey(newKey);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Warning',
            style: TextStyle(fontSize: 25, color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "You are about to see your encryption key. After you press \"Save data\" your data in this device will re-encrypt with a new encryption key. \n\n"
              "Note: For security reasons, the key cannot be directly copied.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLines: null,
              controller: _textController,
              enableInteractiveSelection: false,
              readOnly: true,
              decoration: InputDecoration(
                label: const Text('Encryption key'),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              //onSaved: (value) => _name = value!,
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isButtonEnabled = true;
                    });

                    String? keyBase64 = await _key;
                    _textController.text = keyBase64!;
                  },

                  child: Text('Show key')),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isButtonEnabled ?null : enabledCancel,
            child: Text('Cancel',
                style: TextStyle(
                    fontSize: 18,
                    color: isButtonEnabled
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary)),
          ),
          ElevatedButton(
            onPressed: isButtonEnabled ? _onKeyPressed : null,
            child: Text('Continue',
                style: TextStyle(
                    fontSize: 18,
                    color: isButtonEnabled ? Colors.red : Colors.grey)),
          ),
        ],
      ),
    );
  }
}
