// features/expense/presentation/widgets/period_switcher.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/month_year_picker.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';

/// `‹  November 2026  ›` row for any [PeriodUnit]. Chevrons step one unit;
/// tapping the title opens a picker (date picker for day/week, month/year
/// picker for month, year picker for year). Navigation is bounded so a period
/// must overlap `[first, last]`.
class PeriodSwitcher extends StatefulWidget {
  const PeriodSwitcher({
    super.key,
    required this.unit,
    required this.range,
    required this.first,
    required this.last,
    required this.onChanged,
  });

  final PeriodUnit unit;

  /// The selected period; always `unit.rangeOf(...)`.
  final DateRange range;

  /// Earliest and latest reachable dates.
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateRange> onChanged;

  @override
  State<PeriodSwitcher> createState() => _PeriodSwitcherState();
}

class _PeriodSwitcherState extends State<PeriodSwitcher> {
  /// +1 when the last change moved forward in time, -1 when backward.
  int _direction = 1;

  DateRange get _previous => widget.unit.shift(widget.range, -1);
  DateRange get _next => widget.unit.shift(widget.range, 1);
  bool get _canGoBack => _previous.end.isAfter(widget.first);
  bool get _canGoForward => !_next.start.isAfter(widget.last);

  @override
  void didUpdateWidget(PeriodSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.range != oldWidget.range) {
      _direction = widget.range.start.isAfter(oldWidget.range.start) ? 1 : -1;
    }
  }

  void _step(DateRange target) {
    HapticFeedback.selectionClick();
    widget.onChanged(target);
  }

  Future<void> _openPicker() async {
    final first = widget.first;
    final last = widget.last;
    final DateTime? picked;
    switch (widget.unit) {
      case PeriodUnit.day:
      case PeriodUnit.week:
        final firstDay = DateTime(first.year, first.month, first.day);
        final lastDay = DateTime(last.year, last.month, last.day);
        var initial = widget.range.start;
        if (initial.isBefore(firstDay)) initial = firstDay;
        if (initial.isAfter(lastDay)) initial = lastDay;
        picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: firstDay,
          lastDate: lastDay,
        );
      case PeriodUnit.month:
        picked = await showMonthYearPicker(
          context,
          initial: widget.range.start,
          first: first,
          last: last,
        );
      case PeriodUnit.year:
        picked = await showMonthYearPicker(
          context,
          initial: widget.range.start,
          first: first,
          last: last,
          yearOnly: true,
        );
    }
    if (picked != null && mounted) {
      final range = widget.unit.rangeOf(picked);
      if (range != widget.range) widget.onChanged(range);
    }
  }

  String _title(String locale) {
    final start = widget.range.start;
    return switch (widget.unit) {
      PeriodUnit.day => DateFormat.yMMMEd(locale).format(start),
      PeriodUnit.week =>
        '${DateFormat.MMMd(locale).format(start)} – '
            '${DateFormat.yMMMd(locale).format(widget.range.days.last)}',
      PeriodUnit.month => DateFormat.yMMMM(locale).format(start),
      PeriodUnit.year => DateFormat.y(locale).format(start),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = _title(Localizations.localeOf(context).toLanguageTag());
    final key = ValueKey(widget.range);
    final material = MaterialLocalizations.of(context);

    return Row(
      children: [
        IconButton(
          tooltip: material.previousPageTooltip,
          onPressed: _canGoBack ? () => _step(_previous) : null,
          icon: const Icon(Icons.chevron_left),
          color: colors.primary,
          disabledColor: colors.inactive.withValues(alpha: 0.4),
        ),
        Expanded(
          child: Semantics(
            button: true,
            hint: switch (widget.unit) {
              PeriodUnit.month => context.text.selectMonth,
              PeriodUnit.year => context.text.selectYear,
              _ => null,
            },
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
          tooltip: material.nextPageTooltip,
          onPressed: _canGoForward ? () => _step(_next) : null,
          icon: const Icon(Icons.chevron_right),
          color: colors.primary,
          disabledColor: colors.inactive.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
