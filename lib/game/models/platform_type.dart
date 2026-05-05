import 'package:flutter/material.dart';

enum PlatformType { normal, boost, fragile, moving, dangerous }

extension PlatformTypeX on PlatformType {
  Color get color {
    switch (this) {
      case PlatformType.normal:
        return const Color(0xFF38C172);
      case PlatformType.boost:
        return const Color(0xFFFFC857);
      case PlatformType.fragile:
        return const Color(0xFF7DD3FC);
      case PlatformType.moving:
        return const Color(0xFF8B5CF6);
      case PlatformType.dangerous:
        return const Color(0xFFFF4D6D);
    }
  }

  String get label {
    switch (this) {
      case PlatformType.normal:
        return 'Normal';
      case PlatformType.boost:
        return 'Boost';
      case PlatformType.fragile:
        return 'Fragile';
      case PlatformType.moving:
        return 'Mobile';
      case PlatformType.dangerous:
        return 'Danger';
    }
  }

  double get bounceVelocity {
    switch (this) {
      case PlatformType.boost:
        return 980;
      case PlatformType.normal:
      case PlatformType.fragile:
      case PlatformType.moving:
        return 780;
      case PlatformType.dangerous:
        return 0;
    }
  }
}
