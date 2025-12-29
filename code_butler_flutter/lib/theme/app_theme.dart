import 'package:flutter/material.dart';

/// Application theme constants for consistent design
class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;

  static const EdgeInsets smallAll = EdgeInsets.all(small);
  static const EdgeInsets mediumAll = EdgeInsets.all(medium);
  static const EdgeInsets largeAll = EdgeInsets.all(large);
  static const EdgeInsets xlargeAll = EdgeInsets.all(xlarge);

  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: small);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: medium);
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: large);

  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: small);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: medium);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: large);
}

class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 24.0;

  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumAll = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));
  static const BorderRadius xlargeAll = BorderRadius.all(Radius.circular(xlarge));
}

class AppElevation {
  static const double low = 2.0;
  static const double medium = 4.0;
  static const double high = 8.0;
}

class AppTextStyles {
  static TextStyle heading1(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge ?? const TextStyle();
  }

  static TextStyle heading2(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium ?? const TextStyle();
  }

  static TextStyle heading3(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium ?? const TextStyle();
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall ?? const TextStyle();
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall ?? const TextStyle();
  }
}

class AppIcons {
  static IconData agentType(String agentType) {
    switch (agentType.toLowerCase()) {
      case 'navigator':
        return Icons.map;
      case 'reader':
        return Icons.book;
      case 'security':
        return Icons.security;
      case 'performance':
        return Icons.speed;
      case 'documentation':
        return Icons.description;
      case 'verifier':
        return Icons.verified;
      default:
        return Icons.smart_toy;
    }
  }

  static IconData severity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.help_outline;
    }
  }
}

class AppColors {
  static Color critical(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.red.shade300
        : Colors.red.shade700;
  }

  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.orange.shade300
        : Colors.orange.shade700;
  }

  static Color info(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.blue.shade300
        : Colors.blue.shade700;
  }

  static Color success(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.green.shade300
        : Colors.green.shade700;
  }
}

