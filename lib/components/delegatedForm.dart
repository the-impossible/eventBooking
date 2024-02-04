import 'package:event/components/delegatedText.dart';
import 'package:flutter/material.dart';
import '../utils/constant.dart';

// ignore: must_be_immutable
class DelegatedForm extends StatefulWidget {
  final String fieldName;
  final IconData icon;
  final String hintText;
  final bool isSecured;
  bool isVisible;
  final TextEditingController? formController;
  final String? Function(String?)? validator;

  DelegatedForm({
    required this.fieldName,
    required this.icon,
    required this.hintText,
    required this.isSecured,
    required this.isVisible,
    this.formController,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<DelegatedForm> createState() => _DelegatedFormState();
}

bool passToggle = true;

class _DelegatedFormState extends State<DelegatedForm> {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              Icon(widget.icon),
              const SizedBox(width: 15),
              DelegatedText(
                text: widget.fieldName,
                fontSize: 15,
                fontName: 'InterMed',
              ),
              const Spacer(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: TextFormField(
            obscureText: widget.isSecured ? passToggle : widget.isSecured,
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
              suffix: Visibility(
                visible: widget.isVisible,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      passToggle = !passToggle;
                    });
                  },
                  child: Icon(
                      passToggle ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: Constants.secondaryColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: Constants.secondaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
