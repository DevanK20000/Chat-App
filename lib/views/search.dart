import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    height: 45,
                    child: TextField(
                      controller: searchTextEditingController,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        labelText: "Search for your friends",
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
