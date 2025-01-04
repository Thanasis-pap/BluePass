import '../../global_dirs.dart';

class SecurityQuestions extends StatefulWidget {
  @override
  _SecurityQuestions createState() => _SecurityQuestions();
}

class _SecurityQuestions extends State<SecurityQuestions> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _answerControllers =
      List.generate(3, (index) => TextEditingController());

  final List<String> _allSecurityQuestions = [
    'What was your childhood nickname?',
    'What is the name of your first pet?',
    'What was the name of your first school?',
    'What is your favorite food?',
    'What is your mother’s surname?',
    'What is your favorite movie?',
    'What is the name of the town where you were born?',
    'What was your first car?',
    'What is your father’s name?',
    'What is the name of your favorite teacher?',
    'What is your favorite sports team?',
    'What is your favorite song?'
  ];

  List<String?> selectedQuestions = [null, null, null];

  List<String> getSelectedQuestions() {
    // Return a list of non-null selected questions
    return selectedQuestions
        .where((question) => question != null)
        .cast<String>()
        .toList();
  }

  List<String> getAvailableQuestions(int index) {
    // Get the list of available questions that haven't been selected in other dropdowns
    return _allSecurityQuestions.where((question) {
      return !selectedQuestions.contains(question) ||
          selectedQuestions[index] == question;
    }).toList();
  }

  Future<void> saveQuestions() async {
    if (_formKey.currentState!.validate()) {
      // Save selected security questions and answers
      List<Map<String, dynamic>> questions = [];
      for (int i = 0; i < selectedQuestions.length; i++) {
        if (selectedQuestions[i] != null) {
          questions.add({
            'question': selectedQuestions[i], // Example ID, adjust as necessary
            'answer': _answerControllers[i].text.trim()
          });
        }
      }
      await UserDatabaseHelper().saveSecurityQuestions(questions);

      // Show a success message or navigate to a different screen
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        showProgressBar: false,
        title: const Text('Saved Successfully'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.pop(context);
    }
  }

  Future<void> loadSecurityQuestions() async {
    List<Map<String, dynamic>> securityQuestions =
        await UserDatabaseHelper().getSecurityQuestions();

    if (securityQuestions.isNotEmpty) {
      // Assuming you have 3 questions saved
      for (int i = 0; i < 3; i++) {
        setState(() {
          print(i);
          selectedQuestions[i] =
              securityQuestions[i]['question']; // Retrieve the question text
          _answerControllers[i].text = securityQuestions[i]['answer'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadSecurityQuestions(); // Load the saved questions and answers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: const Text('Security Questions', style: TextStyle(fontSize: (28))),
        // Show delete button if any card is selected
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Select and answer 3 security questions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                for (int i = 0; i < 3; i++) ...[
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            icon: Icon(Icons.keyboard_arrow_down),
                            menuMaxHeight: 300,
                            value: selectedQuestions[i],
                            // The currently selected question
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedQuestions[i] =
                                    newValue; // Update the selected question
                              });
                            },
                            items: getAvailableQuestions(i)
                                .map<DropdownMenuItem<String>>(
                                    (String question) {
                              return DropdownMenuItem<String>(
                                value: question,
                                child: Text(question),
                              );
                            }).toList(),
                            hint: Text('Select a question'),
                            underline: SizedBox(),
                            isExpanded:
                                true, // To make the dropdown fill the available width
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _answerControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Answer ${i + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide an answer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveQuestions,
                  child: Text('Save'),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
