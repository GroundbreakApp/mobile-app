import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ground_break/components/components.dart';
import 'package:ground_break/constants/constants.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    Key? key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.maxLength,
    this.isMaxed = false,
    this.minLines,
    this.maxLines = 1,
    this.hintMaxLines,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.showBorder = true,
    this.isDense = true,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.enablePrefixIcon = false,
    this.setPrefixIcon = Icons.search,
    this.prefixText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final int? maxLength;
  final bool isMaxed;
  final int? minLines;
  final int? maxLines;
  final int? hintMaxLines;
  final bool readOnly;
  final bool obscureText;
  final bool autocorrect;
  final bool autofocus;
  final bool showBorder;
  final bool? isDense;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool enablePrefixIcon;
  final IconData? setPrefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      autocorrect: autocorrect,
      autofocus: autofocus,
      textInputAction: textInputAction ?? TextInputAction.done,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      obscureText: obscureText,
      focusNode: focusNode,
      style: style,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintMaxLines: hintMaxLines,
        prefixIcon: enablePrefixIcon
            ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: Icon(
                  setPrefixIcon,
                  color: AppColors.black,
                  size: 26,
                ),
              )
            : null,
        prefixText: prefixText,
        alignLabelWithHint: true,
        counterText: '',
        isDense: isDense,
        hintText: hintText,
        labelText: labelText,
        hintStyle: hintStyle,
        labelStyle: isMaxed
            ? TextStyle(
                color: Theme.of(context).inputDecorationTheme.errorStyle?.color,
                fontSize: 19,
              )
            : labelStyle,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: showBorder
            ? OutlineInputBorder(
                borderRadius: borderRadius ?? AppBorders.roundedBorder5,
                borderSide:
                    Theme.of(context).inputDecorationTheme.border!.borderSide,
              )
            : OutlineInputBorder(
                borderRadius: borderRadius ?? AppBorders.roundedBorder5,
                borderSide: BorderSide.none,
              ),
        focusedBorder: showBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: isMaxed
                      ? Theme.of(context)
                          .inputDecorationTheme
                          .errorStyle!
                          .color!
                      : Theme.of(context).primaryColor,
                ),
                borderRadius: borderRadius ?? AppBorders.roundedBorder5,
              )
            : OutlineInputBorder(
                borderRadius: borderRadius ?? AppBorders.roundedBorder5,
                borderSide: BorderSide.none,
              ),
        enabledBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: borderRadius ?? AppBorders.roundedBorder5,
                borderSide:
                    Theme.of(context).inputDecorationTheme.border!.borderSide,
              )
            : OutlineInputBorder(
                borderRadius: borderRadius ?? AppBorders.roundedBorder5,
                borderSide: BorderSide.none,
              ),
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        fillColor: fillColor,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
