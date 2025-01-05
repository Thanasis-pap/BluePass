import 'package:passwordmanager/global_dirs.dart';

class Import extends StatefulWidget {
  const Import({super.key});

  @override
  State<Import> createState() => _Import();
}

class _Import extends State<Import> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _textController = TextEditingController();
  late PageController _pageViewController;
  int currentPage = 0;
  String encryptionKey = '';

  void getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Global.savedValues['storage'] = prefs.getBool('access') ?? false;
    });
  }

  void setBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('access', Global.savedValues['storage']);
    });
  }

  Future<bool> requestStoragePermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;
    final status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : await Permission.manageExternalStorage.request();

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
    getBool();
    currentPage = Global.savedValues['storage'] ? 1 : 0;
    _pageViewController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    currentPage = Global.savedValues['storage'] ? 1 : 0;
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
          title: Text('Import',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),),
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
                              "1. In order to import your data, you need to provide access to Android's local storage. \n\n"
                              "2. Press the Button \"Grand Storage Access\" below, and then press the \"Allow\" button in the Android dialog that will appear. \n\n"
                              "3. You can also grant access by heading to your Android's phone Settings. Navigate to Apps -> BluePass -> Permissions -> Files & media and press \"Allow access to media only\".\n\n",
                              style: TextStyle(fontSize: 14),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              Global.savedValues['storage'] = await requestStoragePermission();
                              setBool();
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

                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Text(
                            "1. On the following field, enter your Encryption Key that you stored when you exported your data.\n\n"
                            "2. Press \"Import data\" and select your .db file with your data from your local storage. \n\n"
                            "3. After you import the data, all data will be re-encrypted with a new encryption key. You can dispose your old key.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: TextFormField(
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            controller: _textController,
                            decoration: InputDecoration(
                              label: const Text('Encryption Key'),
                              prefixIcon: const Icon(Icons.lock_rounded),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSaved: (value) => encryptionKey = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Encryption Key';
                              }
                              else if (value.contains(' ')) {
                                return 'Spaces are not acceptable';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              await dbHelper.requestStoragePermission();
                              String? message = await dbHelper
                                  .importDatabaseFromCSV(_textController.text);
                              toastification.show(
                                context: context,
                                type: message == null
                                    ? ToastificationType.success
                                    : ToastificationType.error,
                                style: ToastificationStyle.flat,
                                alignment: Alignment.bottomCenter,
                                showProgressBar: false,
                                title: Text(message ?? 'Data imported successfully'),
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                            },
                            child: Text(
                              'Import Data',
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
