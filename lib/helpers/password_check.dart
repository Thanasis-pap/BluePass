
import 'package:passwordmanager/global_dirs.dart';

/// Widget that will check password strength and display validation messages
class PasswordChecker extends StatefulWidget {
  const PasswordChecker({
    super.key,
    required this.password,
    required this.onStrengthChanged,
  });

  /// Password value: obtained from a text field
  final String password;

  /// Callback that will be called when password strength changes
  final Function(bool isStrong) onStrengthChanged;

  @override
  State<PasswordChecker> createState() =>
      _PasswordCheckerState();
}

class _PasswordCheckerState extends State<PasswordChecker> {
  /// Override didUpdateWidget to re-validate password strength when the value
  /// changes in the parent widget
  @override
  void didUpdateWidget(covariant PasswordChecker oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Check if the password value has changed
    if (widget.password != oldWidget.password) {
      /// If changed, re-validate the password strength
      final isStrong = _validators.entries.every(
            (entry) => entry.key.hasMatch(widget.password),
      );

      /// Call callback with new value to notify parent widget
      WidgetsBinding.instance.addPostFrameCallback(
            (_) => widget.onStrengthChanged(isStrong),
      );
    }
  }

  final Map<RegExp, String> _validators = {
    RegExp(r'[A-Z]'): 'One uppercase letter',
    RegExp(r'[a-z]'): 'One lowercase letter',
    RegExp(r'\d'): 'One number',
    RegExp(r'[!@#$%^&*(),.?":{}|<>]'): 'One special character',
    RegExp(r'^.{12,32}$'): '12-32 characters',
  };

  @override
  Widget build(BuildContext context) {
    /// If the password is empty yet, we'll show validation messages in plain
    /// color, not green or red
    final hasValue = widget.password.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _validators.entries.map(
            (entry) {
          final hasMatch = entry.key.hasMatch(widget.password);

          final color =
          hasValue ? (hasMatch ? Colors.green: Colors.grey) : Colors.grey;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              entry.value,
              style: TextStyle(color: color),
            ),
          );
        },
      ).toList(),
    );
  }
}