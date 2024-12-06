import 'package:flutter/material.dart';

class CustomAdaptiveLayout extends StatelessWidget {
  const CustomAdaptiveLayout({
    super.key,
    required this.desktopLayout,
    required this.mobileLayout,
    required this.tabletLayout,
  });

  final Widget Function(BuildContext context,) mobileLayout;
  final Widget Function(BuildContext context, [BoxConstraints ?constraints]) tabletLayout;
  final Widget Function(BuildContext context, [BoxConstraints? constraints]) desktopLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileLayout(context,);
        } else if (constraints.maxWidth < 1025) {
          return tabletLayout(context,constraints);
        } else {
          return desktopLayout(context,constraints);
        }
      },
    );
  }
}
