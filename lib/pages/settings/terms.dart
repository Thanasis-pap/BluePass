import 'package:passwordmanager/global_dirs.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _Terms();
}

class _Terms extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Last updated: 15/10/2024\n"),
              const Text(
                  'Welcome to our Password Manager application BluePass. By downloading, installing, or using the App, you agree to the following Terms and Conditions (“Terms”). If you do not agree with these Terms, please do not use the App.\n'),
              const Text('1. General Information\n'),
              const Text(
                  'The Password Manager app is designed for personal use to store and manage passwords and other sensitive data securely. The App operates entirely offline, and no user data is collected, transmitted, or stored by us (the developers). All data is stored locally on your device, and you are solely responsible for securing and maintaining access to it.\n'),
              const Text('2. Data Collection\n'),
              const Text(
                  'We do not collect, store, or have access to any data entered into the App. All data, including passwords, personal information, or other sensitive data, is stored solely on the user’s device. There is no synchronization of data with any server, cloud, or external systems.\n'),
              const Text('3. User Responsibility\n'),
              const Text(
                  'As the user, you are solely responsible for: \nKeeping your device secure. \nSafeguarding your data stored in the App. \nEnsuring that any encryption keys or passwords you use to secure the App are not lost or shared. Losing this information could result in the permanent loss of access to your stored data. \n'),
              const Text('4. Security\n'),
              const Text(
                  'Although the App is designed with security in mind, including the use of encryption for sensitive data, the security of your data depends on how you use the App and how you protect your device. The developers are not responsible for any data loss, breaches, or unauthorized access caused by third-party actions, device vulnerabilities, or user negligence. \n'),
              const Text('5. Disclaimer\n'),
              const Text(
                  'The App is provided \"as is\" without warranties of any kind, whether express or implied, including but not limited to implied warranties of merchantability, fitness for a particular purpose, or non-infringement. We do not guarantee that the App will be error-free, secure, or available at all times.'),
              const Text(
                  'Since the App operates offline, the developers cannot be held liable for any data loss, device issues, or damages caused by the use of the App. Users are encouraged to maintain backups and follow best practices for data security.\n'),
              const Text('6. Limitations of Liability\n'),
              const Text(
                  'To the fullest extent permitted by applicable law, in no event will the developers or creators of the App be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of data, loss of profits, or any damages arising from the use or inability to use the App.\n'),
              const Text('7. Modifications to Terms\n'),
              const Text(
                  'We reserve the right to modify or update these Terms at any time. Any changes will be effective immediately upon updating the Terms within the App or on our website. It is your responsibility to review these Terms regularly to ensure your continued compliance.\n'),
              const Text('8. Governing Law\n'),
              const Text(
                  'These Terms are governed by and construed in accordance with the laws of Greece, without regard to its conflict of law provisions. By using the App, you agree to submit to the exclusive jurisdiction of the courts located in Greece for the resolution of any disputes.\n'),
              const Text('9. Contact Us\n'),
              const Text(
                  'If you have any questions or concerns about these Terms, please contact us at bluepass.contact@gmail.com.\n'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
