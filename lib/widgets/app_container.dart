import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/app_provider.dart';
import 'package:cxgenie/widgets/contact_information.dart';
import 'package:cxgenie/widgets/messages.dart';
import 'package:cxgenie/widgets/ticket_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({
    Key? key,
    required this.botId,
    this.userToken,
    this.language = LanguageOptions.en,
  }) : super(key: key);

  final String botId;
  final String? userToken;
  final LanguageOptions? language;

  @override
  AppContainerState createState() => AppContainerState();
}

class AppContainerState extends State<AppContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context, listen: false)
          .getBotDetail(widget.botId, widget.userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, value, child) {
      final bot = value.bot;
      String color = bot.themeColor!.replaceAll("#", "0xff");
      final customer = value.customer;

      return SizedBox(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.height),
          child: Container(
            child: value.isLoading
                ? const SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffD6DAE1),
                      ),
                    ),
                  )
                : customer == null
                    ? ContactInformation(
                        botId: widget.botId,
                        themeColor: Color(int.parse(color)),
                        language: widget.language,
                      )
                    : bot.isTicketEnable == true
                        ? TicketContainer(
                            workspaceId: "${bot.workspaceId}",
                            customerId: customer.id,
                            themeColor: bot.themeColor,
                            language: widget.language,
                          )
                        : Messages(
                            customerId: customer.id,
                            botId: widget.botId,
                            themeColor: "${bot.themeColor}",
                            language: widget.language,
                          ),
          ));
    });
  }
}
