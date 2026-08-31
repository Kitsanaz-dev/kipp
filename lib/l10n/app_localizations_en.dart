// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSubtitle => 'Welcome back';

  @override
  String get signUp => 'Sign up';

  @override
  String get signUpSubtitle => 'Create an account to start tracking your finances';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an Account? ';

  @override
  String get alreadyHaveAccount => 'Already have an Account? ';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get welcomeUser => 'Welcome, User';

  @override
  String get todaysBalance => 'Today\'s balance';

  @override
  String get thisWeeksBalance => 'This week\'s balance';

  @override
  String get thisMonthsBalance => 'This month\'s balance';

  @override
  String get income => 'Income';

  @override
  String get expenses => 'Expenses';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get noTransactionsOnThisDay => 'No transactions on this day';

  @override
  String get home => 'Home';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get amount => 'Amount';

  @override
  String get type => 'Type';

  @override
  String get selectType => 'Select Type';

  @override
  String get description => 'Description';

  @override
  String get save => 'Save';

  @override
  String get savedSuccessfully => 'Saved successfully';

  @override
  String saveFailed(String error) {
    return 'Could not save: $error';
  }

  @override
  String get deleteSuccess => 'Delete Successfully';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than 0';

  @override
  String get pleaseSelectType => 'Please select a type';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get editProfileInfo => 'Edit Profile Info';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutConfirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get scanReceipt => 'Scan Receipt';

  @override
  String get cameraPermissionRequired => 'Camera permission is required to scan receipts';

  @override
  String amountFoundReview(String amount) {
    return 'Amount found: $amount - please review';
  }

  @override
  String get amountNotFoundManual => 'No amount detected automatically, please enter it manually';

  @override
  String get fetchData => 'Fetch Data successfully, Please review';

  @override
  String get fetchDataError => 'Cannot fetch data from pictures, please try again';
}
