import 'package:flutter/material.dart';
import 'package:liderfacilites/main.dart';
import 'package:liderfacilites/models/app_localization.dart';
import 'package:liderfacilites/models/setting.dart';
import 'package:liderfacilites/screens/editInfo.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FourthPageState();
  }
}

class FourthPageState extends State<FourthPage> {
  TextStyle listTileTitle = TextStyle(color: Colors.black);
  var languages = ['English', 'Portuguese'];
  String language = 'English';
  Setting setting = new Setting();

  @override
  void initState() {
    language = setting.getLanguage();
    print('lan: '+language);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 248, 250, 1),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              uperPart(),
              bottomPart(),
            ],
          ),
        ),
      ),
    );
  }

  uperPart() {
    return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
                color: Color.fromRGBO(26, 119, 186, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: <Widget>[
                logoutTXT(),
                profileImage(),
                userNameTXT(),
                userNumberTxt(),
                editButton(),
              ],
            ),
          ),
        ));
  }

  logoutTXT() {
    return GestureDetector(
        onTap: () {
          print('logout');
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 15, top: 15),
          child: Align(
            alignment: Alignment.topRight,
            child: Text('Logout',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));
  }

  profileImage() {
    String _imageUrl;
    return CircleAvatar(
      radius: 35,
      // backgroundColor: Colors.black,
      child:_imageUrl == null ? Image.asset('assets/images/account.png',)
                :Image.network(_imageUrl,fit: BoxFit.cover),
      // backgroundImage: AssetImage('icons/default_profile_idcon.png'),
      // backgroundImage: AssetImage('assets/images/account.png'),
      // child: FadeInImage(image: Image.network(url)),
    );
  }

  userNameTXT() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text('Abdullah khan',
          style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }

  userNumberTxt() {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text('03441549512',
            style: TextStyle(color: Colors.white, fontSize: 18)));
  }

  editButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: OutlineButton(
        onPressed: () {
          navigateToEditPage();
        },
        borderSide: BorderSide(color: Colors.white),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            AppLocalizations.of(context).translate('EditInfo'),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  //bottom part implementation
  bottomPart() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 15, top: 7),
                  child: ListTile(
                    leading: CircleAvatar(
                      // radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.account_circle,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('My Services'),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: CircleAvatar(
                    // radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.payment,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('My Payments'),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: CircleAvatar(
                    // radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.language,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  title: languageDropDown(),
                  // Text(
                  //   AppLocalizations.of(context).translate('Language'),
                  //   style: TextStyle(color: Colors.black),
                  // ),
                ),
              ],
            ),
          ),
        ));
  }

  languageDropDown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      items: languages.map((String dropDownStringItem) {
        return DropdownMenuItem(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          language = value;
          Locale newLocale;
          if (language == 'English') {
            newLocale = Locale('en', 'EN');
          } else {
            newLocale = Locale('pt', 'BR');
          }
          MyApp.setLocale(context, newLocale);
          setting.setLanguageToSP(value);
        });
      },
      value: language,
    ));
  }

  navigateToEditPage(){
    Navigator.push(context,
            MaterialPageRoute(builder: (context) {
          return EditInfo();
        }));
  }
}
