// core/widgets/month_year_picker.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Shows a bottom sheet for picking a month and year.
///
/// Only months in `[first, last]` (compared by month) are selectable. Returns
/// the first day of the chosen month, or `null` when dismissed.
///
/// With [yearOnly] the month grid is hidden: tapping a year chip returns
/// January 1 of that year, and the shortcut becomes "This year".
Future<DateTime?> showMonthYearPicker(
  BuildContext context, {
  required DateTime initial,
  required DateTime first,
  required DateTime last,
  bool yearOnly = false,
}) {
  final firstMonth = DateTime(first.year, first.month);
  final lastMonth = DateTime(last.year, last.month);
  assert(!lastMonth.isBefore(firstMonth), 'last must not be before first');
  var initialMonth = DateTime(initial.year, initial.month);
  if (initialMonth.isBefore(firstMonth)) initialMonth = firstMonth;
  if (initialMonth.isAfter(lastMonth)) initialMonth = lastMonth;

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => MonthYearPickerSheet(
      initial: initialMonth,
      first: firstMonth,
      last: lastMonth,
      yearOnly: yearOnly,
    ),
  );
}

class MonthYearPickerSheet extends StatefulWidget {
  const MonthYearPickerSheet({
    super.key,
    required this.initial,
    required this.first,
    required this.last,
    this.yearOnly = false,
  });

  final bool yearOnly;

  /// All three are first-of-month dates.
  final DateTime initial;
  final DateTime first;
  final DateTime last;

  @override
  State<MonthYearPickerSheet> createState() => _MonthYearPickerSheetState();
}

class _MonthYearPickerSheetState extends State<MonthYearPickerSheet> {
  static const _columns = 3;
  static const _rows = 4;
  static const _cellHeight = 48.0;

  late int _viewYear = widget.initial.year;
  late DateTime _selected = widget.initial;
  final _selectedYearKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealYear());
  }

  void _revealYear({Duration duration = Duration.zero}) {
    final ctx = _selectedYearKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx, alignment: 0.5, duration: duration);
  }

  bool _isEnabled(DateTime month) =>
      !month.isBefore(widget.first) && !month.isAfter(widget.last);

  bool _isYearEnabled(int year) =>
      year >= widget.first.year && year <= widget.last.year;

  Future<void> _pickYear(int year) async {
    setState(() => _viewYear = year);
    await Future<void>.delayed(AppDurations.fast);
    if (mounted) Navigator.of(context).pop(DateTime(year));
  }

  Future<void> _pick(DateTime month) async {
    setState(() => _selected = month);
    // Let the indicator slide before closing.
    await Future<void>.delayed(AppDurations.fast);
    if (mounted) Navigator.of(context).pop(month);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final yearOnly = widget.yearOnly;
    final shortcutEnabled = yearOnly
        ? _isYearEnabled(now.year)
        : _isEnabled(thisMonth);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.inactiveContainer,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  yearOnly ? context.text.selectYear : context.text.selectMonth,
                  style: context.typo.title.copyWith(color: colors.text),
                ),
              ),
              TextButton(
                onPressed: shortcutEnabled
                    ? () => Navigator.of(
                        context,
                      ).pop(yearOnly ? DateTime(now.year) : thisMonth)
                    : null,
                style: TextButton.styleFrom(foregroundColor: colors.primary),
                child: Text(
                  yearOnly
                      ? context.text.thisYearShortcut
                      : context.text.thisMonthShortcut,
                  style: context.typo.subtitle.copyWith(
                    color: shortcutEnabled ? colors.primary : colors.inactive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (yearOnly)
            _buildYearRow(context)
          else ...[
            Text(
              context.text.selectYear,
              style: context.typo.caption.copyWith(color: colors.subtext),
            ),
            const SizedBox(height: 8),
            _buildYearRow(context),
            const SizedBox(height: 20),
            _buildMonthGrid(context, thisMonth),
          ],
        ],
      ),
    );
  }

  Widget _buildYearRow(BuildContext context) {
    final colors = context.colors;
    final years = [
      for (var y = widget.first.year; y <= widget.last.year; y++) y,
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final year = years[i];
          final isSelected = year == _viewYear;
          return GestureDetector(
            key: isSelected ? _selectedYearKey : null,
            onTap: () {
              if (widget.yearOnly) {
                _pickYear(year);
                return;
              }
              setState(() => _viewYear = year);
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _revealYear(duration: AppDurations.fast),
              );
            },
            child: AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.inactiveContainer,
                ),
              ),
              child: Text(
                '$year',
                style: context.typo.subtitle.copyWith(
                  color: isSelected ? colors.onPrimary : colors.subtext,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthGrid(BuildContext context, DateTime thisMonth) {
    final colors = context.colors;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final monthFormat = DateFormat.MMM(localeTag);
    final showIndicator = _selected.year == _viewYear;
    final selectedIndex = _selected.month - 1;
    final col = selectedIndex % _columns;
    final row = selectedIndex ~/ _columns;

    return SizedBox(
      height: _cellHeight * _rows,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / _columns;
          return Stack(
            children: [
              // ---- Glass indicator, same look as DayTypeNavBar ----
              AnimatedAlign(
                duration: AppDurations.slide,
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  -1 + 2 * col / (_columns - 1),
                  -1 + 2 * row / (_rows - 1),
                ),
                child: AnimatedOpacity(
                  duration: AppDurations.fast,
                  opacity: showIndicator ? 1 : 0,
                  child: FakeGlass(
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: AppRadius.md,
                    ),
                    settings: LiquidGlassSettings(
                      blur: 6,
                      glassColor: colors.primary.withValues(alpha: 0.65),
                    ),
                    child: SizedBox(width: cellWidth, height: _cellHeight),
                  ),
                ),
              ),
              Column(
                children: [
                  for (var r = 0; r < _rows; r++)
                    Expanded(
                      child: Row(
                        children: [
                          for (var c = 0; c < _columns; c++)
                            Expanded(
                              child: _monthCell(
                                context,
                                DateTime(_viewYear, r * _columns + c + 1),
                                monthFormat,
                                thisMonth,
                                showIndicator,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _monthCell(
    BuildContext context,
    DateTime month,
    DateFormat format,
    DateTime thisMonth,
    bool showIndicator,
  ) {
    final colors = context.colors;
    final enabled = _isEnabled(month);
    final isSelected = showIndicator && month == _selected;
    final isCurrent = month == thisMonth;

    final Color color;
    if (isSelected) {
      color = colors.onPrimary;
    } else if (!enabled) {
      color = colors.inactive.withValues(alpha: 0.4);
    } else if (isCurrent) {
      color = colors.primary;
    } else {
      color = colors.text;
    }

    return Semantics(
      button: true,
      enabled: enabled,
      selected: isSelected,
      label: DateFormat.yMMMM(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(month),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => _pick(month) : null,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: AppDurations.fast,
            style: context.typo.subtitle.copyWith(
              color: color,
              fontWeight: isSelected || isCurrent
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
            child: Text(format.format(month)),
          ),
        ),
      ),
    );
  }
}
