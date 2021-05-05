import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/services/storage.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DataBaseMethod _dataBaseMethod = new DataBaseMethod();
  AuthMethod _authMethod = new AuthMethod();
  StorageMethod _storageMethod = new StorageMethod();
  DefaultCacheManager _cacheManager = new DefaultCacheManager();
  final formLogInKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();

  File _image;
  var _imageU8;
  String _imageurl;
  final picker = ImagePicker();

  @override
  void initState() {
    _initVales();
    super.initState();
  }

  _initVales() {
    usernameTextEditingController.text = Constants.myName;
    bioTextEditingController.text = Constants.bio;
  }

  _updatePRofile() async {
    if (formLogInKey.currentState.validate()) {
      if (_image != null || _imageU8 != null) {
        kIsWeb != true
            ? _storageMethod.uploadImage(_image).then((ref) {
                _storageMethod.downloadURL().then((uri) {
                  _imageurl = uri;
                  Map<String, String> _updateInfoMap = {
                    "user": usernameTextEditingController.text,
                    "imageurl": _imageurl,
                    "bio": bioTextEditingController.text
                  };
                  _authMethod.addAditionalData(
                      usernameTextEditingController.text, _imageurl);
                  _dataBaseMethod.updateProfile(_updateInfoMap).then((value) {
                    setState(() {
                      Constants.myName = usernameTextEditingController.text;
                      Constants.bio = bioTextEditingController.text;
                      Constants.imageUrl = _imageurl;
                    });
                    HelperFunctions.saveUserNameSharedPreference(
                        usernameTextEditingController.text);
                    _cacheManager.emptyCache();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  });
                });
              })
            : _storageMethod.uploadImageU8(_imageU8).then((ref) {
                _storageMethod.downloadURL().then((uri) {
                  _imageurl = uri;
                  Map<String, String> _updateInfoMap = {
                    "user": usernameTextEditingController.text,
                    "imageurl": _imageurl,
                    "bio": bioTextEditingController.text
                  };
                  _authMethod.addAditionalData(
                      usernameTextEditingController.text, _imageurl);
                  _dataBaseMethod.updateProfile(_updateInfoMap).then((value) {
                    setState(() {
                      Constants.myName = usernameTextEditingController.text;
                      Constants.bio = bioTextEditingController.text;
                      Constants.imageUrl = _imageurl;
                    });
                    HelperFunctions.saveUserNameSharedPreference(
                        usernameTextEditingController.text);
                    _cacheManager.emptyCache();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  });
                });
              });
      }
    } else {
      if (Constants.myName != usernameTextEditingController.text ||
          Constants.bio != bioTextEditingController.text) {
        Map<String, String> _updateInfoMap = {
          "user": usernameTextEditingController.text,
          "bio": bioTextEditingController.text
        };
        _dataBaseMethod.updateProfile(_updateInfoMap).then((value) {
          setState(() {
            Constants.myName = usernameTextEditingController.text;
            Constants.bio = bioTextEditingController.text;
          });
          HelperFunctions.saveUserNameSharedPreference(
              usernameTextEditingController.text);

          Navigator.popUntil(context, (route) => route.isFirst);
        });
      }
    }
  }

  Future getImage(bool fromCamera) async {
    if (kIsWeb != true) {
      final pickedFile = await picker.getImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 600,
          maxWidth: 600);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } else {
      FilePickerResult _result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      setState(() {
        if (_result != null) {
          _imageU8 = _result.files.single.bytes;
        } else {
          print('No image selected. web');
        }
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(false);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(true);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, 'Edit'),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 12),
              Center(
                child: Hero(
                  tag: 'profile',
                  child: GestureDetector(
                    onTap: () => _showPicker(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: CircleAvatar(
                          // backgroundColor: Colors.white,
                          radius: 30,
                          child: Constants.imageUrl == "" ||
                                  Constants.imageUrl == null
                              ? Icon(Icons.person_outline_sharp)
                              : SizedBox(
                                  height: 147,
                                  width: 147,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      fit: StackFit.expand,
                                      children: [
                                        _image != null || _imageU8 != null
                                            ? kIsWeb != true
                                                ? Image.file(
                                                    _image,
                                                    fit: BoxFit.fitWidth,
                                                  )
                                                : Image.memory(
                                                    _imageU8,
                                                    fit: BoxFit.fitWidth,
                                                  )
                                            : CachedNetworkImage(
                                                imageUrl: Constants.imageUrl,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                fit: BoxFit.fitWidth,
                                              ),
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.5),
                                          radius: 30,
                                        ),
                                        Icon(Icons.edit_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formLogInKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      validator: (val) => val.isEmpty || val.length < 4
                          ? 'Plese provide an valid username'
                          : null,
                      controller: usernameTextEditingController,
                      maxLength: 16,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Change Username',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) => val.isEmpty || val.length < 4
                          ? 'Bio should be more than 4 letters'
                          : null,
                      controller: bioTextEditingController,
                      maxLength: 100,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bio',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _updatePRofile,
                      child: Text("Update Profile"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
