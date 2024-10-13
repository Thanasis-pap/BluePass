import 'package:passwordmanager/global_dirs.dart';

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
    await dbDataHelper.exportDatabaseToCSV();

    String newKey = _keyStorage.generateAESKey();
    await dbHelper.reEncryptAllUserData(newKey);
    await dbDataHelper.reencryptPasswords(newKey);
    await dbDataHelper.reencryptCards(newKey);
    await _keyStorage.storeKey(newKey);
    Navigator.pop(context);
    Navigator.pop(context);
    toastification.show(
      context: context,
      style: ToastificationStyle.flat,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
      title: const Text('Database saved successfully'),
      autoCloseDuration: const Duration(seconds: 2),
    );
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
              "You are about to see your encryption key. After you press \"Export Data\" your data in this device will re-encrypt with a new encryption key. \n\n"
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
                prefixIcon: const Icon(Icons.lock_rounded),
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
            onPressed: isButtonEnabled ? null : enabledCancel,
            child: Text('Cancel',
                style: TextStyle(
                    fontSize: 18,
                    color: isButtonEnabled
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary)),
          ),
          ElevatedButton(
            onPressed: isButtonEnabled ? _onKeyPressed : null,
            child: Text('Export Data',
                style: TextStyle(
                    fontSize: 18,
                    color: isButtonEnabled ? Colors.red : Colors.grey)),
          ),
        ],
      ),
    );
  }
}
