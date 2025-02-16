import 'package:passwordmanager/global_dirs.dart';

enum SampleItem { info, logOut }

enum Favorite { favorite }

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = GlobalKey<ExpandableFabState>();
  final recentHelper = Recent();
  final dbHelper = DatabaseHelper();
  final Logout logOut = Logout();
  int currentPageIndex = 0;
  SampleItem? selectedItem;
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

    // Add a 'type' field to each card
    cards = cards.map((card) {
      card['type'] = 'card';
      return card;
    }).toList();

    // Add a 'type' field to each password
    passwords = passwords.map((password) {
      password['type'] = 'password';
      return password;
    }).toList();

    setState(() {
      searchItems = [...passwords, ...cards]; // Combine cards and passwords
      // filteredItems = searchItems; // Uncomment if filtered items are needed
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

    // Fetch favorite passwords from the database where favorite = 1
    List<Map<String, dynamic>> favoritePasswords =
        await dbHelper.getFavoritePasswords();
    // Add the 'type' field to each password item
    favoritePasswords = favoritePasswords.map((password) {
      password['type'] = 'password';
      return password;
    }).toList();
    favoriteItems.addAll(favoritePasswords);

    List<Map<String, dynamic>> favoriteCards =
        await dbHelper.getFavoriteCards();
    // Add the 'type' field to each card item
    favoriteCards = favoriteCards.map((card) {
      card['type'] = 'card';
      return card;
    }).toList();
    favoriteItems.addAll(favoriteCards);

    setState(() {
      favorItems = favoriteItems; // Update the state with favorite items
    });
  }

  void refreshValues() {
    setState(() {
      fetchAllItems();
      fetchFavoriteItems();
      fetchRecentItems();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF3F7BD7), // Status bar
        ),
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "BluePass",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            PopupMenuButton<SampleItem>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15), // Set the desired radius here
                ),
              ),
              offset: Offset(0, 10),
              position: PopupMenuPosition.under,
              initialValue: null,
              icon: CircleAvatar(
                backgroundColor: const Color(0xFF1A32CC),
                radius: 20,
                child: Text(Global.savedValues['name'][0],
                    style: const TextStyle(fontSize: 25, color: Colors.white)),
              ),
              onSelected: (SampleItem item) {
                setState(() {
                  selectedItem = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                PopupMenuItem<SampleItem>(
                  value: SampleItem.info,
                  child: const ListTile(
                    leading: Icon(
                      Icons.settings_rounded,
                      size: 24,
                      color: Color(0xFF1A32CC),
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Settings()))
                        .then((value) {
                      setState(() {});
                    });
                  },
                ),
                logOut.button(context),
              ],
            ),
          ],
        ),
        centerTitle: false,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: DefaultFloatingActionButtonBuilder(
          backgroundColor: Color(0xFF3F7BD7),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          backgroundColor: Color(0xFF3F7BD7),
          foregroundColor: Colors.white,
          child: const Icon(Icons.close),
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
                backgroundColor: Color(0xFF3F7BD7),
                foregroundColor: Colors.white,
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditCard(
                              title: "New Card", data: null))).then((context) {
                    refreshValues();
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
                backgroundColor: Color(0xFF3F7BD7),
                foregroundColor: Colors.white,
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditPassword(
                              title: "New Password",
                              data: null))).then((context) {
                    refreshValues();
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
            selectedIcon: Icon(Icons.home_rounded, size: 32),
            icon: Icon(Icons.home_outlined, size: 32),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search_rounded, size: 32),
            icon: Icon(Icons.search_rounded, size: 32),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.password_rounded, size: 32),
            icon: Icon(Icons.password_rounded, size: 32),
            label: 'Tools',
          ),
        ],
      ),
      body: <Widget>[
        Center(
          child: ListView(
            //shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            children: <Widget>[
              favorItems.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Your ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                            "Favorites",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              favorItems.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 20,left: 5),
                      child: SizedBox(
                        height:
                            120, // Define the height for the horizontal list
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favorItems.length,
                            itemBuilder: (context, index) {
                              final item = favorItems[index];
                              return SizedBox(
                                width: 150,
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
                                      elevation: 1,
                                      padding: EdgeInsets.zero,
                                      backgroundColor:
                                          Color(int.parse(item?['color']))
                                              .withOpacity(0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // <-- Radius
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
                                            opacity: 0.9,
                                            // Set the fade effect (0.0 is fully transparent, 1.0 is fully opaque)
                                            child: Icon(
                                                item?['type'] == 'password'
                                                    ? Icons.lock_outline_rounded
                                                    : Icons.credit_card_rounded,
                                                size: 80,
                                                // Scale the icon larger than the button
                                                color: Color(
                                                    int.parse(item?['color']))),
                                          ),
                                        ),
                                        // Text on top of the button
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              item?['name'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: PopupMenuButton<SampleItem>(
                                            icon: Icon(
                                              Icons.more_vert_rounded,
                                              color: Colors.white,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    15), // Set the desired radius here
                                              ),
                                            ),
                                            offset: Offset(0, 10),
                                            position: PopupMenuPosition.under,
                                            initialValue: null,
                                            onSelected: (SampleItem item) {
                                              setState(() {
                                                selectedItem = item;
                                              });
                                            },
                                            itemBuilder: (BuildContext
                                                    context) =>
                                                <PopupMenuEntry<SampleItem>>[
                                              PopupMenuItem<SampleItem>(
                                                value: SampleItem.info,
                                                height: 35,
                                                onTap: () async {
                                                  if (item?['type'] ==
                                                      'password') {
                                                    item?['favorite'] = false;
                                                    await dbHelper.editPassword(
                                                        item?['id'], item!);
                                                    setState(() {
                                                      fetchFavoriteItems();
                                                      fetchRecentItems();
                                                    });
                                                  } else if (item?['type'] ==
                                                      'card') {
                                                    item?['favorite'] = false;
                                                    await dbHelper.editCard(
                                                        item?['id'], item!);
                                                    toastification.show(
                                                      context: context,
                                                      style: ToastificationStyle
                                                          .flat,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      showProgressBar: false,
                                                      title: Text(
                                                          'Removed from favorites'),
                                                      autoCloseDuration:
                                                          const Duration(
                                                              seconds: 2),
                                                    );
                                                    setState(() {
                                                      fetchFavoriteItems();
                                                      fetchRecentItems();
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                    'Remove from Favorites'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 120,
                    width: 160,
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
                        backgroundColor: Color(0xFF3F7BD7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Center the content in the button
                        children: [
                          // Faded, scaled background icon
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 60,
                            color: Color(0xFF160679),
                          ),
                          // Text on top of the button
                          Text(
                            'Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white // Text color
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    width: 160,
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
                        backgroundColor: Color(0xFF160679),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // <-- Radius
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Center the content in the button
                        children: [
                          // Faded, scaled background icon
                          Icon(
                            Icons.credit_card_rounded,
                            size: 60,
                            color: Color(0xFF3F7BD7),
                          ),
                          // Text on top of the button
                          Text(
                            'Card',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white // Text color
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(),
                    ),
                  ),
                  SizedBox(
                    // height: 500, // Define the height for the horizontal list
                    child: recentItems.isEmpty
                        ? const SizedBox(
                            height: 140,
                            // Define the height for the horizontal list
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.history_rounded,
                                      size: 50, color: Colors.grey),
                                  Text(
                                    'No recent items',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                //scrollDirection: Axis.horizontal,
                                itemCount: recentItems.length,
                                itemBuilder: (context, index) {
                                  final item = recentItems[index];
                                  return
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
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
                                                            builder: (_) =>
                                                                PasswordPage(
                                                                    password:
                                                                        item)))
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
                                                                CardPage(
                                                                    card:
                                                                        item)))
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
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // <-- Radius
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              overflow: TextOverflow.ellipsis,
                                              item?['name'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: item?['type'] ==
                                                    'password'
                                                ? IconButton(
                                                    icon:
                                                        const Icon(Icons.copy),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                              ClipboardData(
                                                                  text: item?[
                                                                      'password']))
                                                          .then((_) {
                                                        toastification.show(
                                                          context: context,
                                                          type:
                                                              ToastificationType
                                                                  .success,
                                                          style:
                                                              ToastificationStyle
                                                                  .flat,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          showProgressBar:
                                                              false,
                                                          title: const Text(
                                                              'Copied successfully'),
                                                          autoCloseDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1500),
                                                        );
                                                      });
                                                    },
                                                  )
                                                : SizedBox(),
                                            leading: CircleAvatar(
                                              radius: 22,
                                              backgroundColor: Color(
                                                      int.parse(item?['color']))
                                                  .withOpacity(0.5),
                                              child: Icon(
                                                color: Color(
                                                    int.parse(item?['color'])),
                                                item?['type'] == 'password'
                                                    ? Icons.lock_outline_rounded
                                                    : Icons.credit_card_rounded,
                                                // Use the password icon
                                                size:
                                                    32, // Scale the icon larger than the button
                                                //color: Colors.blue, // Set the color of the icon
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  );
                                }),
                          ),
                  ),
                  /*Icon(Icons.search_off_rounded,
                          size: 50, color: Colors.grey),
                      */
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        ListView(
            //direction: Axis.vertical,
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: Text(
                  'Search',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filterItems(value); // Filter items based on search input
                  },
                  decoration: InputDecoration(
                    label: const Text(
                      'Type to search...',
                      style: TextStyle(fontSize: 18),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              filteredItems.isEmpty
                  ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0),
                  child:Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: searchItems.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> item = searchItems[index];
                            bool isCard = item.containsKey(
                                'card_number'); // Assuming card has 'card_number'

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5.0),
                              child: SizedBox(
                                height: 65,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                                      password: item)))
                                          .then((context) {
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
                                    title: Text(
                                      item['name'], // Display name
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          Color(int.parse(item['color']))
                                              .withOpacity(0.5),
                                      child: Icon(
                                        color: Color(int.parse(item['color'])),
                                        item['type'] == 'password'
                                            ? Icons.lock_outline_rounded
                                            : Icons.credit_card_rounded,
                                        // Use the password icon
                                        size:
                                            32, // Scale the icon larger than the button
                                        //color: Colors.blue, // Set the color of the icon
                                      ),
                                    ),
                                    trailing: !isCard
                                        ? IconButton(
                                            icon: const Icon(Icons.copy),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: item['password']))
                                                  .then((_) {
                                                toastification.show(
                                                  type: ToastificationType
                                                      .success,
                                                  style:
                                                      ToastificationStyle.flat,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  showProgressBar: false,
                                                  title: const Text(
                                                      'Copied successfully'),
                                                  autoCloseDuration:
                                                      const Duration(
                                                          milliseconds: 1500),
                                                );
                                              });
                                            },
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),)
                  : Animate(
                      effects: [
                        FadeEffect(),
                      ],
                      child: filteredItems.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> item =
                                    filteredItems[index];
                                bool isCard = item.containsKey(
                                    'card_number'); // Assuming card has 'card_number'

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 30.0),
                                  child: SizedBox(
                                    height: 65,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 1,
                                        padding: EdgeInsets.zero,
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
                                        title: Text(
                                          item['name'], // Display name
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          radius: 22,
                                          backgroundColor:
                                              Color(int.parse(item['color']))
                                                  .withOpacity(0.5),
                                          child: Icon(
                                            color: Color(
                                                int.parse(item['color'])),
                                            item['type'] == 'password'
                                                ? Icons.lock_outline_rounded
                                                : Icons.credit_card_rounded,
                                            // Use the password icon
                                            size:
                                                32, // Scale the icon larger than the button
                                            //color: Colors.blue, // Set the color of the icon
                                          ),
                                        ),
                                        trailing: !isCard
                                            ? IconButton(
                                                icon: const Icon(Icons.copy),
                                                onPressed: () {
                                                  Clipboard.setData(
                                                          ClipboardData(
                                                              text: item[
                                                                  'password']))
                                                      .then((_) {
                                                    toastification.show(
                                                      context: context,
                                                      type: ToastificationType
                                                          .success,
                                                      style: ToastificationStyle
                                                          .flat,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      showProgressBar: false,
                                                      title: const Text(
                                                          'Copied successfully'),
                                                      autoCloseDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  1500),
                                                    );
                                                  });
                                                },
                                              )
                                            : SizedBox(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : SizedBox(),
                    ),
            ]),
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Password ",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    "Tools",
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Tools.tools(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ][currentPageIndex],
    );
  }

  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
}
