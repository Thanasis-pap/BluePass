import '../global_dirs.dart';

class Recent {
  static void openCard(int cardId) {
    if (!Global.recentCards.contains(cardId)) {
      Global.recentCards.add(cardId);
      print(Global.recentCards);
      if (Global.recentCards.length > 5) {
        Global.recentCards.removeAt(0); // Keep the list at 5 recent cards
      }
    }
  }

  static void openPassword(int passwordId) {
    if (!Global.recentPasswords.contains(passwordId)) {
      Global.recentPasswords.add(passwordId);
      print(Global.recentPasswords);
      if (Global.recentPasswords.length > 5) {
        Global.recentPasswords.removeAt(0); // Keep the list at 5 recent passwords
      }
    }
  }
}
