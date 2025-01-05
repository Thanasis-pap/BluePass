import 'package:passwordmanager/global_dirs.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:passwordmanager/helpers/input_formatter.dart';

class EditCard extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? data;

  const EditCard({super.key, required this.title, required this.data});

  @override
  _EditCard createState() => _EditCard();
}

class _EditCard extends State<EditCard> {
  //List previousValues = Global.card;
  bool favorite = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cardController = TextEditingController();
  final holderController = TextEditingController();
  final dateController = TextEditingController();
  final cvvController = TextEditingController();
  final notesController = TextEditingController();

  final dbHelper = DatabaseHelper();

  Map<String, dynamic> cardData = {
    'name': '',
    'card_holder': '',
    'card_number': '',
    'expiration_date': '',
    'cvv': '',
    'notes': '',
    'color': '',
    'favorite': false, // Example ARGB color as an integer
  };

  // dbHelper.insertPassword(cardData);

  Color dialogPickerColor = Colors.blue.shade600;

  final Map<ColorSwatch<Object>, String> customSwatches =
      <ColorSwatch<Object>, String>{
    ColorTools.createAccentSwatch(Colors.red.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.pink.shade600): 'Lavender',
    ColorTools.createPrimarySwatch(Colors.purple.shade600): 'blue',
    ColorTools.createAccentSwatch(Colors.deepPurple.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.blue.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.lightBlue.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.cyan.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.teal.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.green.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.lightGreen.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.lime.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.yellow.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.amber.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.orange.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.brown.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.blueGrey.shade600): 'Lavender',
    ColorTools.createAccentSwatch(Colors.grey.shade600): 'Lavender',
  };

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start and active color.
      enableShadesSelection: false,
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) => setState(() {
        dialogPickerColor = color;
        Global.card['color'] = color.value.toString();
      }),
      width: 44,
      height: 44,
      borderRadius: 22,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      customColorSwatchesAndNames: customSwatches,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.custom: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
      },
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 250, minWidth: 300, maxWidth: 320),
    );
  }

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters from the input
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Add the "/" character after the second character (for mm/yy format)
    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    // Limit the input to mm/yy format (5 characters)
    if (text.length > 5) {
      text = text.substring(0, 5);
    }

    // Return the updated text with proper cursor position
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit without saving?'),
          content: const Text('Do you want to discard your changes?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Stay on the page
              },
            ),
            ElevatedButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop(true); // Exit the page
              },
            ),
          ],
        );
      },
    ) ?? false; // Return false if the user dismisses the dialog
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      dialogPickerColor = Color(int.parse(widget.data?['color']));
      cardData = widget.data!;
      nameController.text = widget.data?['name'];
      cardController.text = widget.data?['card_number'];
      holderController.text = widget.data?['card_holder'].replaceAll('_', ' ');
      dateController.text = widget.data?['expiration_date'];
      cvvController.text = widget.data?['cvv'];
      notesController.text = widget.data?['notes'];
      dialogPickerColor = Color(int.parse(widget.data?['color']));
      favorite = widget.data?['favorite'];
    }

  }

  @override
  void dispose() {
    nameController.dispose();
    cardController.dispose();
    holderController.dispose();
    dateController.dispose();
    cvvController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Warning', style: TextStyle(fontSize: 25)),
            content: const Text('Are you sure you want to cancel editing?',
                style: TextStyle(fontSize: 16)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Text('Cancel', style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
                child: Text('Yes', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          title: Text(widget.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),),
          centerTitle: false,
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: IconButton(
                icon: Icon(
                    size: 30,
                    favorite ? Icons.star_rounded : Icons.star_border_rounded),
                color: const Color(0xFF3F7BD7),
                onPressed: () {
                  setState(() {
                    favorite = !favorite;
                  });
                  if (favorite == true) {
                    toastification.show(
                      context: context,
                      style: ToastificationStyle.flat,
                      alignment: Alignment.bottomCenter,
                      showProgressBar: false,
                      title: const Text('Card will be added to favorites'),
                      autoCloseDuration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: const Text(
                          'Bank Name',
                          style: TextStyle(fontSize: 18),
                        ),
                        prefixIcon: const Icon(Icons.account_balance_rounded),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Name';
                        }
                        Global.card['name'] = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: holderController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: const Row(
                          children: [
                            Text(
                              'Card Holder\'s Name',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 15,
                            )
                          ],
                        ),
                        prefixIcon: const Icon(Icons.perm_identity_rounded),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Card Holder \'s Name';
                        }
                        Global.card['card_holder'] = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cardController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Allow only digits
                        CardNumberInputFormatter(),
                        LengthLimitingTextInputFormatter(19),
                        // Apply the custom formatter
                      ],
                      decoration: InputDecoration(
                        label: Row(
                          children: [
                            Text(
                              'Card Number',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 15,
                            )
                          ],
                        ),
                        prefixIcon: const Icon(Icons.numbers_rounded),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Card Number';
                        }
                        Global.card['card_number'] = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: dateController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Allows only numbers
                        DateInputFormatter(),
                        LengthLimitingTextInputFormatter(7),
                        // Apply the custom date formatter
                      ],
                      decoration: InputDecoration(
                        label: Row(
                          children: [
                            Text(
                              'Expiration Date',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 15,
                            )
                          ],
                        ),
                        prefixIcon: const Icon(Icons.date_range_rounded),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Expiration Date';
                        }
                        Global.card['expiration_date'] = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cvvController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Allow only digits
                        LengthLimitingTextInputFormatter(3),
                        // Apply the custom formatter
                      ],
                      decoration: InputDecoration(
                        label: Row(
                          children: [
                            Text(
                              'CVV',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 15,
                            )
                          ],
                        ),
                        prefixIcon: const Icon(Icons.numbers_rounded),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a CVV';
                        }
                        Global.card['cvv'] = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200, //     <-- TextField expands to this height.
                      child: TextFormField(
                        maxLength: 200,
                        controller: notesController,
                        maxLines: 6,
                        // Set this
                        //expands: true, // and this
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          label: Text(
                            'Notes',
                            style: TextStyle(fontSize: 18),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          Global.card['notes'] = value;
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Border radius of 35
                          ),
                        ),
                        child: ListTile(
                          //contentPadding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                          title: Text(
                            'Color',
                            style: TextStyle(fontSize: 18),
                          ),
                          leading: const Icon(Icons.colorize_rounded),
                          trailing: ColorIndicator(
                            width: 33,
                            height: 33,
                            borderRadius: 22,
                            color: dialogPickerColor,
                            onSelectFocus: false,
                            onSelect: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // Store current color before we open the dialog.
                              final Color colorBeforeDialog = dialogPickerColor;
                              setState(() {
                                Global.card['color'] =
                                    dialogPickerColor.value.toString();
                              });
                              // then restore the color we had before it was opened.
                              if (!(await colorPickerDialog())) {
                                setState(() {
                                  dialogPickerColor = colorBeforeDialog;
                                  Global.card['color'] =
                                      dialogPickerColor.value.toString();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            cardData = {
                              'name': Global.card['name'],
                              'card_holder': Global.card['card_holder']
                                  .replaceAll(' ', '_'),
                              'card_number': Global.card['card_number'],
                              'expiration_date': Global.card['expiration_date'],
                              'cvv': Global.card['cvv'],
                              'notes': Global.card['notes'],
                              'color': dialogPickerColor.value.toString(),
                              'favorite': favorite,
                              // Example ARGB color as an integer
                            };
                            if (widget.data != null) {
                              await dbHelper.editCard(widget.data?['id'], cardData);
                            } else {
                              await dbHelper.insertCard(cardData);
                            }

                            toastification.show(
                              context: context,
                              style: ToastificationStyle.flat,
                              alignment: Alignment.bottomCenter,
                              showProgressBar: false,
                              title: const Text('Card saved'),
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          //backgroundColor: Color(0xFF3F7BD7),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
