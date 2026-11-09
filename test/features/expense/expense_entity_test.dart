import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';

void main() {
  group('ExpenseEntity.fromJson', () {
    test('maps snake_case keys and converts UTC wire date to local', () {
      final e = ExpenseEntity.fromJson({
        'id': 42,
        'title': 'Lunch',
        'amount': 25000,
        'category': 'Food',
        'is_income': false,
        'description': 'noodles',
        'date': '2026-03-01T05:30:00.000Z',
      });

      expect(e.id, '42'); // numeric ids are stringified
      expect(e.title, 'Lunch');
      expect(e.amount, 25000.0);
      expect(e.amount, isA<double>());
      expect(e.category, 'Food');
      expect(e.isIncome, isFalse);
      expect(e.description, 'noodles');
      expect(e.date.isUtc, isFalse);
      expect(e.date, DateTime.utc(2026, 3, 1, 5, 30).toLocal());
    });

    test('falls back to defaults for missing optional fields', () {
      final e = ExpenseEntity.fromJson({
        'id': 'x',
        'date': '2026-03-01T00:00:00Z',
      });
      expect(e.title, '');
      expect(e.amount, 0.0);
      expect(e.category, '');
      expect(e.isIncome, isFalse);
      expect(e.description, '');
    });
  });

  group('ExpenseEntity.toJson', () {
    final local = DateTime(2026, 2, 28, 23, 15);
    final entity = ExpenseEntity(
      id: 'abc',
      title: 'Salary',
      amount: 1500000.5,
      category: 'Salary',
      isIncome: true,
      description: 'Feb',
      date: local,
    );

    test('emits snake_case keys, no id, UTC ISO-8601 date', () {
      final json = entity.toJson();
      expect(json.keys.toSet(), {
        'title',
        'amount',
        'category',
        'is_income',
        'description',
        'date',
      });
      expect(json['is_income'], isTrue);
      expect(json['amount'], 1500000.5);
      final date = json['date'] as String;
      expect(date, endsWith('Z'));
      expect(DateTime.parse(date), local.toUtc());
    });

    test('round trip preserves every field (date back in local time)', () {
      final back = ExpenseEntity.fromJson({...entity.toJson(), 'id': 'abc'});
      expect(back.id, entity.id);
      expect(back.title, entity.title);
      expect(back.amount, entity.amount);
      expect(back.category, entity.category);
      expect(back.isIncome, entity.isIncome);
      expect(back.description, entity.description);
      expect(back.date.isUtc, isFalse);
      expect(back.date, local);
    });
  });
}
