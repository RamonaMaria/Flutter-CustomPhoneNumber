library custom_phone_number;

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';

/// A IntroScreen Class.

class PhoneNumber extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFieldSubmitted;
  FormFieldValidator<String> validator;
  final String defaultCountry;
  final String placeholder;
  final String initialValue;
  final String message;

  PhoneNumber(
      {this.onFieldSubmitted,
        @required this.defaultCountry,
        this.validator,
        this.placeholder,
        this.initialValue,
        this.message});

  @override
  State<StatefulWidget> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  var data = Map<String, dynamic>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    data['country'] =
        CountryPickerUtils.getCountryByIsoCode(widget.defaultCountry);
  }

  _PhoneNumberState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: new EdgeInsets.all(6.0),
        child: Form(
            autovalidate: false,
            key: formKey,
            child: Center(
                child: ListView(shrinkWrap: true, children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: CountryPickerDropdown(
                          initialValue: widget.defaultCountry,
                          itemBuilder: _buildDropdownItem,
                          onValuePicked: (Country country) {
                            data['country'] = country;
                          },
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: TextFormField(
                            maxLength: 20,
                            decoration:
                            InputDecoration(hintText: widget.placeholder),
                            keyboardType: TextInputType.phone,
                            initialValue: widget.initialValue,
                            validator: widget.validator,
                            onFieldSubmitted: (String value) {
                              if (formKey.currentState.validate()) {
                                data['phone_number'] = value;
                                widget.onFieldSubmitted(data);
                              }
                            },
                          )),
                    ],
                  ),
                  Text(widget.message),
                ]))));
  }

  Widget _buildDropdownItem(Country country) => Container(
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("+${country.phoneCode}(${country.isoCode})"),
      ],
    ),
  );
}
