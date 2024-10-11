import 'package:passwordmanager/global_dirs.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditName();
}

class _EditName extends State<EditName> {
  String name = '';
  final formKey = GlobalKey<FormState>();
  final dbHelper = UserDatabaseHelper();
  final nameController = TextEditingController();

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final user = await dbHelper.loginName(Global.username);
      print(user);
      Global.name = name;
      int result =
          await dbHelper.editUser(user['id'], name, null, null);
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Username changed'),
        autoCloseDuration: const Duration(milliseconds: 1500),
      );
      Navigator.pop(context);
        }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = Global.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: const Text('Change Username', style: TextStyle(fontSize: (28))),
        // Show delete button if any card is selected
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    maxLength: 20,
                    controller: nameController,
                    decoration: InputDecoration(
                      label: const Text('Name'),
                      filled: true,
                      prefixIcon: const Icon(Icons.perm_identity_rounded),
                      //fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSaved: (value) => name = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveChanges,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
