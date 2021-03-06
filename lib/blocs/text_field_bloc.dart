import 'dart:io';

import 'package:flutter/cupertino.dart';

/// [TextFieldBloc] holds in memory all of the data for all of the textfields.
///
/// It's purpose is to keep the text in each text field even when you leave a conversation
/// so that when you re-enter, the text will still be there
///
/// This class is a singleton
class TextFieldBloc {
  factory TextFieldBloc() {
    return _chatBloc;
  }

  static final TextFieldBloc _chatBloc = TextFieldBloc._internal();

  TextFieldBloc._internal();

  Map<String, TextFieldData> _textFields = new Map();

  TextFieldData getTextField(String chatGuid) {
    if (_textFields.containsKey(chatGuid)) {
      return _textFields[chatGuid];
    } else {
      _textFields[chatGuid] = new TextFieldData();
      _textFields[chatGuid].controller = new TextEditingController();
      return _textFields[chatGuid];
    }
  }
}

/// [TextFieldData] holds a TextEditingController and a list of strings that link to attachments
class TextFieldData {
  TextEditingController controller;
  List<File> attachments = [];
}
