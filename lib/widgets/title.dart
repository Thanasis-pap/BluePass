import 'package:passwordmanager/global_dirs.dart';

class Heading {
  static Widget title(BuildContext context,String text) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}