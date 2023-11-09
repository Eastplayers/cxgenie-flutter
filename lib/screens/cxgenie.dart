import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/app_provider.dart';
import 'package:cxgenie/widgets/app_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CXGenie extends StatefulWidget {
  const CXGenie({
    Key? key,
    required this.botId,
    this.userToken,
    this.language = LanguageOptions.en,
  }) : super(key: key);

  final String botId;
  final String? userToken;
  final LanguageOptions? language;

  @override
  _CXGenie createState() => _CXGenie();
}

class _CXGenie extends State<CXGenie> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: AppContainer(
        botId: widget.botId,
        userToken: widget.userToken,
        language: widget.language,
      ),
    );
  }
}
