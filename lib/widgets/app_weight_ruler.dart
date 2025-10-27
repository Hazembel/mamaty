import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class WeightRuler extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double>? onChanged;

  const WeightRuler({
    super.key,
    this.minValue = 0,
    this.maxValue = 50,
    this.initialValue = 0,
    this.onChanged,
  });

  @override
  State<WeightRuler> createState() => _WeightRulerState();
}

class _WeightRulerState extends State<WeightRuler> {
  late ScrollController _scrollController;
  bool isKg = true;
  late double _currentValue;
  static const double _itemExtent = 40.0;
  late double _paddingWidth;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        _paddingWidth = screenWidth / 2 - _itemExtent / 2;
        _scrollController = ScrollController(
          initialScrollOffset: (_currentValue - widget.minValue) * _itemExtent,
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
        // ⚖️ Unit Toggle
        Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                  onTap: () => setState(() => isKg = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: !isKg ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Lb',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: !isKg ? Colors.white : textColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isKg = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isKg ? accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Kg',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: isKg ? Colors.white : textColor,
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
                isKg
                    ? _currentValue.toStringAsFixed(1)
                    : (_currentValue * 2.20462).toStringAsFixed(1),
                style: AppTextStyles.inter80Bold.copyWith(color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                isKg ? 'Kg' : 'Lb',
                style: AppTextStyles.inter14Med.copyWith(color: textColor),
              ),
              const SizedBox(height: 12),

              // Ruler
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
                    padding: EdgeInsets.symmetric(horizontal: _paddingWidth),
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
                                isKg
                                    ? '$value'
                                    : '${(value * 2.20462).round()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          Container(
                            width: 2,
                            height: isLongTick ? 20 : 10,
                            color: textColor,
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
