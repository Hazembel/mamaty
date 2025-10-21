// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mamatyp';

  @override
  String get hello => 'Bonjour';

  @override
  String get submitForm => 'Valider le formulaire';

  @override
  String get name => 'Nom';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer mot de passe';

  @override
  String get birthday => 'Date de naissance';

  @override
  String get formValidSnack => 'Formulaire valide 🎉';
}
