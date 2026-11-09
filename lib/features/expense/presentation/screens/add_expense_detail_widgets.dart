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
    return SegmentedButton<bool>(
      style: ButtonStyle(
        // ຈັດການສີພື້ນຫຼັງ (Background Color)
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return context.colors.primary; // ສີ Primary ເມື່ອຖືກເລືອກ
          }
          return Colors.transparent; // ສີຕອນບໍ່ໄດ້ເລືອກ
        }),
        // ຈັດການສີຕົວໜັງສື ແລະ ໄອຄອນ (Foreground Color)
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return context.colors.onPrimary; // ສີຕົວໜັງສືຕອນເລືອກ
          }
          return context.colors.text; // ສີຕົວໜັງສືຕອນບໍ່ໄດ້ເລືອກ
        }),
        elevation: const WidgetStatePropertyAll(0),
      ),
      segments: [
        ButtonSegment(value: true, label: Text(context.text.expenses)),
        ButtonSegment(value: false, label: Text(context.text.income)),
      ],
      selected: {isExpense},
      onSelectionChanged: (Set<bool> newSelection) =>
          onChanged(newSelection.first),
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
                // ສະແດງ Bottom Sheet ແບບ iOS Native
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text(context.text.selectTypeTitle),
                    actions: types.map((type) {
                      return CupertinoActionSheetAction(
                        onPressed: () {
                          onSelected(type);
                          state.didChange(
                            type,
                          ); // ອັບເດດ state ໃຫ້ Form Validation ເຫັນ
                          Navigator.pop(context);
                        },
                        child: Text(
                          type,
                          style: TextStyle(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    cancelButton: CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.text.cancel),
                    ),
                  ),
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

/// Receipt-scan floating action button (spinner while scanning).
class _ScanReceiptFab extends StatelessWidget {
  const _ScanReceiptFab({required this.isScanning, required this.onPressed});

  final bool isScanning;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: context.colors.primary,
      onPressed: isScanning ? null : onPressed,
      child: isScanning
          ? AdaptiveSpinner(size: 20, color: context.colors.onPrimary)
          : Icon(
              Platform.isAndroid ? Icons.camera_alt : CupertinoIcons.camera,
              color: context.colors.onPrimary,
            ),
    );
  }
}
