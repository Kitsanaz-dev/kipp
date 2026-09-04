// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseRepositoryHash() => r'b920689a693bd9e3b0f4a54426d9203b40e56496';

/// See also [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider =
    AutoDisposeProvider<ExpenseRepository>.internal(
  expenseRepository,
  name: r'expenseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepository>;
String _$expensesByDayTypeHash() => r'f7f592a757e8a8c64b6e47c9772dd1c6bc127c7c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
///
/// Copied from [expensesByDayType].
@ProviderFor(expensesByDayType)
const expensesByDayTypeProvider = ExpensesByDayTypeFamily();

/// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
///
/// Copied from [expensesByDayType].
class ExpensesByDayTypeFamily extends Family<List<ExpenseEntity>> {
  /// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
  ///
  /// Copied from [expensesByDayType].
  const ExpensesByDayTypeFamily();

  /// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
  ///
  /// Copied from [expensesByDayType].
  ExpensesByDayTypeProvider call(
    int dayType,
  ) {
    return ExpensesByDayTypeProvider(
      dayType,
    );
  }

  @override
  ExpensesByDayTypeProvider getProviderOverride(
    covariant ExpensesByDayTypeProvider provider,
  ) {
    return call(
      provider.dayType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesByDayTypeProvider';
}

/// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
///
/// Copied from [expensesByDayType].
class ExpensesByDayTypeProvider
    extends AutoDisposeProvider<List<ExpenseEntity>> {
  /// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
  ///
  /// Copied from [expensesByDayType].
  ExpensesByDayTypeProvider(
    int dayType,
  ) : this._internal(
          (ref) => expensesByDayType(
            ref as ExpensesByDayTypeRef,
            dayType,
          ),
          from: expensesByDayTypeProvider,
          name: r'expensesByDayTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expensesByDayTypeHash,
          dependencies: ExpensesByDayTypeFamily._dependencies,
          allTransitiveDependencies:
              ExpensesByDayTypeFamily._allTransitiveDependencies,
          dayType: dayType,
        );

  ExpensesByDayTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dayType,
  }) : super.internal();

  final int dayType;

  @override
  Override overrideWith(
    List<ExpenseEntity> Function(ExpensesByDayTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesByDayTypeProvider._internal(
        (ref) => create(ref as ExpensesByDayTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dayType: dayType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ExpenseEntity>> createElement() {
    return _ExpensesByDayTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByDayTypeProvider && other.dayType == dayType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dayType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExpensesByDayTypeRef on AutoDisposeProviderRef<List<ExpenseEntity>> {
  /// The parameter `dayType` of this provider.
  int get dayType;
}

class _ExpensesByDayTypeProviderElement
    extends AutoDisposeProviderElement<List<ExpenseEntity>>
    with ExpensesByDayTypeRef {
  _ExpensesByDayTypeProviderElement(super.provider);

  @override
  int get dayType => (origin as ExpensesByDayTypeProvider).dayType;
}

String _$expenseSummaryHash() => r'4636e43057429c2fe637347d1531ae420d4cb5c3';

/// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
///
/// Copied from [expenseSummary].
@ProviderFor(expenseSummary)
const expenseSummaryProvider = ExpenseSummaryFamily();

/// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
///
/// Copied from [expenseSummary].
class ExpenseSummaryFamily extends Family<({double income, double expense})> {
  /// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
  ///
  /// Copied from [expenseSummary].
  const ExpenseSummaryFamily();

  /// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
  ///
  /// Copied from [expenseSummary].
  ExpenseSummaryProvider call(
    int dayType,
  ) {
    return ExpenseSummaryProvider(
      dayType,
    );
  }

  @override
  ExpenseSummaryProvider getProviderOverride(
    covariant ExpenseSummaryProvider provider,
  ) {
    return call(
      provider.dayType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expenseSummaryProvider';
}

/// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
///
/// Copied from [expenseSummary].
class ExpenseSummaryProvider
    extends AutoDisposeProvider<({double income, double expense})> {
  /// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
  ///
  /// Copied from [expenseSummary].
  ExpenseSummaryProvider(
    int dayType,
  ) : this._internal(
          (ref) => expenseSummary(
            ref as ExpenseSummaryRef,
            dayType,
          ),
          from: expenseSummaryProvider,
          name: r'expenseSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expenseSummaryHash,
          dependencies: ExpenseSummaryFamily._dependencies,
          allTransitiveDependencies:
              ExpenseSummaryFamily._allTransitiveDependencies,
          dayType: dayType,
        );

  ExpenseSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dayType,
  }) : super.internal();

  final int dayType;

  @override
  Override overrideWith(
    ({double income, double expense}) Function(ExpenseSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseSummaryProvider._internal(
        (ref) => create(ref as ExpenseSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dayType: dayType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<({double income, double expense})>
      createElement() {
    return _ExpenseSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseSummaryProvider && other.dayType == dayType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dayType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExpenseSummaryRef
    on AutoDisposeProviderRef<({double income, double expense})> {
  /// The parameter `dayType` of this provider.
  int get dayType;
}

class _ExpenseSummaryProviderElement
    extends AutoDisposeProviderElement<({double income, double expense})>
    with ExpenseSummaryRef {
  _ExpenseSummaryProviderElement(super.provider);

  @override
  int get dayType => (origin as ExpenseSummaryProvider).dayType;
}

String _$dailyChartDataHash() => r'd03edda00f4ac00ae453944a8a86aa1b1e838933';

/// ຄິດໄລ່ chart data 14 ວັນລ່າສຸດ ຈາກ transaction ຈິງ
///
/// Copied from [dailyChartData].
@ProviderFor(dailyChartData)
final dailyChartDataProvider =
    AutoDisposeProvider<List<DailyChartData>>.internal(
  dailyChartData,
  name: r'dailyChartDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyChartDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DailyChartDataRef = AutoDisposeProviderRef<List<DailyChartData>>;
String _$expenseTotalsHash() => r'b4536a6e7deae6ff8646671d81a982f7c99f77d4';

/// ຍອດລວມ income/expense ທັງໝົດ (all-time) - ໃຊ້ໃນ ExpenseScreen
///
/// Copied from [expenseTotals].
@ProviderFor(expenseTotals)
final expenseTotalsProvider =
    AutoDisposeProvider<({double totalIncome, double totalExpense})>.internal(
  expenseTotals,
  name: r'expenseTotalsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseTotalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpenseTotalsRef
    = AutoDisposeProviderRef<({double totalIncome, double totalExpense})>;
String _$expenseListHash() => r'91161f3e9ec44567075f0a5e2c169382a41ed2db';

/// List ຂອງ transaction ທັງໝົດ - single source of truth
///
/// Copied from [ExpenseList].
@ProviderFor(ExpenseList)
final expenseListProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseList, List<ExpenseEntity>>.internal(
  ExpenseList.new,
  name: r'expenseListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$expenseListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseList = AutoDisposeAsyncNotifier<List<ExpenseEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
