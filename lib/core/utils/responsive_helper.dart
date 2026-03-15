import 'package:get/get.dart';

class ResponsiveHelper {
  // GetX provides context-less width and height
  static double get width => Get.width;
  static double get height => Get.height;

  // Percentage based sizing
  static double w(double percent) => width * (percent / 100);
  static double h(double percent) => height * (percent / 100);

  // Tablet detection
  static bool get isTablet => width >= 600;
  static bool get isDesktop => width >= 1200;
  static bool get isMobile => width < 600;

  // Font scaling helper (simple implementation)
  static double get fontScale => isTablet ? 1.2 : 1.0;
}
