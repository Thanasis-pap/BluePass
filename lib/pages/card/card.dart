import 'package:passwordmanager/global_dirs.dart';

class CardPage extends StatefulWidget {
  final Map<String, dynamic> card;

  const CardPage({super.key, required this.card});

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  final dbHelper = DatabaseHelper();

  void navigateToEditCard(Map<String, dynamic> card) async {
    // Push the EditCard page and wait for the result
    final bool? isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCard(title: 'Edit Card', data: card),
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Global.card = widget.card;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          title: Text(Global.card['name']),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                        size: 30,
                        Global.card['favorite']
                            ? Icons.star_rounded
                            : Icons.star_border_rounded),
                    color: const Color(0xFF3F7BD7),
                    onPressed: () {
                      setState(() {
                        Global.card['favorite'] = !Global.card['favorite'];
                        toastification.show(
                          context: context,
                          style: ToastificationStyle.flat,
                          alignment: Alignment.bottomCenter,
                          showProgressBar: false,
                          title: Text(Global.card['favorite']
                              ? 'Added to favorites'
                              : 'Removed from favorites'),
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        dbHelper.editCard(Global.card['id'], Global.card);
                      }); // Handle delete action
                    },
                  ),
                  IconButton(
                    icon: const Icon(size: 30, Icons.edit_rounded),
                    color: const Color(0xFF3F7BD7),
                    onPressed: () {
                      navigateToEditCard(Global.card);
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
                              'Are you sure you want to delete this card?',
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
                                await dbHelper.deleteCard(Global.card['id']);
                                toastification.show(
                                  context: context,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.bottomCenter,
                                  showProgressBar: false,
                                  title: const Text(
                                      'Card has been deleted'),
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: SizedBox(
              width: 320.0,
              height: 250,
              child: Card.filled(
                elevation: 0,
                color: Color(int.parse(Global.card['color'])).withOpacity(0.7),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              width: 270,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //color: Theme.of(context).focusColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                Global.card['card_number'],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                        text: Global.card['card_number']))
                                    .then((_) {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.flat,
                                    alignment: Alignment.bottomCenter,
                                    showProgressBar: false,
                                    title: const Text('Copied successfully'),
                                    autoCloseDuration: const Duration(milliseconds: 1500),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              width: 270,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //color: Theme.of(context).focusColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                Global.card['card_holder'].replaceAll('_', ' '),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                        text: Global.card['card_holder']
                                            .replaceAll('_', ' ')))
                                    .then((_) {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.flat,
                                    alignment: Alignment.bottomCenter,
                                    showProgressBar: false,
                                    title: const Text('Copied successfully'),
                                    autoCloseDuration: const Duration(milliseconds: 1500),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: 18 * 5,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    //color: Theme.of(context).focusColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    Global.card['expiration_date'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text:
                                                Global.card['expiration_date']))
                                        .then((_) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flat,
                                        alignment: Alignment.bottomCenter,
                                        showProgressBar: false,
                                        title: const Text('Copied successfully'),
                                        autoCloseDuration: const Duration(milliseconds: 1500),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: 18 * 5,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    //color: Theme.of(context).focusColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    Global.card['cvv'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text: Global.card['cvv']))
                                        .then((_) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.flat,
                                        alignment: Alignment.bottomCenter,
                                        showProgressBar: false,
                                        title: const Text('Copied successfully'),
                                        autoCloseDuration: const Duration(milliseconds: 1500),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: SizedBox(
              height: 250,
              child: Card.filled(
                elevation: 0,
                color: Color(int.parse(Global.card['color'])).withOpacity(0.1),
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
                  subtitle: Text(
                    Global.card['notes'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} //Timestamps
