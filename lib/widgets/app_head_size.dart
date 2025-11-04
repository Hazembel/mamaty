import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class VerticalMeasurementRuler extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final double step; // new: step size (e.g., 0.1)
  final ValueChanged<double>? onChanged;
  final bool enabled;

  const VerticalMeasurementRuler({
    super.key,
    this.minValue = 1,
    this.maxValue = 10,
    this.initialValue = 5.0,
    this.step = 0.1, // default step
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<VerticalMeasurementRuler> createState() =>
      _VerticalMeasurementRulerState();
}

class _VerticalMeasurementRulerState extends State<VerticalMeasurementRuler> {
  late ScrollController _scrollController;
  late double _currentValue;
  static const double _itemExtent = 50.0; // smaller for decimals
  static const double _visibleHeight = 400.0;
  static const double _selectedBoxSize = 120.0;
  late final double _verticalPadding;
  bool isMetric = true;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _verticalPadding = (_visibleHeight / 2) - (_itemExtent / 2);

    final initialOffset =
        ((_currentValue - widget.minValue) / widget.step) * _itemExtent -
            _verticalPadding;
    _scrollController = ScrollController(
      initialScrollOffset: initialOffset.clamp(0.0, double.infinity),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.enabled) return;

    final offset = _scrollController.offset + _verticalPadding;
    double value = widget.minValue + (offset / _itemExtent) * widget.step;
    value = value.clamp(widget.minValue, widget.maxValue);
    value = double.parse(value.toStringAsFixed(1)); // round to 1 decimal

    if (value != _currentValue) {
      setState(() {
        _currentValue = value;
      });
      widget.onChanged?.call(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        ((widget.maxValue - widget.minValue) / widget.step).ceil() + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Unit toggle
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [AppColors.defaultShadow],
          ),
          height: 44,
          width: 150,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.enabled
                      ? () => setState(() => isMetric = false)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: !isMetric && widget.enabled
                          ? AppColors.premier
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Inch',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: !isMetric && widget.enabled
                            ? Colors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: widget.enabled
                      ? () => setState(() => isMetric = true)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isMetric && widget.enabled
                          ? AppColors.premier
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cm',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: isMetric && widget.enabled
                            ? Colors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Ruler
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: _visibleHeight,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (!widget.enabled) return true;
                  if (notification is ScrollUpdateNotification ||
                      notification is ScrollEndNotification) {
                    _onScroll();
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemExtent: _itemExtent,
                  physics: widget.enabled
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: _verticalPadding),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final value = widget.minValue + index * widget.step;
                    final isSelected = value == _currentValue;

                    return Opacity(
                      opacity: isSelected ? 0.0 : 0.8,
                      child: Center(
                        child: Text(
                          isMetric
                              ? value.toStringAsFixed(1)
                              : (value * 0.393701).toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.premier,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Container(
              width: _selectedBoxSize,
              height: _selectedBoxSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [AppColors.defaultShadow],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isMetric
                          ? _currentValue.toStringAsFixed(1)
                          : (_currentValue * 0.393701).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isMetric ? 'cm' : 'in',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
