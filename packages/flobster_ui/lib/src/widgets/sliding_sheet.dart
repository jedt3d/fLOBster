import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/glass_box.dart';

/// A right-aligned sliding sheet designed for quick record inspections.
/// Adapts dynamically: slides as a partial drawer on desktop/web, and full screen on mobile.
class RightSlidingSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const RightSlidingSheet({
    Key? key,
    required this.title,
    required this.child,
    this.actions,
  }) : super(key: key);

  /// Triggers the presentation of the sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget>? actions,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 768;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss sliding sheet',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: isMobile ? mediaQuery.size.width : 450.0,
              height: double.infinity,
              child: RightSlidingSheet(
                title: title,
                actions: actions,
                child: child,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      borderRadius: 0, // Fill the vertical edge cleanly
      child: SafeArea(
        left: false,
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: FlobsterColors.textPrimary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (actions != null) ...actions!,
                  IconButton(
                    icon: const Icon(Icons.close, color: FlobsterColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: FlobsterColors.borderGlass, height: 1),
            // Body Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
