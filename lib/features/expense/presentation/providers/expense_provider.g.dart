// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseRepositoryHash() => r'c9dd0bf427f8fe499487732a7c0aab51edb7c39f';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepository>;
String _$expensesByDayTypeHash() => r'fec4521bbbdb82cfcd6ca8156ac2621ed74538cf';

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

/// Filter ຕາມ PeriodFilter (Today / Week / Month) - derived ຈາກ expenseListProvider
///
/// Copied from [expensesByDayType].
@ProviderFor(expensesByDayType)
const expensesByDayTypeProvider = ExpensesByDayTypeFamily();

/// Filter ຕາມ PeriodFilter (Today / Week / Month) - derived ຈາກ expenseListProvider
///
/// Copied from [expensesByDayType].
class ExpensesByDayTypeFamily extends Family<List<ExpenseEntity>> {
  /// Filter ຕາມ PeriodFilter (Today / Week / Month) - derived ຈາກ expenseListProvider
  ///
  /// Copied from [expensesByDayType].
  const ExpensesByDayTypeFamily();

  /// Filter ຕາມ PeriodFilter (Today / Week / Month) - derived ຈາກ expenseListProvider
  ///
  /// Copied from [expensesByDayType].
  ExpensesByDayTypeProvider call(PeriodFilter filter) {
    return ExpensesByDayTypeProvider(filter);
  }

