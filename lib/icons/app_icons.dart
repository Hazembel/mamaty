// 📁 lib/icons/app_icons.dart

// Import Flutter’s base widget library.
import 'package:flutter/widgets.dart';

// Import flutter_svg — a package that lets us render SVG code directly in Flutter.
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

/// 🔷 AppIcons
/// This class holds all SVG icons as static constants (so we can reuse them everywhere)
/// and provides a helper method to render them as Flutter widgets.
class AppIcons {
  // ======================================================
  // 🟢 1. SVG ICONS AS STRINGS
  // ======================================================
  // Each icon is stored as a raw SVG string (copy-pasted from your SVG file).
  // Later, we’ll use the helper `AppIcons.svg()` to render it visually.

  // === 👁️ Show Password icon ===
  static const String showPassword = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- 👇 This is the iris/pupil of the eye -->
  <path d="M15.5799 11.9999C15.5799 13.9799 13.9799 15.5799 11.9999 15.5799C10.0199 15.5799 8.41992 13.9799 8.41992 11.9999C8.41992 10.0199 10.0199 8.41992 11.9999 8.41992C13.9799 8.41992 15.5799 10.0199 15.5799 11.9999Z"
        stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  
  <!-- 👇 This is the outline of the eye -->
  <path d="M12.0001 20.2707C15.5301 20.2707 18.8201 18.1907 21.1101 14.5907C22.0101 13.1807 22.0101 10.8107 21.1101 9.4007C18.8201 5.8007 15.5301 3.7207 12.0001 3.7207C8.47009 3.7207 5.18009 5.8007 2.89009 9.4007C1.99009 10.8107 1.99009 13.1807 2.89009 14.5907C5.18009 18.1907 8.47009 20.2707 12.0001 20.2707Z"
        stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';





  // === 🙈 Hide Password icon ===
  static const String hidePassword = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- 👇 Eye half-closed (iris hidden) -->
  <path d="M14.5299 9.46992L9.46992 14.5299C8.81992 13.8799 8.41992 12.9899 8.41992 11.9999C8.41992 10.0199 10.0199 8.41992 11.9999 8.41992C12.9899 8.41992 13.8799 8.81992 14.5299 9.46992Z"
        stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  
  <!-- 👇 The curved line representing the top of the eye -->
  <path d="M17.8201 5.77047C16.0701 4.45047 14.0701 3.73047 12.0001 3.73047C8.47009 3.73047 5.18009 5.81047 2.89009 9.41047C1.99009 10.8205 1.99009 13.1905 2.89009 14.6005C3.68009 15.8405 4.60009 16.9105 5.60009 17.7705"
        stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  
  <!-- 👇 Bottom curve of the eye -->
  <path d="M8.41992 19.5297C9.55992 20.0097 10.7699 20.2697 11.9999 20.2697C15.5299 20.2697 18.8199 18.1897 21.1099 14.5897C22.0099 13.1797 22.0099 10.8097 21.1099 9.39969C20.7799 8.87969 20.4199 8.38969 20.0499 7.92969"
        stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>

  <!-- 👇 The small line showing eye partially closed -->
  <path d="M15.5099 12.6992C15.2499 14.1092 14.0999 15.2592 12.6899 15.5192"
        stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>

  <!-- 👇 Slash across the eye (hide indicator) -->
  <path d="M9.47 14.5293L2 21.9993" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M22 2L14.53 9.47" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';


 /// 🔙 Back icon
  static const String back = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14.9998 19.9201L8.47984 13.4001C7.70984 12.6301 7.70984 11.3701 8.47984 10.6001L14.9998 4.08008" stroke="#111214" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';


 ///  📅 Date picker
  static const String datepicker = '''
<svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8.90918 2V5" stroke="#111214" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.90918 2V5" stroke="black" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M16.9092 2V5" stroke="#111214" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M16.9092 2V5" stroke="black" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M21.9092 8.5V17C21.9092 20 20.4092 22 16.9092 22H8.90918C5.40918 22 3.90918 20 3.90918 17V8.5C3.90918 5.5 5.40918 3.5 8.90918 3.5H16.9092C20.4092 3.5 21.9092 5.5 21.9092 8.5Z" stroke="#111214" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M21.9092 8.5V17C21.9092 20 20.4092 22 16.9092 22H8.90918C5.40918 22 3.90918 20 3.90918 17V8.5C3.90918 5.5 5.40918 3.5 8.90918 3.5H16.9092C20.4092 3.5 21.9092 5.5 21.9092 8.5Z" stroke="black" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.90918 11H16.9092" stroke="#111214" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.90918 11H16.9092" stroke="black" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.90918 16H12.9092" stroke="#111214" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.90918 16H12.9092" stroke="black" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

''';

 












  // ======================================================
  // 🟢 2. HELPER FUNCTION TO DISPLAY THE ICON
  // ======================================================
  // We made the icons above as plain text (SVG strings).
  // Now we need a method to convert that string into a visible Widget.

  /// Renders any SVG string as a Flutter widget.
  ///
  /// Parameters:
  /// - [svgString]: the icon code to render
  /// - [size]: how big the icon should appear
  /// - [color]: changes stroke color using `currentColor`
  /// - [fit]: how the SVG fits inside its box
  static Widget svg(
    String svgString, {
    double size = 24,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    // If we pass a color, it replaces "currentColor" in the SVG.
    final colorFilter =
        color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null;

    // SvgPicture.string() takes the SVG code and draws it.
    return SvgPicture.string(
      svgString,
      width: size, // width of the icon
      height: size, // height of the icon
      fit: fit, // how it fits inside its box
      colorFilter: colorFilter, // apply color if provided
    );
  }
}
