import 'dart:ui';

import 'package:collection/src/iterable_extensions.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:demos/components/app_icon.dart';
import 'package:demos/models/demos_user.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class CreatePoolDialog extends StatefulWidget {
  CreatePoolDialog({Key? key, required this.onClosed}) : super(key: key);

  final VoidCallback onClosed;

  @override
  State<CreatePoolDialog> createState() => _CreatePoolDialogState();
}

class _CreatePoolDialogState extends State<CreatePoolDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  int _nbrChoices = 2;

  List<bool> isSelected = [true, false];

  TextStyle _sectionTitleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  late String _userCountryCode;

  bool _isPrivate = false;

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
    return LimitedBox(
      maxHeight: MediaQuery.of(context).size.height - 200,
      child: Padding(
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
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                onChanged: (_) => print('cool'),
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
                child: Text('Choices',
                  style: _sectionTitleStyle,),
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
                          onChanged: (_) => print('cool'),
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
                              onPressed: (){},
                              color: Colors.transparent,
                            )
                          : _addChoiceButton()
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0,),
              _privacySwitch(),
              SizedBox(height: 16.0,),
              _hashtags(),
              SizedBox(height: 16.0,),
              _endDate(),
              SizedBox(height: 16.0,),
              _countryChoser(),
              SizedBox(height: 16.0,),
              ElevatedButton(
                  onPressed: () {
                    print(_formKey.currentState);
                    _formKey.currentState?.save();
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      Pool pool = Pool(
                          title: _formKey.currentState?.value['title'],
                          choices: _createMapFromChoices!,
                        countryCode: _userCountryCode,
                        endDate: _formKey.currentState?.value['end_date'] as DateTime,
                        hashtags: _formKey.currentState?.value['hashtags'].toString().split(' '),
                        creator: DemosUser(name: 'Joris Obert', countryCode: 'fr', profilePicURL: 'https://scontent-cdt1-1.xx.fbcdn.net/v/t1.18169-9/11109810_10205447319595079_5685582881904717067_n.jpg?_nc_cat=103&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=FJPiY5AQMZoAX_CBziQ&_nc_ht=scontent-cdt1-1.xx&oh=d96f879396f1fb56c2f4769cec2566f4&oe=6197155F'),
                      );

                      context.read<PoolProvider>().createPool(pool);
                    } else {
                      print('Invalid');
                    }
                  },
                  child: Text('Create'))
            ],
          ),
        ),
      ),
    );
  }

  Map<String,int>? get _createMapFromChoices{
    Map<String,int> map = {};
    for(int i = 0; i<_nbrChoices; i++){
      map[_formKey.currentState?.value['choice$i']] = 0;
    }
    return map;
  }

  Widget _addChoiceButton(){
    return IconButton(
        icon: Icon(Icons.add_circle),
        onPressed: (){
          setState(() {
            _nbrChoices++;
          });
        },
    );
  }

  Widget _privacySwitch(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('public', style: _sectionTitleStyle,),
            Switch(value: _isPrivate, onChanged: (value){
              setState(() {
                _isPrivate = value;
              });
            }),
            Text('private', style: _sectionTitleStyle,),
          ],
        ),
        Text(_isPrivate ? 'You\'ll be able to share your pool with a link':'Everyone can see your pool'),
      ],
    );
  }

  Widget _countryChoser(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Location', style: _sectionTitleStyle,),
        ),
    CountryPickerDropdown(
    initialValue: CountryPickerUtils.getCountryByIsoCode(_userCountryCode).isoCode,
    itemBuilder: _buildDropdownItem,
    onValuePicked: (Country country) => setState(() {
      _userCountryCode = country.isoCode;
    })),]

    );
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

  Widget _endDate(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Select an end date for your pool', style: _sectionTitleStyle,),
        ),

        FormBuilderDateTimePicker(
          name: 'end_date',
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          format: DateFormat('yyyy-MM-dd'),
          onChanged: (date)=>print(date),

        ),
      ],
    );
  }

  Widget _hashtags(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Hashtags', style: _sectionTitleStyle,),
        ),
        FormBuilderTextField(
          name: 'hashtags',
          controller: _hashtagsInputController,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0)),
          onChanged: (text){
            if(text != null && text.length > 0 ){
              var splitted = text.split(' ');
              
              String? lastWord = splitted.lastWhereOrNull((element) => element.isNotEmpty);
              if (lastWord != null && text.endsWith(' ') && !lastWord.startsWith('#')) {
                print(text.substring(0, text.indexOf(lastWord)) + ' #$lastWord');

                  _hashtagsInputController.text =
                      text.substring(0, text.indexOf(lastWord)) + ' #$lastWord';

              }
            }
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
