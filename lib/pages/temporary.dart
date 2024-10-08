import 'package:passwordmanager/global_dirs.dart';

class Temporary extends StatefulWidget {
  const Temporary({super.key});

  @override
  State<Temporary> createState() => _Temporary();
}

class _Temporary extends State<Temporary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.construction_rounded,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                'Not ready yet.',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
