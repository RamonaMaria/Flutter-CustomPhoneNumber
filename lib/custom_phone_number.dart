library custom_phone_number;

import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneNumber extends StatefulWidget {
  final ValueChanged<PhoneNumberObject> onFieldSubmitted;
  FormFieldValidator<String> validator;
  final String defaultCountry;
  final String placeholder;
  final String message;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  PhoneNumber(
      {this.onFieldSubmitted,
      @required this.defaultCountry,
      this.validator,
      this.placeholder,
      this.message,
      this.controller,
      this.formKey});

  @override
  State<StatefulWidget> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  var data = Map<String, dynamic>();

//  final formKey = GlobalKey<FormState>();
  PhoneNumberObject _phoneNumber = new PhoneNumberObject();

  @override
  void initState() {
    data['country'] = getCountryPrefix(widget.defaultCountry);
  }

  _PhoneNumberState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: new EdgeInsets.all(6.0),
        child: Form(
            autovalidate: false,
            key: widget.formKey,
            child: Center(
                child: ListView(shrinkWrap: true, children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: CountryCodePicker(
                      onChanged: (value) {
                        this.data["country_prefix"] = value.dialCode;
                      },
                      initialSelection: getCountryPrefix(widget.defaultCountry),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: TextFormField(
                        maxLength: 20,
                        decoration:
                            InputDecoration(hintText: widget.placeholder),
                        keyboardType: TextInputType.phone,
                        controller: widget.controller,
                        validator: widget.validator,
                        onSaved: (String value) {
                          data['phone_number'] = value;
                          _phoneNumber.phoneNumber = value;
                          _phoneNumber.phoneCode = data['country_prefix'];
                          widget.onFieldSubmitted(_phoneNumber);
                        },
                      )),
                ],
              ),
              Text(widget.message),
            ]))));
  }

  getCountryPrefix(String countryPrefix) {
    if (countryPrefix.isEmpty) {
      Locale myLocale = Localizations.localeOf(context);
      return myLocale.countryCode;
    }

    return countryPrefix;
  }
}

class PhoneNumberObject {
  String phoneCode;
  String phoneNumber;
}
