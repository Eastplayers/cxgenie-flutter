import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/chat_provider.dart';
import 'package:cxgenie/screens/contact_information.dart';
import 'package:cxgenie/screens/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      required this.virtualAgentId,
      this.userToken,
      this.showChatWithAgent = false,
      this.language = LanguageOptions.en,
      this.onChatWithAgentClick})
      : super(key: key);

  final String virtualAgentId;
  final String? userToken;
  final bool? showChatWithAgent;
  final LanguageOptions? language;
  final Function(String userId, String workspaceId, String themeColor)?
      onChatWithAgentClick;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false)
          .getVirtualAgentDetail(widget.virtualAgentId, widget.userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, value, child) {
      final virtualAgent = value.virtualAgent;
      String color = virtualAgent.themeColor.replaceAll("#", "0xff");
      final customer = value.customer;
      var supportIcon = '''
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M12.9312 22.5031H13.5212V22.4931C13.9513 22.4931 14.3712 22.3631 14.7212 22.1131C15.0612 21.8731 15.3113 21.5531 15.4613 21.1731H15.7712C17.7113 21.1731 19.3612 19.6531 19.5513 17.7131C20.1213 17.4531 20.6012 17.0331 20.9513 16.5031C21.3013 15.9531 21.4912 15.3231 21.4912 14.6731V10.9331C21.4912 8.40312 20.5013 6.02312 18.7113 4.23312C16.9213 2.44314 14.5412 1.45312 12.0112 1.45312C6.78125 1.45312 2.53125 5.70312 2.53125 10.9431V14.6831C2.53125 15.5731 2.88125 16.4231 3.51125 17.0531C4.14125 17.6831 4.98125 18.0331 5.88125 18.0331H6.05125C6.55125 18.0331 7.01125 17.8431 7.36125 17.4931C7.71125 17.1431 7.90125 16.6831 7.90125 16.1831V12.2231C7.90125 11.7231 7.71125 11.2631 7.36125 10.9131C7.01125 10.5631 6.54125 10.3731 6.05125 10.3731H5.88125C5.24125 10.3731 4.62125 10.5631 4.08125 10.9131C4.09125 6.55312 7.66125 3.00312 12.0212 3.00312C16.3813 3.00312 19.9412 6.55312 19.9513 10.9131C19.4212 10.5631 18.8013 10.3731 18.1512 10.3731H17.9812C17.4913 10.3731 17.0113 10.5731 16.6713 10.9131C16.3212 11.2631 16.1313 11.7331 16.1313 12.2231V16.1831C16.1313 16.6831 16.3212 17.1431 16.6713 17.4931C17.0013 17.8231 17.4612 18.0231 17.9312 18.0331C17.7912 18.4731 17.5212 18.8631 17.1613 19.1431C16.7712 19.4531 16.2712 19.6231 15.7712 19.6231H15.4613C15.3113 19.2431 15.0512 18.9231 14.7212 18.6831C14.3712 18.4331 13.9513 18.3031 13.5212 18.3031H12.9312C11.7712 18.3031 10.8313 19.2431 10.8313 20.4031C10.8313 21.5631 11.7712 22.5031 12.9312 22.5031ZM12.5413 20.0231C12.6512 19.9231 12.7912 19.8631 12.9312 19.8631H13.5312C13.6812 19.8631 13.8212 19.9231 13.9213 20.0231C14.0213 20.1331 14.0813 20.2631 14.0813 20.4131C14.0813 20.5631 14.0213 20.7031 13.9213 20.8031C13.8113 20.9031 13.6812 20.9631 13.5312 20.9631H12.9312C12.7812 20.9631 12.6413 20.9031 12.5413 20.8031C12.4412 20.6931 12.3813 20.5631 12.3813 20.4131C12.3813 20.2631 12.4412 20.1231 12.5413 20.0231ZM17.7712 12.0231C17.8313 11.9631 17.9012 11.9331 17.9812 11.9331L17.9712 11.9231H18.1412C19.1413 11.9231 19.9513 12.7331 19.9513 13.7331V14.6831C19.9513 15.6831 19.1512 16.4931 18.1512 16.4931H17.9812C17.9012 16.4931 17.8313 16.4631 17.7712 16.4031C17.7112 16.3431 17.6812 16.2731 17.6812 16.1931V12.2331C17.6812 12.1531 17.7112 12.0831 17.7712 12.0231ZM4.61125 12.4531C4.95125 12.1131 5.41125 11.9231 5.89125 11.9231H6.06125C6.14125 11.9231 6.21125 11.9531 6.27125 12.0131C6.33125 12.0731 6.36125 12.1431 6.36125 12.2231V16.1831C6.36125 16.2631 6.33125 16.3331 6.27125 16.3931C6.22125 16.4531 6.14125 16.4831 6.06125 16.4831H5.89125C5.41125 16.4831 4.95125 16.2931 4.61125 15.9531C4.27125 15.6131 4.08125 15.1531 4.08125 14.6731V13.7331C4.08125 13.2431 4.27125 12.7931 4.61125 12.4531Z" fill="${value.virtualAgent.themeColor}"/>
            <path d="M9.20125 15.3331C8.82125 15.1531 8.73125 14.6731 8.96125 14.3231C9.19125 13.9831 9.64125 13.8931 10.0213 14.0631C11.2813 14.6231 12.7512 14.6231 14.0112 14.0631C14.3812 13.8931 14.8413 13.9831 15.0713 14.3231C15.3013 14.6731 15.2113 15.1431 14.8313 15.3331C13.9513 15.7631 12.9913 15.9731 12.0213 15.9731C11.0513 15.9731 10.0913 15.7631 9.21125 15.3331H9.20125Z" fill="${value.virtualAgent.themeColor}"/>
          </svg>
      ''';

      return SizedBox(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.height),
          child: SafeArea(
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
                        virtualAgentId: widget.virtualAgentId,
                        themeColor: Color(int.parse(color)),
                        language: widget.language,
                      )
                    : Stack(
                        children: [
                          Messages(
                            customerId: customer.id,
                            virtualAgentId: widget.virtualAgentId,
                            themeColor: virtualAgent.themeColor,
                            language: widget.language,
                          ),
                          Positioned(
                              top: 16,
                              right: 16,
                              child: (widget.showChatWithAgent == true &&
                                      virtualAgent.isTicketEnable == true)
                                  ? GestureDetector(
                                      onTap: () {
                                        if (widget.onChatWithAgentClick !=
                                            null) {
                                          widget.onChatWithAgentClick!(
                                              customer.id,
                                              virtualAgent.workspaceId,
                                              virtualAgent.themeColor);
                                        }
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: const Color(0xffDBDEE3),
                                                width: 1)),
                                        child: Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child:
                                                SvgPicture.string(supportIcon),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 0,
                                      height: 0,
                                    ))
                        ],
                      ),
          ));
    });
  }
}
