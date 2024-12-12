import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class MyTextFiled extends StatelessWidget {
  const MyTextFiled(
      {super.key,
      required this.textController,
      required this.label,
      this.maxLines = 1,
      this.textAlign,
      this.readOnly = false,
      this.validator,
      this.isNumberType = false});

  final String label;
  final TextEditingController textController;
  final int maxLines;
  final TextAlign? textAlign;
  final bool readOnly;
  final bool isNumberType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType:
                isNumberType ? TextInputType.number : TextInputType.text,
            validator: validator,
            inputFormatters:
                isNumberType ? [MyFormatter.thousandsSeparatorFormatter()] : [],
            textAlign: textAlign ?? TextAlign.right,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: MyColors.primaryTextColor,
                  height: 2,
                ),
            controller: textController,
            readOnly: readOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: label,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: MyColors.secondaryTextColor,
                  ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            ),
          ),
        ),
      ],
    );
  }
}
