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

 
 ///  📅 Date picker
  static const String maleicon = '''
<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M32.7203 3.45458L32.7203 3.46381C32.7203 5.37197 34.2664 6.91795 36.1731 6.91795L28.8499 14.2412C28.5366 14.553 28.0531 14.6046 27.6777 14.3721C20.5446 9.96776 11.0278 10.9548 4.96776 17.336C-1.75035 24.4082 -1.63936 35.6404 5.20819 42.587C12.2936 49.7729 23.8641 49.8047 30.9878 42.6795C37.061 36.6076 37.9332 27.3062 33.6096 20.3039C33.377 19.9287 33.4285 19.4437 33.7404 19.1318L41.0637 11.8085C41.0637 12.7625 41.4509 13.6254 42.0746 14.2505C42.7009 14.8742 43.5638 15.2614 44.5178 15.2614L44.5271 15.2614C46.4338 15.2614 47.9812 13.7153 47.9812 11.8085L47.9812 2.10403C47.9812 0.942528 47.039 0.000297588 45.8775 0.000297638L36.173 0.000298063C34.2664 0.000427846 32.7203 1.54654 32.7203 3.45458ZM30.1527 29.8368C30.1527 36.4678 24.7772 41.8446 18.145 41.8446C11.5127 41.8446 6.13722 36.4678 6.13722 29.8368C6.13722 23.2046 11.5127 17.8278 18.145 17.8278C24.7772 17.8278 30.1527 23.2046 30.1527 29.8368Z" fill="#2ED1E2"/>
<path d="M29.6586 15.2686C30.0109 15.4988 30.476 15.4518 30.7751 15.156C31.2679 14.669 31.7607 14.1821 32.2535 13.6952C33.239 12.7213 34.224 11.7468 35.2101 10.7733C35.9302 10.0624 36.6491 9.35151 37.3679 8.64189C38.5479 7.47513 38.9444 6.12766 37.5067 5.09559C37.1149 4.81441 36.6371 4.63934 36.2883 4.29934C35.4287 3.46182 36.3112 2.04681 37.3984 2.03617L47.9804 2.03617C47.9448 0.906319 47.017 0.00125918 45.8781 0.00125923L36.1749 0.00125966C34.2672 0.00125974 32.7207 1.54776 32.7207 3.45541L32.7207 3.46463C32.7207 5.3728 34.2668 6.91879 36.1736 6.91879L28.8503 14.2421C28.7354 14.3565 28.5973 14.436 28.4502 14.4792L29.6586 15.2686Z" fill="#2ED1E2"/>
</svg>


''';


  static const String femaleicon = '''
<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M39.2589 15.3472C39.2589 6.87049 32.3888 0 23.9163 0C15.4402 0 8.57129 6.8706 8.57129 15.3472C8.57129 22.8229 13.9165 29.0471 20.9936 30.4129V34.9281H18.6431C17.0314 34.9281 15.7228 36.2357 15.7228 37.8475C15.7228 39.4628 17.0314 40.7703 18.6431 40.7703H20.9936V45.0796C20.9936 46.6914 22.3023 48 23.9162 48C24.7204 48 25.4525 47.6739 25.982 47.1455C26.5105 46.617 26.8353 45.886 26.8353 45.0796V40.7703H29.186C30.8012 40.7703 32.1086 39.4628 32.1086 37.8475C32.1086 36.2357 30.8012 34.9281 29.186 34.9281H26.8353V30.4129C33.9136 29.0471 39.2589 22.8229 39.2589 15.3472ZM23.9162 25.295C18.4211 25.295 13.9692 20.8392 13.9692 15.3472C13.9692 9.85163 18.4212 5.39711 23.9162 5.39711C29.4079 5.39711 33.8633 9.85163 33.8633 15.3472C33.8633 20.8392 29.4079 25.295 23.9162 25.295Z" fill="#FE93BB"/>
<path d="M24.9635 40.7715H26.8366V45.0793C26.8366 45.8865 26.5098 46.6164 25.981 47.1453C25.4521 47.6741 24.7212 48.0009 23.9152 48.0009C23.8884 48.0009 23.8617 48.0009 23.835 47.9989C24.1667 47.7002 24.5181 47.4077 24.6778 46.9763C24.812 46.6137 24.7566 46.2011 24.7566 45.8231V41.3176C24.7566 41.0159 24.662 40.7715 24.9635 40.7715Z" fill="#FE93BB"/>
<path d="M32.1068 37.9316C32.0629 39.5227 30.7173 40.7705 29.1257 40.7705H28.0893C29.2221 40.7705 30.0955 39.6939 29.9749 38.5886C29.8994 37.8962 29.6432 37.3864 29.0087 37.072C28.4296 36.7851 27.7983 36.6825 27.1564 36.6825C27.152 36.6825 25.3048 36.6825 25.3048 36.6825C25.0033 36.6825 24.7588 36.4381 24.7588 36.1364V31.7712C24.7588 31.3011 25.0804 30.8938 25.5367 30.7807C25.9614 30.6754 26.4268 30.5522 26.8364 30.4121V34.9272H29.1865C30.8272 34.9273 32.1524 36.2805 32.1068 37.9316Z" fill="#FE93BB"/>
<path d="M39.2601 15.3458C39.2601 22.0694 34.9365 27.781 28.9184 29.8548C32.4532 27.511 36.2531 24.0855 36.6812 17.1275C37.2017 8.66793 32.6138 3.47907 24.216 1.9419C22.7251 1.66897 19.0765 1.40725 17.127 1.57866C19.1739 0.568491 21.4783 0 23.9154 0C32.3903 0 39.2601 6.87016 39.2601 15.3458Z" fill="#FE93BB"/>
</svg>
 

''';


 static const String union = '''

<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M18.8457 11.7793H31.4102V18.8457H18.8457V31.4102H11.7793V18.8457H0V11.7793H11.7793V0H18.8457V11.7793Z" fill="#0E6A74"/>
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
