import 'package:event/components/delegatedText.dart';
import 'package:flutter/material.dart';
import '../utils/constant.dart';

// ignore: must_be_immutable
class DelegatedForm2 extends StatefulWidget {
  final String hintText;
  final TextEditingController? formController;
  final String? Function(String?)? validator;
  final keyboardInputType;
  final int? maxLines;

  DelegatedForm2({
    required this.hintText,
    this.keyboardInputType,
    this.formController,
    this.validator,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  @override
  State<DelegatedForm2> createState() => _DelegatedForm2State();
}

bool passToggle = true;

class _DelegatedForm2State extends State<DelegatedForm2> {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: TextFormField(
            keyboardType: widget.keyboardInputType,
            maxLines: widget.maxLines,
            validator: widget.validator,
            controller: widget.formController,
            style: const TextStyle(
              fontSize: 15,
            ),
            decoration: InputDecoration(
              errorText: errorText,
              filled: true,
              fillColor: Constants.basicColor,
              hintText: widget.hintText,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Constants.tertiaryColor,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Constants.tertiaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DefaultTextFormField extends StatefulWidget {
  final String? hintText;
  final double? fontSize;
  final IconData? icon;
  final Widget? suffixIcon;
  final TextEditingController? text;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool? enabled;
  final bool? readOnly;
  final int? maxLines;
  final String? label;
  final Color? fillColor;
  final keyboardInputType;
  final Function()? onTap;

  const DefaultTextFormField(
      {Key? key,
      this.hintText,
      this.text,
      this.icon,
      this.suffixIcon,
      // required this.onSaved,
      this.validator,
      this.keyboardInputType,
      this.maxLines,
      required this.obscureText,
      this.fontSize,
      this.enabled,
      this.label,
      this.onSaved,
      this.fillColor,
      this.onTap,
      this.readOnly})
      : super(key: key);

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      controller: widget.text,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardInputType,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: Colors.black),
        ),
        // fillColor: Colors.white,
        fillColor: widget.fillColor,
        filled: true,
        label: DelegatedText(fontSize: 18.0, text: "${widget.label}"),
        labelStyle: const TextStyle(color: Constants.tertiaryColor),
        iconColor: Constants.primaryColor,
        prefixIcon: Icon(widget.icon),
        prefixIconColor: Constants.primaryColor,
        suffixIcon: widget.suffixIcon,
        // hintText: widget.hintText,
      ),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: widget.fontSize,
      ),
    );
  }
}
