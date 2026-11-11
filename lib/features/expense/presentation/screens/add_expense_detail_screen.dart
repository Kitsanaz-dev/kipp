import 'dart:io';
import 'package:kipp/core/network/network_providers.dart';
import 'package:kipp/core/network/api_exceptions.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/adaptive_spinner.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/core/widgets/glass_body.dart';
import 'package:kipp/core/widgets/glass_segmented_bar.dart';
import 'package:kipp/features/expense/data/services/receipt_scanner_service.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/kipp_app_bar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

part 'add_expense_detail_widgets.dart';

class AddExpenseDetailScreen extends ConsumerStatefulWidget {
  const AddExpenseDetailScreen({super.key});

  @override
  ConsumerState<AddExpenseDetailScreen> createState() =>
      _AddExpenseDetailScreenState();
}

class _AddExpenseDetailScreenState
    extends ConsumerState<AddExpenseDetailScreen> {
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
      id: '', // assigned by the backend; toJson() never sends it
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
    final scanner = ReceiptScannerService(ref.read(apiClientProvider));

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
      final message = e is ScanException
          ? switch (e.code) {
              'scan_unavailable' => context.text.scanUnavailable,
              'scan_timeout' => context.text.scanTimeout,
              'rate_limited' => context.text.scanRateLimited,
              _ => context.text.fetchDataError,
            }
          : e is NetworkException
          ? context.text.networkError
          : context.text.fetchDataError;
      AppSnackbar.showError(context, message);
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTypes = _isExpense ? _expenseTypes : _incomeTypes;

    return GlassScaffold(
      backgroundColor: context.colors.background,
      extendBody: false,
      appBar: KippAppBar(
        title: context.text.addTransaction,
        leading: const KippBackButton(), // ✅ go_router pop
      ),

      // GlassScaffold has no FAB slot: the scan button floats in an overlay
      // at the end-float position, above the keyboard like a FAB.
      bodyOverlays: [
        Positioned(
          right: 16,
          bottom: 16 + MediaQuery.paddingOf(context).bottom,
          child: _ScanReceiptFab(
            isScanning: _isScanning,
            onPressed: _scanReceipt,
          ),
        ),
      ],

      body: GlassBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. ເລືອກ Income ຫຼື Expense
                _TransactionTypeToggle(
                  isExpense: _isExpense,
                  onChanged: (isExpense) => setState(() {
                    _isExpense = isExpense;
                    _selectedType = null; // Reset category ເມື່ອປ່ຽນປະເພດ
                  }),
                ),
                const SizedBox(height: 16),

                // 2. ປ້ອນຈຳນວນເງິນ
                _AmountField(controller: _amountController),
                const SizedBox(height: 16),

                // 3. ເລືອກ Type ຂອງການຈ່າຍ/ຮັບ
                _CategoryPickerField(
                  types: currentTypes,
                  selectedType: _selectedType,
                  onSelected: (type) => setState(() => _selectedType = type),
                ),
                const SizedBox(height: 16),

                // 4. ຄຳອະທິບາຍ (Description)
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.text.description,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.xl),
                      ),
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
      ),
    );
  }
}
