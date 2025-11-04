import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class VerticalMeasurementRuler extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final double initialValue;
  final ValueChanged<double>? onChanged; // <-- now double

  const VerticalMeasurementRuler({
    super.key,
    this.minValue = 1,
    this.maxValue = 10,
    this.initialValue = 5.0,
    this.onChanged,
  });

  @override
  State<VerticalMeasurementRuler> createState() =>
      _VerticalMeasurementRulerState();
}

class _VerticalMeasurementRulerState extends State<VerticalMeasurementRuler> {
  late ScrollController _scrollController;
  late double _currentValue; // <-- double
  static const double _itemExtent = 65.0;
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
        (_currentValue - widget.minValue) * _itemExtent - _verticalPadding;
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
    final offset = _scrollController.offset + _verticalPadding;
    double value = (offset / _itemExtent) + widget.minValue.toDouble(); // <-- double
    value = value.clamp(widget.minValue.toDouble(), widget.maxValue.toDouble());
    if (value != _currentValue) {
      setState(() {
        _currentValue = value;
      });
      widget.onChanged?.call(_currentValue); // <-- double
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => setState(() => isMetric = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: !isMetric ? AppColors.premier : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Inch',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: !isMetric ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isMetric = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isMetric ? AppColors.premier : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cm',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: isMetric ? Colors.white : AppColors.black,
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: _verticalPadding),
                  itemCount: widget.maxValue - widget.minValue + 1,
                  itemBuilder: (context, index) {
                    final value = widget.minValue + index;
                    final isSelected = value.toDouble() == _currentValue;

                    return Opacity(
                      opacity: isSelected ? 0.0 : 0.8,
                      child: Center(
                        child: Text(
                          isMetric
                              ? value.toString()
                              : (value * 0.393701).toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 32,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isMetric
                          ? _currentValue.toStringAsFixed(0)
                          : (_currentValue * 0.393701).toStringAsFixed(0),
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