  @override
  ExpensesByDayTypeProvider getProviderOverride(
    covariant ExpensesByDayTypeProvider provider,
  ) {
    return call(provider.filter);
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

/// Filter ຕາມ PeriodFilter (Today / Week / Month) - derived ຈາກ expenseListProvider
///
/// Copied from [expensesByDayType].
class ExpensesByDayTypeProvider
    extends AutoDisposeProvider<List<ExpenseEntity>> {
  /// Filter ຕາມ PeriodFilter (Today / Week / Month) - derived ຈາກ expenseListProvider
  ///
  /// Copied from [expensesByDayType].
  ExpensesByDayTypeProvider(PeriodFilter filter)
    : this._internal(
        (ref) => expensesByDayType(ref as ExpensesByDayTypeRef, filter),
        from: expensesByDayTypeProvider,
        name: r'expensesByDayTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$expensesByDayTypeHash,
        dependencies: ExpensesByDayTypeFamily._dependencies,
        allTransitiveDependencies:
            ExpensesByDayTypeFamily._allTransitiveDependencies,
        filter: filter,
      );

  ExpensesByDayTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final PeriodFilter filter;

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
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ExpenseEntity>> createElement() {
    return _ExpensesByDayTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByDayTypeProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesByDayTypeRef on AutoDisposeProviderRef<List<ExpenseEntity>> {
  /// The parameter `filter` of this provider.
  PeriodFilter get filter;
}

class _ExpensesByDayTypeProviderElement
    extends AutoDisposeProviderElement<List<ExpenseEntity>>
    with ExpensesByDayTypeRef {
  _ExpensesByDayTypeProviderElement(super.provider);

  @override
  PeriodFilter get filter => (origin as ExpensesByDayTypeProvider).filter;
}

String _$expenseSummaryHash() => r'26255bd0643828228de3b1c37843e707a5050b28';

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
  ExpenseSummaryProvider call(PeriodFilter filter) {
    return ExpenseSummaryProvider(filter);
  }

  @override
  ExpenseSummaryProvider getProviderOverride(
    covariant ExpenseSummaryProvider provider,
  ) {
    return call(provider.filter);
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
  ExpenseSummaryProvider(PeriodFilter filter)
    : this._internal(
        (ref) => expenseSummary(ref as ExpenseSummaryRef, filter),
        from: expenseSummaryProvider,
        name: r'expenseSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$expenseSummaryHash,
        dependencies: ExpenseSummaryFamily._dependencies,
        allTransitiveDependencies:
            ExpenseSummaryFamily._allTransitiveDependencies,
        filter: filter,
      );

  ExpenseSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final PeriodFilter filter;

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
        filter: filter,
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
    return other is ExpenseSummaryProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseSummaryRef
    on AutoDisposeProviderRef<({double income, double expense})> {
  /// The parameter `filter` of this provider.
  PeriodFilter get filter;
}

class _ExpenseSummaryProviderElement
    extends AutoDisposeProviderElement<({double income, double expense})>
    with ExpenseSummaryRef {
  _ExpenseSummaryProviderElement(super.provider);

  @override
  PeriodFilter get filter => (origin as ExpenseSummaryProvider).filter;
}

String _$expensesInRangeHash() => r'69c97a358b7ed18ffd19837f15c34ccb3c277ce0';

/// Transactions inside [range], in source order (newest first).
///
/// Copied from [expensesInRange].
@ProviderFor(expensesInRange)
const expensesInRangeProvider = ExpensesInRangeFamily();

/// Transactions inside [range], in source order (newest first).
///
/// Copied from [expensesInRange].
class ExpensesInRangeFamily extends Family<List<ExpenseEntity>> {
  /// Transactions inside [range], in source order (newest first).
  ///
  /// Copied from [expensesInRange].
  const ExpensesInRangeFamily();

  /// Transactions inside [range], in source order (newest first).
  ///
  /// Copied from [expensesInRange].
  ExpensesInRangeProvider call(DateRange range) {
    return ExpensesInRangeProvider(range);
  }

  @override
  ExpensesInRangeProvider getProviderOverride(
    covariant ExpensesInRangeProvider provider,
  ) {
    return call(provider.range);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expensesInRangeProvider';
}

/// Transactions inside [range], in source order (newest first).
///
/// Copied from [expensesInRange].
class ExpensesInRangeProvider extends AutoDisposeProvider<List<ExpenseEntity>> {
  /// Transactions inside [range], in source order (newest first).
  ///
  /// Copied from [expensesInRange].
  ExpensesInRangeProvider(DateRange range)
    : this._internal(
        (ref) => expensesInRange(ref as ExpensesInRangeRef, range),
        from: expensesInRangeProvider,
        name: r'expensesInRangeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$expensesInRangeHash,
        dependencies: ExpensesInRangeFamily._dependencies,
        allTransitiveDependencies:
            ExpensesInRangeFamily._allTransitiveDependencies,
        range: range,
      );

  ExpensesInRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.range,
  }) : super.internal();

  final DateRange range;

  @override
  Override overrideWith(
    List<ExpenseEntity> Function(ExpensesInRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpensesInRangeProvider._internal(
        (ref) => create(ref as ExpensesInRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ExpenseEntity>> createElement() {
    return _ExpensesInRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesInRangeProvider && other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpensesInRangeRef on AutoDisposeProviderRef<List<ExpenseEntity>> {
  /// The parameter `range` of this provider.
  DateRange get range;
}

class _ExpensesInRangeProviderElement
    extends AutoDisposeProviderElement<List<ExpenseEntity>>
    with ExpensesInRangeRef {
  _ExpensesInRangeProviderElement(super.provider);

  @override
  DateRange get range => (origin as ExpensesInRangeProvider).range;
}

String _$periodSummaryHash() => r'55067811fde8d358729db42412028659c9681d7b';

/// Totals, category breakdown and top expenses for [range].
///
/// Copied from [periodSummary].
@ProviderFor(periodSummary)
const periodSummaryProvider = PeriodSummaryFamily();

/// Totals, category breakdown and top expenses for [range].
///
/// Copied from [periodSummary].
class PeriodSummaryFamily extends Family<PeriodSummary> {
  /// Totals, category breakdown and top expenses for [range].
  ///
  /// Copied from [periodSummary].
  const PeriodSummaryFamily();

  /// Totals, category breakdown and top expenses for [range].
  ///
  /// Copied from [periodSummary].
  PeriodSummaryProvider call(DateRange range) {
    return PeriodSummaryProvider(range);
  }

  @override
  PeriodSummaryProvider getProviderOverride(
    covariant PeriodSummaryProvider provider,
  ) {
    return call(provider.range);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'periodSummaryProvider';
}

/// Totals, category breakdown and top expenses for [range].
///
/// Copied from [periodSummary].
class PeriodSummaryProvider extends AutoDisposeProvider<PeriodSummary> {
  /// Totals, category breakdown and top expenses for [range].
  ///
  /// Copied from [periodSummary].
  PeriodSummaryProvider(DateRange range)
    : this._internal(
        (ref) => periodSummary(ref as PeriodSummaryRef, range),
        from: periodSummaryProvider,
        name: r'periodSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$periodSummaryHash,
        dependencies: PeriodSummaryFamily._dependencies,
        allTransitiveDependencies:
            PeriodSummaryFamily._allTransitiveDependencies,
        range: range,
      );

  PeriodSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.range,
  }) : super.internal();

  final DateRange range;

  @override
  Override overrideWith(
    PeriodSummary Function(PeriodSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PeriodSummaryProvider._internal(
        (ref) => create(ref as PeriodSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<PeriodSummary> createElement() {
    return _PeriodSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PeriodSummaryProvider && other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PeriodSummaryRef on AutoDisposeProviderRef<PeriodSummary> {
  /// The parameter `range` of this provider.
  DateRange get range;
}

class _PeriodSummaryProviderElement
    extends AutoDisposeProviderElement<PeriodSummary>
    with PeriodSummaryRef {
  _PeriodSummaryProviderElement(super.provider);

  @override
  DateRange get range => (origin as PeriodSummaryProvider).range;
}

String _$periodChartDataHash() => r'50b15a906669dc953c6039b9b05898d1a2679027';

/// Zero-filled chart buckets for [range] (hourly / daily / monthly, see
/// [ExpenseStats.chartTotals]), oldest first.
///
/// Copied from [periodChartData].
@ProviderFor(periodChartData)
const periodChartDataProvider = PeriodChartDataFamily();

/// Zero-filled chart buckets for [range] (hourly / daily / monthly, see
/// [ExpenseStats.chartTotals]), oldest first.
///
/// Copied from [periodChartData].
class PeriodChartDataFamily extends Family<List<DailyChartData>> {
  /// Zero-filled chart buckets for [range] (hourly / daily / monthly, see
  /// [ExpenseStats.chartTotals]), oldest first.
  ///
  /// Copied from [periodChartData].
  const PeriodChartDataFamily();

  /// Zero-filled chart buckets for [range] (hourly / daily / monthly, see
  /// [ExpenseStats.chartTotals]), oldest first.
  ///
  /// Copied from [periodChartData].
  PeriodChartDataProvider call(DateRange range) {
    return PeriodChartDataProvider(range);
  }

  @override
  PeriodChartDataProvider getProviderOverride(
    covariant PeriodChartDataProvider provider,
  ) {
    return call(provider.range);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'periodChartDataProvider';
}

/// Zero-filled chart buckets for [range] (hourly / daily / monthly, see
/// [ExpenseStats.chartTotals]), oldest first.
///
/// Copied from [periodChartData].
class PeriodChartDataProvider
    extends AutoDisposeProvider<List<DailyChartData>> {
  /// Zero-filled chart buckets for [range] (hourly / daily / monthly, see
  /// [ExpenseStats.chartTotals]), oldest first.
  ///
  /// Copied from [periodChartData].
  PeriodChartDataProvider(DateRange range)
    : this._internal(
        (ref) => periodChartData(ref as PeriodChartDataRef, range),
        from: periodChartDataProvider,
        name: r'periodChartDataProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$periodChartDataHash,
        dependencies: PeriodChartDataFamily._dependencies,
        allTransitiveDependencies:
            PeriodChartDataFamily._allTransitiveDependencies,
        range: range,
      );

  PeriodChartDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.range,
  }) : super.internal();

  final DateRange range;

  @override
  Override overrideWith(
    List<DailyChartData> Function(PeriodChartDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PeriodChartDataProvider._internal(
        (ref) => create(ref as PeriodChartDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DailyChartData>> createElement() {
    return _PeriodChartDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PeriodChartDataProvider && other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PeriodChartDataRef on AutoDisposeProviderRef<List<DailyChartData>> {
  /// The parameter `range` of this provider.
  DateRange get range;
}

class _PeriodChartDataProviderElement
    extends AutoDisposeProviderElement<List<DailyChartData>>
    with PeriodChartDataRef {
  _PeriodChartDataProviderElement(super.provider);

  @override
  DateRange get range => (origin as PeriodChartDataProvider).range;
}

String _$earliestExpenseMonthHash() =>
    r'563a87d93dbdb40d9b28793adc817984c7db64f1';

/// First day of the month of the oldest transaction, or of the current month
/// when there are none (never later than the current month). Used to bound
/// month pickers.
///
/// Copied from [earliestExpenseMonth].
@ProviderFor(earliestExpenseMonth)
final earliestExpenseMonthProvider = AutoDisposeProvider<DateTime>.internal(
  earliestExpenseMonth,
  name: r'earliestExpenseMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$earliestExpenseMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EarliestExpenseMonthRef = AutoDisposeProviderRef<DateTime>;
String _$expenseListHash() => r'91161f3e9ec44567075f0a5e2c169382a41ed2db';

/// List ຂອງ transaction ທັງໝົດ - single source of truth
///
/// Copied from [ExpenseList].
@ProviderFor(ExpenseList)
final expenseListProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseList, List<ExpenseEntity>>.internal(
      ExpenseList.new,
      name: r'expenseListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpenseList = AutoDisposeAsyncNotifier<List<ExpenseEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
