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
          title: const Text('Security Questions', style: TextStyle(fontSize: (28))),
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
                            'Enable biometrics',
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
                              "1. In order to restore your password, you need to enable biometric authentication. \n\n"
                              "2. Head to \"Settings\"->\"Security and Privacy\". \n\n"
                              "3. Click on the \"Biometric Login\" toggle. \n\n"
                              "4. If you have already enabled Biometric login, click \"Continue\". \n\n",
                              style: TextStyle(fontSize: 14),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              setBool();
                            },
                            child: Text(
                              'Continue',
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
                            'Recovery Key',
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
                            "1. Press \"Show Recovery Key\" to reveal your Recovery key. You need this key to recover your password\n\n"
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
