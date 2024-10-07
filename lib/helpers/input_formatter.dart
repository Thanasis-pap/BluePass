import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // The new text entered by the user
    String text = newValue.text;

    // If the user deletes, let them delete freely
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Remove any non-numeric characters
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Insert '/' after the second digit
    if (text.length > 2) {
      text = '${text.substring(0, 2)} / ${text.substring(2)}';
    }

    // Update the cursor position after formatting
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(' ', ''); // Remove any existing spaces

    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    StringBuffer formattedText = StringBuffer();

    // Add a space every 4 digits
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) {
        formattedText.write(' ');
      }
      formattedText.write(text[i]);
    }

    // Return the formatted text with the correct cursor position
    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}