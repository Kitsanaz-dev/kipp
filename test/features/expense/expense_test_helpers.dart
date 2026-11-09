import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';

/// Builds an [ExpenseEntity] fixture with sensible defaults.
ExpenseEntity tx(
  String id,
  DateTime date,
  double amount, {
  bool income = false,
  String category = 'Food',
}) => ExpenseEntity(
  id: id,
  title: category,
  amount: amount,
  category: category,
  isIncome: income,
  description: '',
  date: date,
);

class _FakeExpenseList extends ExpenseList {
  _FakeExpenseList(this._items);

  final List<ExpenseEntity> _items;

  @override
  Future<List<ExpenseEntity>> build() async => _items;
}

/// A [ProviderContainer] whose [expenseListProvider] resolves to [items].
/// The list provider is kept alive and already resolved when this returns, so
/// derived providers can be read synchronously.
Future<ProviderContainer> containerWith(List<ExpenseEntity> items) async {
  final container = ProviderContainer(
    overrides: [expenseListProvider.overrideWith(() => _FakeExpenseList(items))],
  );
  addTearDown(container.dispose);
  container.listen(expenseListProvider, (_, _) {});
  await container.read(expenseListProvider.future);
  return container;
}

/// Local midnight of [d].
DateTime midnight(DateTime d) => DateTime(d.year, d.month, d.day);
