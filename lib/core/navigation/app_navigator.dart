import 'package:flutter/material.dart';

/// Transition types available for page navigation
enum PageTransitionType {
  slideFromRight, // Standard horizontal slide (default)
  slideFromBottom, // Sheet-style slide up
  fade, // Simple opacity fade
  slideWithFade, // Slide + fade combined
}

/// Custom [PageRouteBuilder] that applies the chosen transition.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final PageTransitionType transition;

  AppPageRoute({
    required this.page,
    this.transition = PageTransitionType.slideFromRight,
    super.settings,
  }) : super(
         transitionDuration: const Duration(milliseconds: 300),
         reverseTransitionDuration: const Duration(milliseconds: 250),
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final curved = CurvedAnimation(
             parent: animation,
             curve: Curves.easeInOut,
           );

           switch (transition) {
             case PageTransitionType.slideFromRight:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(1.0, 0.0),
                   end: Offset.zero,
                 ).animate(curved),
                 child: child,
               );

             case PageTransitionType.slideFromBottom:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(0.0, 1.0),
                   end: Offset.zero,
                 ).animate(curved),
                 child: child,
               );

             case PageTransitionType.fade:
               return FadeTransition(
                 opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                 child: child,
               );

             case PageTransitionType.slideWithFade:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(0.0, 0.06),
                   end: Offset.zero,
                 ).animate(curved),
                 child: FadeTransition(
                   opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                   child: child,
                 ),
               );
           }
         },
       );
}

/// Helper class with static methods for clean navigation calls.
class AppNavigator {
  AppNavigator._();

  /// Push a new page onto the stack.
  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    PageTransitionType transition = PageTransitionType.slideFromRight,
  }) {
    return Navigator.of(
      context,
    ).push<T>(AppPageRoute<T>(page: page, transition: transition));
  }

  /// Replace the current page with a new one.
  static Future<T?> pushReplacement<T>(
    BuildContext context,
    Widget page, {
    PageTransitionType transition = PageTransitionType.slideFromRight,
  }) {
    return Navigator.of(context).pushReplacement<T, dynamic>(
      AppPageRoute<T>(page: page, transition: transition),
    );
  }

  /// Clear the entire stack and push a new page (e.g. after login).
  static Future<T?> pushAndClearStack<T>(
    BuildContext context,
    Widget page, {
    PageTransitionType transition = PageTransitionType.fade,
  }) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      AppPageRoute<T>(page: page, transition: transition),
      (route) => false,
    );
  }

  /// Pop the current page.
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }
}
