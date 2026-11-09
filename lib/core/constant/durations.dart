// core/constant/durations.dart

/// Animation durations used across the app. Values match the literals they
/// replaced so motion is unchanged.
class AppDurations {
  AppDurations._();

  /// 200ms - text style / colour / opacity changes.
  static const fast = Duration(milliseconds: 200);

  /// 220ms - AnimatedSwitcher label and value swaps.
  static const normal = Duration(milliseconds: 220);

  /// 250ms - fade/scale page transition.
  static const medium = Duration(milliseconds: 250);

  /// 280ms - sliding glass indicators.
  static const slide = Duration(milliseconds: 280);

  /// 300ms - slide page transition, progress bar fill.
  static const slow = Duration(milliseconds: 300);

  /// 400ms - fade-through page transition, bottom bar tab change.
  static const slower = Duration(milliseconds: 400);
}
