import 'package:flutter/material.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Widgets/ConatctItem.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  static const routname = '/conntacts';
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Contactsdata contactsdata;
  bool isloading = false;
  bool isinit = true;
  bool isinvcontacts = false;
  String ideaid;
  String title;

  @override
  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });
      final data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (data != null) {
        isinvcontacts = data['inv'];
        ideaid = data['ideaid'];
        title = data['title'];
      }

      if (isinvcontacts) {
        contactsdata = Provider.of<Contactsdata>(context);
        contactsdata.getinvcontacts(ideaid).then((value) {
          setState(() {
            isloading = false;
          });
        });
      } else {
        contactsdata = Provider.of<Contactsdata>(context);
        contactsdata.getcontacts(false).then((value) {
          setState(() {
            isloading = false;
          });
        }).catchError((error) {
          setState(() {
            isloading = false;
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No Internet Connection')));
        });
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        drawer: Drawers(),
        body: isloading
            ? Center(child: CircularProgressIndicator())
            : isinvcontacts
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: contactsdata.invcontacts.length,
                    itemBuilder: (ctx, idx) {
                      return ContactItem(
                        contactid: contactsdata.invcontacts[idx].userid,
                        name: contactsdata.invcontacts[idx].name,
                        url: contactsdata.invcontacts[idx].url,
                        gender: contactsdata.invcontacts[idx].gender,
                      );
                    })
                : RefreshIndicator(
                    onRefresh: () async{
                      await contactsdata.getcontacts(true);
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Expanded(
                          child: 
                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: contactsdata.contacts.length,
                              itemBuilder: (ctx, idx) {
                                return ContactItem(
                                  contactid: contactsdata.contacts[idx].userid,
                                  name: contactsdata.contacts[idx].name,
                                  url: contactsdata.contacts[idx].url,
                                  gender: contactsdata.contacts[idx].gender,
                                );
                              }),
                       ),
                      ],
                    ),
                  ));
  }
}
