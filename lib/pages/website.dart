import 'package:avalon_manage/scoped-models/registrations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WebsiteListPage extends StatefulWidget {
  final RegistrationModel model;
  WebsiteListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _WebsiteListPageState();
  }
}

class _WebsiteListPageState extends State<WebsiteListPage> {
  @override
  void initState() {
    this.widget.model.websiteRegistrations();
    super.initState();
  }

  Widget _buildRegistrationsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, RegistrationModel model) {
        Widget content = CircularProgressIndicator();
        //model.webRegistrations.length > 0 &&
        if (model.webRegistrations.length > 0 && !model.isLoading) {
          content = Container(
              child: ListView.builder(
            itemCount: model.webRegistrations.length,
            itemBuilder: (BuildContext context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blueGrey,
                  child: Card(
                      color:
                          //model.webRegistrations[i].closed ? Colors.cyan :
                          Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            model.webRegistrations[i].avalonMember != null
                                ? Text(
                                    model.webRegistrations[i].avalonMember
                                            .toUpperCase() +
                                        ": Rs. " +
                                        model.webRegistrations[i].paid
                                            .toString(),
                                    textScaleFactor: 1.6,
                                  )
                                : Container(),
                            Text(
                              model.webRegistrations[i].teamName,
                              textScaleFactor: 1.4,
                            ),
                            model.isLoading
                                ? CircularProgressIndicator()
                                : model.webRegistrations[i].closed == null
                                    ? Text("No payment for this registration")
                                    : model.webRegistrations[i].closed == true
                                        ? Text("Amount has been recieved")
                                        : RaisedButton(
                                            color: Colors.red,
                                            child: Text(
                                              "Recieved",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              _showDialog(model, i);
                                            },
                                          )
                          ],
                        ),
                      )),
                ),
              );
            },
          ));
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: model.websiteRegistrations,
          child: content,
        );
      },
    );
  }

  void _showDialog(RegistrationModel model, int i) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Please confirm!"),
          content: new Text("Have you recieved Rs." +
              model.webRegistrations[i].paid.toString() +
              "\nfrom " +
              model.webRegistrations[i].avalonMember +
              "\nagainst the team name " +
              model.webRegistrations[i].teamName +
              " ?\nNote: You cannot undo this action"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes, I have!"),
              onPressed: () {
                model
                    .closeWebRegistration(model.webRegistrations[i].teamName)
                    .then((value) {
                  Navigator.pop(context);
                  setState(() {
                    model.webRegistrations[i].closed = true;
                  });
                });
              },
            ),
            new FlatButton(
              child: new Text("No, I have not!"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RegistrationModel>(
      builder: (BuildContext context, Widget child, RegistrationModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                "Website [" + model.webRegistrations.length.toString() + "]"),
          ),
          body: _buildRegistrationsList(),
        );
      },
    );
  }
}
