import 'package:passwordmanager/global_dirs.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class EditPassword extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? data;

  const EditPassword({super.key, required this.title, required this.data});

  @override
  _EditPassword createState() => _EditPassword();
}

class _EditPassword extends State<EditPassword> {
  //List previousValues = Global.password;
  bool _favorite = false;
  bool passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final webpageController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final notesController = TextEditingController();

  final dbHelper = DatabaseHelper();

  Map<String, dynamic> passwordData = {
    'name': '',
    'webpage': '',
    'username': '',
    'password': '',
    'notes': '',
    'color': '',
    'favorite': false, // Example color
  };

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
        Global.password['color'] = color.value.toString();
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

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      dialogPickerColor = Color(int.parse(widget.data?['color']));
      passwordData = widget.data!;
      nameController.text = widget.data?['name'];
      webpageController.text = widget.data?['webpage'];
      usernameController.text = widget.data?['username'];
      passwordController.text = widget.data?['password'];
      notesController.text = widget.data?['notes'];
      dialogPickerColor = Color(int.parse(widget.data?['color']));
      _favorite = widget.data?['favorite'];
    }
    // Material red.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: IconButton(
              icon: Icon(
                  size: 30,
                  _favorite ? Icons.star_rounded : Icons.star_border_rounded),
              color: const Color(0xFF3F7BD7),
              onPressed: () {
                setState(() {
                  _favorite = !_favorite;
                });
                if (_favorite == true) {
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
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
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
                        'Name',
                        style: TextStyle(fontSize: 18),
                      ),
                      prefixIcon: const Icon(Icons.title_rounded),
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
                      Global.password['name'] = value;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: webpageController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      label: const Text(
                        'Webpage',
                        style: TextStyle(fontSize: 18),
                      ),
                      prefixIcon: const Icon(Icons.web_asset_rounded),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      Global.password['webpage'] = value;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: const Row(
                        children: [
                          Text(
                            'Username',
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
                        return 'Please enter a Username';
                      }
                      Global.password['username'] = value;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      label: const Row(
                        children: [
                          Text(
                            'Password',
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
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Password';
                      }
                      Global.password['password'] = value;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200, //     <-- TextField expands to this height.
                    child: TextFormField(
                      maxLines: 6,
                      // Set this
                      maxLength: 200,
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
                        Global.password['notes'] = value;
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
                          borderRadius:
                              BorderRadius.circular(20), // Border radius of 35
                        ),
                      ),
                      child: ListTile(
                        title: const Text(
                          'Color',
                          style: TextStyle(fontSize: 18),
                        ),
                        leading: Icon(Icons.colorize_rounded),
                        trailing: ColorIndicator(
                          width: 33,
                          height: 33,
                          borderRadius: 22,
                          color: dialogPickerColor,
                          onSelectFocus: false,
                          onSelect: () async {
                            // Store current color before we open the dialog.
                            final Color colorBeforeDialog = dialogPickerColor;
                            Global.password['color'] =
                                dialogPickerColor.value.toString();
                            // Wait for the picker to close, if dialog was dismissed,
                            // then restore the color we had before it was opened.
                            if (!(await colorPickerDialog())) {
                              setState(() {
                                dialogPickerColor = colorBeforeDialog;
                                Global.password['color'] =
                                    dialogPickerColor.value.toString();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          passwordData = {
                            'name': Global.password['name'],
                            'webpage':
                                Global.password['webpage'].replaceAll(' ', '_'),
                            'username': Global.password['username'],
                            'password': Global.password['password'],
                            'notes': Global.password['notes'],
                            'color': Global.password['color'],
                            'favorite': _favorite,
                            // Example ARGB color as an integer
                          };
                          if (widget.data != null) {
                            dbHelper.editPassword(
                                widget.data?['id'], passwordData);
                          } else {
                            dbHelper.insertPassword(passwordData);
                          }
                          toastification.show(
                            context: context,
                            style: ToastificationStyle.flat,
                            alignment: Alignment.bottomCenter,
                            showProgressBar: false,
                            title: const Text('Password saved'),
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
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
    );
  }
}
