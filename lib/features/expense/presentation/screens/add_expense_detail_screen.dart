import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/features/expense/data/services/receipt_scanner_service.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/kipp_app_bar.dart';
import 'package:uuid/uuid.dart';

class AddExpenseDetailPage extends ConsumerStatefulWidget {
  const AddExpenseDetailPage({super.key});

  @override
  ConsumerState<AddExpenseDetailPage> createState() =>
      _AddExpenseDetailPageState();
}

class _AddExpenseDetailPageState extends ConsumerState<AddExpenseDetailPage> {
  // -------- keys --------
  final _formKey = GlobalKey<FormState>();

  // -------- state variables --------
  bool _isExpense = true;
  bool _isSaving = false;
  bool _isScanning = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedType;

  // -------- constants --------
  final List<String> _expenseTypes = [
    'Food',
    'Travel',
    'Sports',
    'Medical',
    'Entertainment',
    'Shopping',
    'Electric/Water bills',
    'Other',
  ];
  final List<String> _incomeTypes = ['Salary', 'Business', 'Bonus', 'Other'];

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return; // ✅ ກັນກົດຊ້ຳຕອນກຳລັງ save ຢູ່

    setState(() => _isSaving = true);

    final expense = ExpenseEntity(
      id: const Uuid().v4(),
      title: _selectedType ?? 'Untitled',
      amount: double.tryParse(_amountController.text) ?? 0.0,
      category: _selectedType ?? 'Other',
      isIncome: !_isExpense,
      description: _descController.text,
      date: DateTime.now(),
    );

    try {
      await ref.read(expenseListProvider.notifier).add(expense);
      if (!mounted) return;

      // ✅ ສະແດງ success ກ່ອນ pop
      AppSnackbar.showSuccess(context, context.text.savedSuccessfully);

      context.pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, context.text.saveFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _scanReceipt() async {
    final capturedFile = await context.push<File?>(RoutePaths.receiptCapture);
    if (capturedFile == null || !mounted) return;

    setState(() => _isScanning = true);
    final scanner = ReceiptScannerService();

    try {
      // ສົ່ງ List ຂອງ Categories ໄປໃຫ້ AI ເພື່ອໃຫ້ມັນເລືອກໄດ້ກົງກັບ Dropdown ຂອງເຮົາ
      final data = await scanner.scan(
        capturedFile,
        _expenseTypes,
        _incomeTypes,
      );
      if (!mounted) return;

      if (data != null) {
        setState(() {
          // 1. ອັບເດດຈຳນວນເງິນ
          if (data.amount != null) {
            _amountController.text = data.amount!.toStringAsFixed(0);
          }

          // 2. ອັບເດດປະເພດ (Income/Expense)
          if (data.isIncome != null) {
            _isExpense = !(data.isIncome!);
          }

          // 3. ອັບເດດ Category (Dropdown)
          // ຕ້ອງກວດສອບວ່າ AI ຕອບມາກົງກັບ List ທີ່ເຮົາມີແທ້ບໍ່
          if (data.category != null) {
            final activeList = _isExpense ? _expenseTypes : _incomeTypes;
            if (activeList.contains(data.category)) {
              _selectedType = data.category;
            } else {
              _selectedType = 'Other'; // ຖ້າບໍ່ກົງໃຫ້ເຂົ້າ Other
            }
          }

          // 4. ອັບເດດຄຳອະທິບາຍ
          if (data.description != null) {
            _descController.text = data.description!;
          }
        });

        AppSnackbar.showSuccess(context, context.text.fetchData);
      } else {
        throw Exception("AI response is empty");
      }
    } catch (e) {
      AppSnackbar.showError(context, context.text.fetchDataError);
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTypes = _isExpense ? _expenseTypes : _incomeTypes;

    return Scaffold(
      appBar: KippAppBar(
        title: context.text.addTransaction,
        leading: IconButton(
          onPressed: () => context.pop(), // ✅ go_router
          icon: Icon(
            CupertinoIcons.back,
            color: context.colors.onPrimary,
            size: 32,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. ເລືອກ Income ຫຼື Expense
              SegmentedButton<bool>(
                style: ButtonStyle(
                  // ຈັດການສີພື້ນຫຼັງ (Background Color)
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return context.colors.primary; // ສີ Primary ເມື່ອຖືກເລືອກ
                    }
                    return Colors.transparent; // ສີຕອນບໍ່ໄດ້ເລືອກ
                  }),
                  // ຈັດການສີຕົວໜັງສື ແລະ ໄອຄອນ (Foreground Color)
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return context.colors.onPrimary; // ສີຕົວໜັງສືຕອນເລືອກ
                    }
                    return context.colors.text; // ສີຕົວໜັງສືຕອນບໍ່ໄດ້ເລືອກ
                  }),
                  elevation: const WidgetStatePropertyAll(0),
                ),
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(context.text.expenses),
                  ),
                  ButtonSegment(value: false, label: Text(context.text.income)),
                ],
                selected: {_isExpense},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isExpense = newSelection.first;
                    _selectedType = null; // Reset category ເມື່ອປ່ຽນປະເພດ
                  });
                },
              ),
              const SizedBox(height: 16),

              // 2. ປ້ອນຈຳນວນເງິນ
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.xlAll,
                  ), // ✅ token
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.hint,
                          width: 1.5,
                        ),
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
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) return 'Please enter a valid number';
                  if (amount <= 0) {
                    return 'Amount must be greater than 0'; // ✅ ເພີ່ມ
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. ເລືອກ Type ຂອງການຈ່າຍ/ຮັບ
              FormField<String>(
                validator: (value) =>
                    _selectedType == null ? 'Please select a type' : null,
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
                              title: const Text('Select Type...'),
                              actions: currentTypes.map((type) {
                                return CupertinoActionSheetAction(
                                  onPressed: () {
                                    setState(() {
                                      _selectedType = type;
                                      state.didChange(
                                        type,
                                      ); // ອັບເດດ state ໃຫ້ Form Validation ເຫັນ
                                    });
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
                                child: const Text('Cancel'),
                              ),
                            ),
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Type',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            errorText: state
                                .errorText, // ສະແດງຂໍ້ຄວາມ Error ຖ້າບໍ່ໄດ້ເລືອກ
                            suffixIcon: const Icon(
                              CupertinoIcons.chevron_up_chevron_down,
                              size: 18,
                            ),
                          ),
                          child: Text(
                            _selectedType ?? 'Select Type',
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedType == null
                                  ? context.colors.hint
                                  : context.colors.text,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // 4. ຄຳອະທິບາຍ (Description)
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ປຸ່ມ Save
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : _saveTransaction, // ✅ disable ຕອນ saving
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.xlAll,
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.colors.onPrimary,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.text.save,
                              style: context.typo.title.copyWith(
                                color: context.colors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: context.colors.primary,
        onPressed: _isScanning ? null : _scanReceipt,
        child: _isScanning
            ? SizedBox(
                width: 20,
                height: 20,
                child: Platform.isAndroid
                    ? CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.onPrimary,
                      )
                    : CupertinoActivityIndicator(
                        color: context.colors.onPrimary,
                      ),
              )
            : Icon(
                Platform.isAndroid ? Icons.camera_alt : CupertinoIcons.camera,
                color: context.colors.onPrimary,
              ),
      ),
    );
  }
}
