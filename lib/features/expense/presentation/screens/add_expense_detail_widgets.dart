// features/expense/presentation/screens/add_expense_detail_widgets.dart
part of 'add_expense_detail_screen.dart';

/// 1. Expense / Income segmented toggle.
class _TransactionTypeToggle extends StatelessWidget {
  const _TransactionTypeToggle({
    required this.isExpense,
    required this.onChanged,
  });

  final bool isExpense;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassSegmentedBar(
      height: 44,
      labels: [context.text.expenses, context.text.income],
      selectedIndex: isExpense ? 0 : 1,
      // Like SegmentedButton, re-tapping the selected segment is a no-op
      // (a change resets the chosen category).
      onSelected: (index) {
        final expense = index == 0;
        if (expense != isExpense) onChanged(expense);
      },
    );
  }
}

/// 2. Amount input with the ₭ prefix and validation.
class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: context.text.amount,
        border: OutlineInputBorder(borderRadius: AppRadius.xlAll), // ✅ token
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.hint, width: 1.5),
            ),
            child: Text(
              '₭',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: context.colors.hint,
              ),
            ),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.text.pleaseEnterAmount;
        }
        final amount = double.tryParse(value);
        if (amount == null) {
          return context.text.pleaseEnterValidNumber;
        }
        if (amount <= 0) {
          return context.text.amountMustBeGreaterThanZero;
        }
        return null;
      },
    );
  }
}

/// 3. Category field that opens a Cupertino action sheet of [types].
class _CategoryPickerField extends StatelessWidget {
  const _CategoryPickerField({
    required this.types,
    required this.selectedType,
    required this.onSelected,
  });

  final List<String> types;
  final String? selectedType;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) =>
          selectedType == null ? context.text.pleaseSelectType : null,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // ສະແດງ glass action sheet (ປິດເອງເມື່ອເລືອກ)
                showGlassActionSheet<void>(
                  context: context,
                  title: context.text.selectTypeTitle,
                  cancelLabel: context.text.cancel,
                  actions: [
                    for (final type in types)
                      GlassActionSheetAction(
                        label: type,
                        onPressed: () {
                          onSelected(type);
                          // ອັບເດດ state ໃຫ້ Form Validation ເຫັນ
                          state.didChange(type);
                        },
                      ),
                  ],
                );
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: context.text.type,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.xl),
                    ),
                  ),
                  errorText:
                      state.errorText, // ສະແດງຂໍ້ຄວາມ Error ຖ້າບໍ່ໄດ້ເລືອກ
                  suffixIcon: const Icon(
                    CupertinoIcons.chevron_up_chevron_down,
                    size: 18,
                  ),
                ),
                child: Text(
                  selectedType ?? context.text.selectType,
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedType == null
                        ? context.colors.hint
                        : context.colors.text,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Floating glass receipt-scan button (spinner and disabled while scanning).
class _ScanReceiptFab extends StatelessWidget {
  const _ScanReceiptFab({required this.isScanning, required this.onPressed});

  final bool isScanning;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassIconButton(
      size: 56,
      iconSize: 24,
      semanticLabel: context.text.scanReceipt,
      // Brand-tinted glass, like the coral FAB it replaces.
      settings: LiquidGlassSettings(
        glassColor: colors.primary.withValues(alpha: 0.85),
      ),
      onPressed: isScanning ? null : onPressed,
      icon: isScanning
          ? AdaptiveSpinner(size: 20, color: colors.onPrimary)
          : Icon(
              Platform.isAndroid ? Icons.camera_alt : CupertinoIcons.camera,
              color: colors.onPrimary,
            ),
    );
  }
}
