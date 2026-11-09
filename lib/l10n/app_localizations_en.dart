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
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

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
  String get deleteSuccess => 'Deleted successfully';

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

  @override
  String get emailAlreadyRegistered => 'This email is already registered';

  @override
  String get incorrectEmailOrPassword => 'Incorrect email or password';

  @override
  String get somethingWentWrong => 'Something went wrong, please try again';

  @override
  String get networkError => 'Could not connect to the server. Please check your internet connection.';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get getStarted => 'Get Started';

  @override
  String get startSubtitle => 'Manage your income and expenses with ease\nControl your finances in one hand';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get atLeastSixCharacters => 'At least 6 characters';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get nameMinLength => 'Name must be at least 2 characters';

  @override
  String get reenterYourPassword => 'Re-enter your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get selectTypeTitle => 'Select Type...';

  @override
  String get date => 'Date';

  @override
  String get delete => 'Delete';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get periodDetails => 'Period details';

  @override
  String get seeDetails => 'See details';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String get byCategory => 'By category';

  @override
  String get topExpenses => 'Top expenses';

  @override
  String get netBalance => 'Net balance';

  @override
  String get selectMonth => 'Select month';

  @override
  String get selectYear => 'Select year';

  @override
  String get thisMonthShortcut => 'This month';

  @override
  String get jumpToToday => 'Today';

  @override
  String get noTransactionsThisMonth => 'No transactions in this month';

  @override
  String get dayIncome => 'Day income';

  @override
  String get dayExpense => 'Day expense';

  @override
  String get scanUnavailable => 'Receipt scanning is currently unavailable. Please try again later.';

  @override
  String get scanTimeout => 'Receipt scanning timed out. Please try again.';

  @override
  String get scanRateLimited => 'Too many scans. Please wait and try again.';
}
