import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../theme/text_styles.dart';
class AppCodeInput extends StatefulWidget {
  final int length;
  final void Function(String)? onCompleted;

  const AppCodeInput({
    super.key,
    this.length = 4,
    this.onCompleted,
  });

  @override
  State<AppCodeInput> createState() => _AppCodeInputState();
}

class _AppCodeInputState extends State<AppCodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index < widget.length - 1 ? 10 : 0),
          child: SizedBox(
            width: 60,
            height: 65,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: AppTextStyles.inter24Bold.copyWith(
              
                color: AppColors.black,
              ),

              decoration: InputDecoration(
                counterText: "",
                contentPadding: const EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppBorders.defaultRadius),
                  borderSide: const BorderSide(
                    color: AppColors.premier,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppBorders.defaultRadius),
                  borderSide: const BorderSide(
                    color: AppColors.premier,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (val) => _onChanged(val, index),
            ),
          ),
        );
      }),
    );
  }
}
