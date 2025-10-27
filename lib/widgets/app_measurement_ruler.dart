import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class MeasurementRuler extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double>? onChanged;

  const MeasurementRuler({
    super.key,
    this.minValue = 0,
    this.maxValue = 100,
    this.initialValue = 0, // start from 0
    this.onChanged,
  });

  @override
  State<MeasurementRuler> createState() => _MeasurementRulerState();
}

class _MeasurementRulerState extends State<MeasurementRuler> {
  late ScrollController _scrollController;
  bool isMetric = true;
  late double _currentValue;
  static const double _itemExtent = 40.0;

  late double _paddingWidth;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;

    // we calculate padding after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        _paddingWidth = screenWidth / 2 - _itemExtent / 2;

        _scrollController = ScrollController(
          initialScrollOffset:
              (_currentValue - widget.minValue) * _itemExtent,
        );
      });
    });

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _getValueFromOffset(double offset) {
    return (offset / _itemExtent) + widget.minValue;
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.premier;
    final textColor = AppColors.black;
    final screenWidth = MediaQuery.of(context).size.width;
    _paddingWidth = screenWidth / 2 - _itemExtent / 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🧭 Unit Toggle
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
              boxShadow: [AppColors.defaultShadow]
          ),
          height: 44,
          width: 150,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isMetric = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: !isMetric ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Inch',
                      style: TextStyle(
                        color: !isMetric ? Colors.white : textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isMetric = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isMetric ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cm',
                     
 style: AppTextStyles.inter14Med.copyWith(
                  color: isMetric ? Colors.white : textColor,
                ),


                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 📏 Value Display + Ruler
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppColors.defaultShadow],
          ),
          child: Column(
            children: [
              Text(
                isMetric
                    ? _currentValue.toStringAsFixed(0)
                    : (_currentValue * 0.393701).toStringAsFixed(0),
                style: AppTextStyles.inter80Bold.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isMetric ? 'Cm' : 'Inch',
               style: AppTextStyles.inter14Med.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal ruler
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    setState(() {
                      _currentValue = _getValueFromOffset(
                        _scrollController.offset,
                      ).clamp(widget.minValue, widget.maxValue);
                      widget.onChanged?.call(_currentValue);
                    });
                  }
                  return true;
                },
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemExtent: _itemExtent,
                    itemCount: (widget.maxValue - widget.minValue).toInt() + 1,
                    padding:
                        EdgeInsets.symmetric(horizontal: _paddingWidth),  
                    itemBuilder: (context, index) {
                      final value = index + widget.minValue.toInt();
                      final isLongTick = value % 10 == 0;
                      final showNumber = value % 10 == 0;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (showNumber)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                isMetric
                                    ? '$value'
                                    : '${(value * 0.393701).round()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          Container(
                            width: 2,
                            height: isLongTick ? 20 : 10,
                            color: isLongTick
                                ? AppColors.black
                                :  AppColors.black,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
