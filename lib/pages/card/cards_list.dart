import 'package:passwordmanager/global_dirs.dart';

class CardsList extends StatefulWidget {
  final List<Map<String, dynamic>> cardData;

  const CardsList({super.key, required this.cardData});

  @override
  _CardList createState() => _CardList();
}

class _CardList extends State<CardsList> {
  final dbHelper = DatabaseHelper();

  Set<int> selectedCards = {};

  // Toggle card selection
  void toggleCardSelection(int cardId) {
    setState(() {
      if (selectedCards.contains(cardId)) {
        selectedCards.remove(cardId);
      } else {
        selectedCards.add(cardId);
      }
    });
  }

  // Delete selected cards
  void deleteSelectedCards() async {
    for (var cardId in selectedCards) {
      await dbHelper.deleteCard(cardId);
    }
    setState(() {
      widget.cardData.removeWhere((card) => selectedCards.contains(card['id']));
      selectedCards.clear(); // Clear selection after deletion
    });
  }

  void navigateToCard(Map<String, dynamic> card) async {
    // Push the EditCard page and wait for the result
    final bool? isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardPage(card: card),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedCards.isNotEmpty) {
          // If any card is selected, unselect them when back is pressed
          setState(() {
            selectedCards.clear();
          });
          return false; // Prevent the back navigation
        } else {
          return true; // Allow normal back navigation if no cards are selected
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          toolbarHeight: 100,
          title:
              Text('Cards', style: TextStyle(fontSize: (28))),
          actions: selectedCards.isNotEmpty
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
                                  'Are you sure you want to delete these cards?',
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
                                    deleteSelectedCards();
                                    toastification.show(
                                      context: context,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.bottomCenter,
                                      showProgressBar: false,
                                      title: const Text(
                                          'Selected cards have been deleted'),
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
                      ))
                ]
              : [], // Show delete button if any card is selected
        ),
        body: widget.cardData.isNotEmpty
            ? ListView(
                children: widget.cardData.map((card) {
                  //Global.card = card;
                  // Extract the color from the card data and convert it from string to Color
                  Color cardColor = Color(int.parse(card['color']));
                  bool isSelected = selectedCards.contains(card['id']);
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
                              : cardColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Border radius of 35
                          ),
                        ),
                        onPressed: () {
                          if (selectedCards.isEmpty) {
                            Recent.openCard(card['id']);
                            navigateToCard(card);
                          } else {
                            // Toggle selection if a card is already selected
                            toggleCardSelection(card['id']);
                          }
                        },
                        onLongPress: () {
                          // Long press to select card
                          toggleCardSelection(card['id']);
                        },
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 20, 0),
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            card['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Colors.white, // Text color
                            ),
                          ),
                          subtitle: Text(
                            overflow: TextOverflow.ellipsis,
                            card['card_holder'].replaceAll('_', ' '),
                            style: const TextStyle(
                              fontSize: 16,
                              //color: Colors.white, // Text color
                            ),
                          ),
                          trailing: Text(
                            "**** " +
                                card['card_number']
                                    .substring(card['card_number'].length - 4),
                            style: const TextStyle(
                              fontSize: 16,
                              //color: Colors.white, // Text color
                            ),
                          ),
                          leading: const Icon(
                            Icons.credit_card_rounded, // Use the password icon
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
                    Icon(Icons.credit_card_off_rounded,size: 50,color: Colors.grey,),
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
