import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FilterChipsBar extends StatefulWidget {
  final List<String> filters;
  final String? selectedFilter;
  final ValueChanged<String> onSelected;

  const FilterChipsBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  State<FilterChipsBar> createState() => _FilterChipsBarState();
}

class _FilterChipsBarState extends State<FilterChipsBar> {
  final Map<String, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();
    _initKeys();
  }

  @override
  void didUpdateWidget(covariant FilterChipsBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initKeys();
    if (widget.selectedFilter != oldWidget.selectedFilter &&
        widget.selectedFilter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _initKeys() {
    for (final filter in widget.filters) {
      _chipKeys.putIfAbsent(filter, () => GlobalKey());
    }
  }

  void _scrollToSelected() {
    final key = _chipKeys[widget.selectedFilter];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        alignment: 0.3,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        key: const PageStorageKey<String>('filter_chips_horizontal_bar'),
        scrollDirection: Axis.horizontal,
        itemCount: widget.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = widget.filters[index];
          final isSelected = filter == widget.selectedFilter;

          return InkWell(
            key: _chipKeys[filter],
            onTap: () {
              widget.onSelected(filter);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final key = _chipKeys[filter];
                if (key?.currentContext != null) {
                  Scrollable.ensureVisible(
                    key!.currentContext!,
                    alignment: 0.3,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryContainer : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 1.2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
