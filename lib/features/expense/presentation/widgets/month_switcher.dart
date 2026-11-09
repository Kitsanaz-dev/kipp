// features/expense/presentation/widgets/month_switcher.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/month_year_picker.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';

/// `‹  November 2026  ›` row. Chevrons step one month; tapping the title opens
/// the month/year picker. Navigation is bounded to `[first, last]` (months).
class MonthSwitcher extends StatefulWidget {
  const MonthSwitcher({
    super.key,
    required this.month,
    required this.first,
    required this.last,
    required this.onChanged,
  });

  /// The selected month range.
  final DateRange month;

  /// Earliest and latest selectable months (any day within them).
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateRange> onChanged;

  @override
  State<MonthSwitcher> createState() => _MonthSwitcherState();
}

class _MonthSwitcherState extends State<MonthSwitcher> {
  /// +1 when the last change moved forward in time, -1 when backward.
  int _direction = 1;

  DateTime get _firstMonth => DateTime(widget.first.year, widget.first.month);
  DateTime get _lastMonth => DateTime(widget.last.year, widget.last.month);
  bool get _canGoBack => widget.month.start.isAfter(_firstMonth);
  bool get _canGoForward => widget.month.start.isBefore(_lastMonth);

  @override
  void didUpdateWidget(MonthSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.month != oldWidget.month) {
      _direction = widget.month.start.isAfter(oldWidget.month.start) ? 1 : -1;
    }
  }

  void _step(DateRange target) {
    HapticFeedback.selectionClick();
    widget.onChanged(target);
  }

  Future<void> _openPicker() async {
    final picked = await showMonthYearPicker(
      context,
      initial: widget.month.start,
      first: _firstMonth,
      last: _lastMonth,
    );
    if (picked != null && mounted) {
      final range = DateRange.month(picked);
      if (range != widget.month) widget.onChanged(range);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = DateFormat.yMMMM(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(widget.month.start);
    final key = ValueKey(widget.month.start);

    return Row(
      children: [
        IconButton(
          tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
          onPressed: _canGoBack
              ? () => _step(widget.month.previousMonth())
              : null,
          icon: const Icon(Icons.chevron_left),
          color: colors.primary,
          disabledColor: colors.inactive.withValues(alpha: 0.4),
        ),
        Expanded(
          child: Semantics(
            button: true,
            hint: context.text.selectMonth,
            child: InkWell(
              onTap: _openPicker,
              borderRadius: AppRadius.smAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRect(
                  child: AnimatedSwitcher(
                    duration: AppDurations.normal,
                    transitionBuilder: (child, animation) {
                      final incoming = child.key == key;
                      final dx = (incoming ? 0.4 : -0.4) * _direction;
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(dx, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      key: key,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: context.typo.title.copyWith(
                              color: colors.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.expand_more,
                          size: 18,
                          color: colors.subtext,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
          onPressed: _canGoForward
              ? () => _step(widget.month.nextMonth())
              : null,
          icon: const Icon(Icons.chevron_right),
          color: colors.primary,
          disabledColor: colors.inactive.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
