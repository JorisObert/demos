import 'dart:ui';

import 'package:collection/src/iterable_extensions.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/hashtag.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class CreatePoolScreen extends StatefulWidget {
  CreatePoolScreen({Key? key}) : super(key: key);


  @override
  State<CreatePoolScreen> createState() => _CreatePoolScreenState();
}

class _CreatePoolScreenState extends State<CreatePoolScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  int _nbrChoices = 2;

  List<bool> isSelected = [true, false];

  TextStyle _sectionTitleStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  late String _userCountryCode;

  bool _isPrivate = false;

  bool _isAnonymous = true;

  late TextEditingController _hashtagsInputController;

  @override
  void initState() {
    _userCountryCode = 'FR';
    _hashtagsInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _hashtagsInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppIcon(),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Create your pool',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  //IconButton(onPressed: widget.onClosed, icon: Icon(Icons.close)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Title',
                style: _sectionTitleStyle,
              ),
            ),
            FormBuilderTextField(
              name: 'title',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0)),
              onChanged: (_) {

              },
              // valueTransformer: (text) => num.tryParse(text),
              /*validator: FormBuilderValidators.compose([
                FormBuilderValidators.
              ]),*/
              maxLines: 5,
              minLines: 1,
              maxLength: 170,
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Choices',
                style: _sectionTitleStyle,
              ),
            ),
            ListView.builder(
              itemCount: _nbrChoices,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'choice$index',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0)),
                        // valueTransformer: (text) => num.tryParse(text),
                        /* validator: FormBuilderValidators.compose([

              ]),*/
                        maxLines: 1,
                        maxLength: 40,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    index < (_nbrChoices - 1)
                        ? IconButton(
                            icon: Icon(Icons.add_circle),
                            onPressed: () {},
                            color: Colors.transparent,
                          )
                        : _addChoiceButton()
                  ],
                );
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            _privacySwitch(),
            _isPrivate ? Column(
              children: [
                SizedBox(
                  height: 16.0,
                ),
                _anonymousSwitch()
              ],
            ):SizedBox.shrink(),
            SizedBox(
              height: 16.0,
            ),
            _hashtags(),
            SizedBox(
              height: 16.0,
            ),
            _endDate(),
            SizedBox(
              height: 16.0,
            ),
            _countryChoser(),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
                onPressed: () {
                  print(_formKey.currentState);
                  _formKey.currentState?.save();
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    Pool pool = Pool(
                      title: _formKey.currentState?.value['title'],
                      userId: context.read<DemosUserProvider>().firebaseUser!.uid,
                      countryCode: _userCountryCode,
                      isPrivate: false,
                      user: context.read<DemosUserProvider>().user,
                    );

                    var choices = _createMapFromChoices;
                    var hashtags = _createListFromHashtags;
                    context.read<PoolProvider>().createPool(pool: pool, choices: choices, hashtags: hashtags);
                  } else {
                    print('Invalid');
                  }
                },
                child: Text('Create'))
          ],
        ),
      ),
    );
  }

  List<Choice> get _createMapFromChoices {
    List<Choice> choices = [];
    for (int i = 0; i < _nbrChoices; i++) {
      choices.add(Choice(title: _formKey.currentState?.value['choice$i']));
    }
    return choices;
  }

  List<Hashtag> get _createListFromHashtags {
    List<Hashtag> hashtags = [];
    List<String> hashString = _formKey.currentState?.value['hashtags']?.toString().split(' ') ?? [];
    for (int i = 0; i < hashString.length; i++) {
      hashtags.add(Hashtag(title: hashString[i]));
    }
    return hashtags;
  }

  Widget _addChoiceButton() {
    return IconButton(
      icon: Icon(Icons.add_circle),
      onPressed: () {
        setState(() {
          _nbrChoices++;
        });
      },
    );
  }

  Widget _privacySwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'public',
              style: _sectionTitleStyle,
            ),
            Switch(
                value: _isPrivate,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,

                onChanged: (value) {
                  setState(() {
                    _isPrivate = value;
                  });
                }),
            Text(
              'private',
              style: _sectionTitleStyle,
            ),
          ],
        ),
        Text(_isPrivate
            ? 'Only people with a link will be able to vote'
            : 'Everyone can see your pool'),
      ],
    );
  }

  Widget _anonymousSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [

            Switch(
                value: _isAnonymous,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                }),
            Text(
              'anonymous',
              style: _sectionTitleStyle,
            ),
          ],
        ),
        Text(_isAnonymous
            ? 'Votes are anonymous'
            : 'Names of votants will be known'),
      ],
    );
  }

  Widget _countryChoser() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Location',
          style: _sectionTitleStyle,
        ),
      ),
      CountryPickerDropdown(
          initialValue:
              CountryPickerUtils.getCountryByIsoCode(_userCountryCode).isoCode,
          itemBuilder: _buildDropdownItem,
          onValuePicked: (Country country) => setState(() {
                _userCountryCode = country.isoCode;
              })),
    ]);
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("${country.isoCode}"),
          ],
        ),
      );

  Widget _endDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Select an end date for your pool',
            style: _sectionTitleStyle,
          ),
        ),
        FormBuilderDateTimePicker(
          name: 'end_date',
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          format: DateFormat('yyyy-MM-dd'),
          onChanged: (date) => print(date),
        ),
      ],
    );
  }

  Widget _hashtags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Hashtags',
            style: _sectionTitleStyle,
          ),
        ),
        FormBuilderTextField(
          name: 'hashtags',
          controller: _hashtagsInputController,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)),
          onChanged: (text) {

          },
          // valueTransformer: (text) => num.tryParse(text),
          /*validator: FormBuilderValidators.compose([
                  FormBuilderValidators.
                ]),*/
          maxLines: 5,
          minLines: 1,
          maxLength: 170,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
