import 'package:passwordmanager/global_dirs.dart';

class Categories {

  final dbHelper = DatabaseHelper();



  static List<Widget> searchFunction(BuildContext context) {
    return [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: Text(
        'Search',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const SizedBox(height: 20),

    ];
  }
}