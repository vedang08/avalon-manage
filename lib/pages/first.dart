import 'package:avalon_manage/pages/pending.dart';
import 'package:avalon_manage/pages/registration_list.dart';
import 'package:avalon_manage/pages/today.dart';
import 'package:avalon_manage/pages/website.dart';
import 'package:avalon_manage/scoped-models/registrations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return ScopedModelDescendant<RegistrationModel>(
      builder: (BuildContext context, Widget child, RegistrationModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Options",
            ),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.all(_height * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_height * 0.04),
                  ),
                  child: Text("All Offline Registrations"),
                  onPressed: () {
                    return Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return RegistrationListPage(model);
                    }));
                  },
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(_height * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_height * 0.04),
                  ),
                  child: Text("Pending Registrations"),
                  onPressed: () {
                    return Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return PendingListPage(model);
                    }));
                  },
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(_height * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_height * 0.04),
                  ),
                  child: Text("Today's Registrations"),
                  onPressed: () {
                    return Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TodayListPage(model);
                    }));
                  },
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(_height * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_height * 0.04),
                  ),
                  child: Text("Website Registrations"),
                  onPressed: () {
                    return Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return WebsiteListPage(model);
                    }));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
