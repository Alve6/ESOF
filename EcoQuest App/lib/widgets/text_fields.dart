import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';


import '../helper/size_config.dart';


class TextFieldLabelTop extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController textController;
  late final bool obscureText;

  TextFieldLabelTop(this.label, this.hintText, this.textController, [bool? obscure]){
    obscureText = obscure ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(
            fontSize: SizeConfig.heightPercentage(1.6),
          ),
        ),

        TextField(
          controller: textController,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.heightPercentage(1.8), horizontal: SizeConfig.widthPercentage(4)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2
              ),
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}


class TextFieldLabelInside extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController textController;
  late final bool obscureText;

  TextFieldLabelInside(this.label, this.hintText, this.textController, [bool? obscure]){
    obscureText = obscure ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: textController,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.heightPercentage(1.8), horizontal: SizeConfig.widthPercentage(4)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2
              ),
            ),
            labelText: label,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}


class ElevatedTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  late final double? height, width;

  ElevatedTextField(this.hintText, this.textController, {double? height, double? width}) {
    this.height = height ?? 56;
    this.width = width ?? 16;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: TextField(
            style: TextStyle(
              fontSize: height!/3.3,
            ),
            controller: textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: height!/5, horizontal: width!/1.6),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white,
                    width: 0
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white,
                    width: 0
                ),
              ),
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneInputField extends StatelessWidget {
  final String hintText;
  final GlobalKey<FormState> formKey;
  final Function(PhoneNumber) onChanged;
  late final double? height, width;

  PhoneInputField(this.hintText, this.formKey, this.onChanged, {double? height, double? width}) {
    this.height = height ?? 56;
    this.width = width ?? SizeConfig.screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        padding: EdgeInsets.only(top: height!/2.2, bottom: height!/9),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: IntlPhoneField(
            flagsButtonPadding: EdgeInsets.only(bottom: height!/15),
            style: TextStyle(fontSize: height!/3.3),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (phone) {
              onChanged(phone);
            },
            initialCountryCode: 'PT',
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: width!/30),
              hintText: hintText,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  late final double height, width;

  DatePickerField(this.controller, this.hintText, {double? height, double? width}) {
    this.height = height ?? 56;
    this.width = width ?? SizeConfig.screenWidth;
  }

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      widget.controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Container(
        padding: EdgeInsets.only(top: widget.height/13, right: widget.width/100),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          style: TextStyle(fontSize: widget.height / 3.3),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: widget.width/26),
            hintText: widget.hintText,
            border: OutlineInputBorder(borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
