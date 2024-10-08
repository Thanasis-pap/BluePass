import 'package:passwordmanager/global_dirs.dart';

import '../widgets/search.dart';

class MyHomePage extends StatefulWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = GlobalKey<ExpandableFabState>();
  final recentHelper = Recent();
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>?> recentItems = [];
  List<Map<String, dynamic>?> favorItems = [];
  List<Map<String, dynamic>> searchItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  //String user = Global.user[1];
  bool showOptions = false;
  IconData fabIcon = Icons.add;

  Future<void> fetchAllItems() async {
    List<Map<String, dynamic>> cards = (await dbHelper.getCards())
        .where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList();

    List<Map<String, dynamic>> passwords = (await dbHelper.getPasswords())
        .where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList();

    setState(() {
      searchItems = [...cards, ...passwords]; // Combine cards and passwords
      //filteredItems = searchItems; // Initially show all items
    });
  }

  // Filter search results based on the input text
  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = []; // Clear the list if the search query is empty
      } else {
        filteredItems = searchItems.where((item) {
          final itemName = item['name'].toLowerCase();
          return itemName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Fetch recent items (recently opened cards and passwords)
  Future<void> fetchRecentItems() async {
    List<Map<String, dynamic>> items = [];

    // Fetch the most recent card IDs that the user has opened
    for (int id in Global.recentCards.take(5)) {
      Map<String, dynamic>? card = await dbHelper.findCardById(id);
      if (card != null) {
        card['type'] = 'card';
        items.add(card);
      }
    }

    // Fetch the most recent password IDs that the user has opened
    for (int id in Global.recentPasswords.take(5)) {
      Map<String, dynamic>? password = await dbHelper.findPasswordById(id);
      if (password != null) {
        password['type'] =
            'password'; // Add a type field to identify it as a password
        items.add(password);
      }
    }

    // Take the first 5 items combined from both recent passwords and cards
    items = items.take(5).toList();

    setState(() {
      recentItems = items; // Update the state with recent items
    });
  }

  Future<void> fetchFavoriteItems() async {
    List<Map<String, dynamic>> favoriteItems = [];

    // Fetch favorite cards from the database where favorite = 1
    List<Map<String, dynamic>> favoriteCards =
        await dbHelper.getFavoriteCards();
    // Add the 'type' field to each card item
    favoriteCards = favoriteCards.map((card) {
      card['type'] = 'card';
      return card;
    }).toList();
    favoriteItems.addAll(favoriteCards);

    // Fetch favorite passwords from the database where favorite = 1
    List<Map<String, dynamic>> favoritePasswords =
        await dbHelper.getFavoritePasswords();
    // Add the 'type' field to each password item
    favoritePasswords = favoritePasswords.map((password) {
      password['type'] = 'password';
      return password;
    }).toList();
    favoriteItems.addAll(favoritePasswords);

    setState(() {
      favorItems = favoriteItems; // Update the state with favorite items
    });
  }

  void toggleOptions() {
    setState(() {
      showOptions = !showOptions;
      if (showOptions == false) {
        fabIcon = Icons.add;
      } else {
        fabIcon = Icons.close;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRecentItems();
    fetchFavoriteItems();
    fetchAllItems();
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          children: [
            Image.asset('assets/password.png', width: 30),
            SizedBox(
              width: 15,
            ),
            Text("Hello, ${widget.title}",
                style: const TextStyle(fontSize: (28))),
          ],
        ),
        centerTitle: false,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
        ),
        key: _key,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        children: [
          Row(
            children: [
              const Text('Add Card', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditCard(
                              title: "New Card", data: null))).then((value) {
                    fetchFavoriteItems();
                    fetchRecentItems();
                    fetchAllItems();
                  });
                  final state = _key.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                },
                child: const Icon(Icons.add_card_rounded),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Add Password', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditPassword(
                              title: "New Password",
                              data: null))).then((value) {
                    fetchFavoriteItems();
                    fetchRecentItems();
                    fetchAllItems();
                  });
                  final state = _key.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                },
                child: const Icon(Icons.lock_outline_rounded),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        animationDuration: const Duration(seconds: 1),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, size: 32),
            icon: Icon(Icons.home_outlined, size: 32),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search, size: 32),
            icon: Icon(Icons.search_outlined, size: 32),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.password, size: 32),
            icon: Icon(Icons.password_outlined, size: 32),
            label: 'Passwords',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, size: 32),
            icon: Icon(Icons.settings_outlined, size: 32),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        Center(
          child: ListView(
            //shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            children: <Widget>[
              Text(
                'Favorites',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 140, // Define the height for the horizontal list
                child: favorItems.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.star_border_rounded,
                                size: 50, color: Colors.grey),
                            Text(
                              'No favorite items',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: favorItems.length,
                        itemBuilder: (context, index) {
                          final item = favorItems[index];
                          return SizedBox(
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (item != null) {
                                    if (item['type'] == 'password') {
                                      Recent.openPassword(item['id']);
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => PasswordPage(
                                                      password: item)))
                                          .then((context) {
                                        setState(() {
                                          fetchAllItems();
                                          fetchFavoriteItems();
                                          fetchRecentItems();
                                        });
                                      });
                                    } else {
                                      Recent.openCard(item['id']);
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CardPage(card: item)))
                                          .then((context) {
                                        setState(() {
                                          fetchAllItems();
                                          fetchFavoriteItems();
                                          fetchRecentItems();
                                        });
                                      });
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  backgroundColor:
                                      Color(int.parse(item?['color']))
                                          .withOpacity(0.7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(25), // <-- Radius
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  // Center the content in the button
                                  children: [
                                    // Faded, scaled background icon
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Opacity(
                                        opacity: 1,
                                        // Set the fade effect (0.0 is fully transparent, 1.0 is fully opaque)
                                        child: Icon(
                                            item?['type'] == 'password'
                                                ? Icons.lock_outline_rounded
                                                : Icons.credit_card_rounded,
                                            size: 100,
                                            // Scale the icon larger than the button
                                            color: Color(
                                                int.parse(item?['color']))),
                                      ),
                                    ),
                                    // Text on top of the button
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      item?['name'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
              const SizedBox(height: 20),
              Text(
                'Tools',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Tools.tools(context),
              const SizedBox(height: 20),
              Text(
                'Recent',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // height: 500, // Define the height for the horizontal list
                child: recentItems.isEmpty
                    ? const SizedBox(
                        height: 140,
                        // Define the height for the horizontal list
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.history_rounded,
                                  size: 50, color: Colors.grey),
                              Text(
                                'No recent items',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        //scrollDirection: Axis.horizontal,
                        itemCount: recentItems.length,
                        itemBuilder: (context, index) {
                          final item = recentItems[index];
                          return SizedBox(
                            //width: 200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SizedBox(
                                height: 65,
                                child: ElevatedButton(
                                  onPressed: () {
                                    fetchFavoriteItems();
                                    fetchRecentItems();
                                    fetchAllItems();
                                    if (item != null) {
                                      if (item['type'] == 'password') {
                                        Recent.openPassword(item['id']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => PasswordPage(
                                                    password: item))).then(
                                            (context) {
                                          setState(() {
                                            fetchAllItems();
                                            fetchFavoriteItems();
                                            fetchRecentItems();
                                          });
                                        });
                                      } else {
                                        Recent.openCard(item['id']);
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CardPage(card: item)))
                                            .then((context) {
                                          setState(() {
                                            fetchAllItems();
                                            fetchFavoriteItems();
                                            fetchRecentItems();
                                          });
                                        });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // <-- Radius
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      overflow: TextOverflow.ellipsis,
                                      item?['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        //fontWeight: FontWeight.bold,
                                        //color: Colors.white, // Text color
                                      ),
                                    ),
                                    leading: Icon(
                                      item?['type'] == 'password'
                                          ? Icons.lock_outline_rounded
                                          : Icons.credit_card_rounded,
                                      // Use the password icon
                                      size:
                                          40, // Scale the icon larger than the button
                                      //color: Colors.blue, // Set the color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        Column(
            //direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: Text(
                  'Search',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filterItems(value); // Filter items based on search input
                  },
                  decoration: InputDecoration(
                    label: const Text(
                      'Search passwords or cards',
                      style: TextStyle(fontSize: 18),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              filteredItems.isEmpty
                  ? Align(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Nothing here yet.', // Initial message
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: filteredItems.isNotEmpty
                          ? ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> item =
                                    filteredItems[index];
                                bool isCard = item.containsKey(
                                    'card_number'); // Assuming card has 'card_number'

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: SizedBox(
                                    height: 65,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        // If it's a card, handle card click
                                        if (isCard) {
                                          Recent.openCard(item['id']);
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          CardPage(card: item)))
                                              .then((context) {
                                            setState(() {
                                              fetchFavoriteItems();
                                              fetchRecentItems();
                                              fetchAllItems();
                                            });
                                          });
                                          // Navigate to card details or handle another action
                                        } else {
                                          Recent.openPassword(item['id']);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => PasswordPage(
                                                      password: item))).then(
                                              (context) {
                                            setState(() {
                                              fetchFavoriteItems();
                                              fetchRecentItems();
                                              fetchAllItems();
                                            });
                                          });
                                          // Navigate to password details or handle another action
                                        }
                                      },
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 20, 0),
                                        title: Text(
                                          item['name'], // Display name
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        leading: isCard
                                            ? const Icon(
                                                Icons.credit_card_rounded,
                                                size: 40,
                                              )
                                            : const Icon(
                                                Icons.lock_rounded,
                                                size: 40,
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No results found'),
                            ),
                    ),
            ]),
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SizedBox(
                height: 160,
                child: ElevatedButton(
                  onPressed: () async {
                    List<Map<String, dynamic>> passwords =
                        await dbHelper.getPasswords();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PasswordsList(
                                  passData: passwords,
                                ))).then((value) {
                      fetchFavoriteItems();
                      fetchRecentItems();
                      fetchAllItems();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.orange.shade500.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    // Center the content in the button
                    children: [
                      // Faded, scaled background icon
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image.asset(
                          'assets/password.png',
                          height: 100,
                        ),
                      ),
                      // Text on top of the button
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            'Passwords',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SizedBox(
                height: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    List<Map<String, dynamic>> cards =
                        await dbHelper.getCards();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CardsList(
                                  cardData: cards,
                                ))).then((value) {
                      fetchRecentItems();
                      fetchFavoriteItems();
                      fetchAllItems();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.orange.shade500.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    // Center the content in the button
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image.asset(
                          'assets/card.png',
                          height: 60,
                        ),
                      ),
                      // Faded, scaled background icon
                      const Opacity(
                        opacity: 0.1,
                        // Set the fade effect (0.0 is fully transparent, 1.0 is fully opaque)
                      ),
                      // Text on top of the button
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            'Credit Cards',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ListView(
          children: Settings.settingsCategories(context),
        ),
      ][currentPageIndex],
    );
  }

  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
}
