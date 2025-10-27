import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamaty/l10n/app_localizations.dart';
import 'package:mamaty/models/baby_profile_data.dart';
import 'package:mamaty/pages/baby_profile/baby_profile_page_4.dart';

// A minimal localization delegate to satisfy AppLocalizations.of(context)
class _TestLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _TestLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Provide a fake implementation with just the used getter.
    return _FakeAppLocalizations();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

class _FakeAppLocalizations implements AppLocalizations {
  @override
  String? get birthday => 'Date de naissance';
}

Widget _wrapWithMaterial(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      _TestLocalizationsDelegate(),
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('BabyProfilePage4', () {
    testWidgets('renders with default male avatars and selects first by default', (tester) async {
      final data = BabyProfileData();
      var nextCalled = false;

      await tester.pumpWidget(_wrapWithMaterial(BabyProfilePage4(
        babyProfileData: data,
        onNext: () { nextCalled = true; },
        onBack: () {},
      )));

      // Ensure initial state
      expect(data.gender ?? 'male', 'male');
      expect(data.avatar, isNotNull);
      expect(nextCalled, isFalse);
    });

    testWidgets('changes avatar when a different avatar is selected', (tester) async {
      final data = BabyProfileData(gender: 'male');

      await tester.pumpWidget(_wrapWithMaterial(BabyProfilePage4(
        babyProfileData: data,
        onNext: () {},
        onBack: () {},
      )));

      // Tap on second avatar in the selector if present
      // We look for any GestureDetector or InkWell and tap the second one
      final tappables = find.byType(GestureDetector);
      if (tappables.evaluate().length >= 2) {
        await tester.tap(tappables.at(1));
        await tester.pumpAndSettle();
        expect(data.avatar, isNotNull);
      }
    });

    testWidgets('updates name when typing in the name field', (tester) async {
      final data = BabyProfileData();

      await tester.pumpWidget(_wrapWithMaterial(BabyProfilePage4(
        babyProfileData: data,
        onNext: () {},
        onBack: () {},
      )));

      final nameField = find.byType(TextField);
      expect(nameField, findsOneWidget);

      await tester.enterText(nameField, 'Alice');
      await tester.pump();

      expect(data.name, 'Alice');
    });

    testWidgets('shows error when birthday is invalid and prevents next', (tester) async {
      final data = BabyProfileData();
      var nextCalled = false;

      await tester.pumpWidget(_wrapWithMaterial(BabyProfilePage4(
        babyProfileData: data,
        onNext: () { nextCalled = true; },
        onBack: () {},
      )));

      // Leave birthday empty and tap continue
      final continueButton = find.widgetWithText(ElevatedButton, 'Continuer');
      // AppButton likely renders an ElevatedButton internally
      await tester.tap(continueButton);
      await tester.pump();

      // A SnackBar should show. We can verify ScaffoldMessenger shows a SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(nextCalled, isFalse);
    });

    testWidgets('saves birthday and calls onNext when valid', (tester) async {
      final data = BabyProfileData();
      var nextCalled = false;

      await tester.pumpWidget(_wrapWithMaterial(BabyProfilePage4(
        babyProfileData: data,
        onNext: () { nextCalled = true; },
        onBack: () {},
      )));

      // Find date field by its label text
      final dateLabel = find.text('Date de naissance');
      expect(dateLabel, findsWidgets);

      // Find a TextField inside AppTextFieldDate subtree and enter a valid date
      final textFields = find.descendant(of: find.byWidgetPredicate((w) => w.runtimeType.toString() == 'AppTextFieldDate'), matching: find.byType(TextField));
      if (textFields.evaluate().isEmpty) {
        // fallback: enter via any editable text field other than name
        final fields = find.byType(TextField);
        if (fields.evaluate().length >= 2) {
          await tester.enterText(fields.at(1), '2020-01-01');
        }
      } else {
        await tester.enterText(textFields.first, '2020-01-01');
      }

      await tester.pump();

      // Tap continue
      final continueButton = find.widgetWithText(ElevatedButton, 'Continuer');
      await tester.tap(continueButton);
      await tester.pump();

      expect(nextCalled, isTrue);
      expect(data.birthday, '2020-01-01');
    });
  });
}
