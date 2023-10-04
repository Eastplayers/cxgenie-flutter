import 'package:cxgenie/enums/language.dart';
import 'package:cxgenie/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ContactInformation extends StatefulWidget {
  const ContactInformation({
    Key? key,
    required this.virtualAgentId,
    this.themeColor = const Color(0xff364DE7),
    this.language = LanguageOptions.en,
  }) : super(key: key);

  final String virtualAgentId;
  final Color themeColor;
  final LanguageOptions? language;

  @override
  _ContactInformationState createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height),
      color: const Color(0xffF2F3F5),
      child: SafeArea(
        child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                  child: Wrap(
                children: [
                  Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Text(
                                widget.language == LanguageOptions.en
                                    ? "Please give us your information to support you better"
                                    : "Vui lòng cung cấp một số thông tin của bạn để chúng tôi hỗ trợ bạn tốt hơn",
                                style: const TextStyle(
                                    color: Color(0xff2C2E33),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  widget.language == LanguageOptions.en
                                      ? "Your name *"
                                      : "Họ và tên *",
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xff7D828B)),
                                ),
                              ),
                              SizedBox(
                                child: FormBuilderTextField(
                                    name: 'name',
                                    cursorColor: widget.themeColor,
                                    decoration: InputDecoration(
                                        hintText: widget.language ==
                                                LanguageOptions.en
                                            ? "Enter your name"
                                            : "Nhập họ và tên",
                                        hintStyle: const TextStyle(
                                            color: Color(0xffA3A9B3)),
                                        contentPadding: const EdgeInsets.all(8),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: widget.themeColor,
                                              width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Color(0xffD6DAE1),
                                              width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Color(0xffED4245),
                                              width: 1.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Color(0xffED4245),
                                              width: 1.0),
                                        )),
                                    style: const TextStyle(fontSize: 14),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText: widget.language ==
                                                  LanguageOptions.en
                                              ? 'Please enter your name'
                                              : "Xin vui lòng nhập họ và tên"),
                                    ])),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  widget.language == LanguageOptions.en
                                      ? "Your email *"
                                      : "Email *",
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xff7D828B)),
                                ),
                              ),
                              SizedBox(
                                // height: 40,
                                child: FormBuilderTextField(
                                    name: 'email',
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: widget.themeColor,
                                    decoration: InputDecoration(
                                      hintText:
                                          widget.language == LanguageOptions.en
                                              ? "Enter your email"
                                              : "Nhập email",
                                      hintStyle: const TextStyle(
                                          color: Color(0xffA3A9B3)),
                                      contentPadding: const EdgeInsets.all(8),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: widget.themeColor,
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD6DAE1),
                                            width: 1.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffED4245),
                                            width: 1.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xffED4245),
                                            width: 1.0),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText: widget.language ==
                                                  LanguageOptions.en
                                              ? 'Please enter your email'
                                              : 'Xin vui lòng nhập email'),
                                      FormBuilderValidators.email(
                                          errorText: widget.language ==
                                                  LanguageOptions.en
                                              ? 'Please enter a valid email'
                                              : 'Email không hợp lệ'),
                                    ])),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: widget.themeColor,
                                    padding: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .isStartingSession
                                    ? null
                                    : () {
                                        _formKey.currentState!.save();
                                        if (_formKey.currentState!.validate()) {
                                          final formData =
                                              _formKey.currentState?.value;
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .startNormalSession(
                                                  widget.virtualAgentId,
                                                  formData?['name'],
                                                  formData?['email']);
                                        }
                                      },
                                child: Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .isStartingSession
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(
                                        widget.language == LanguageOptions.en
                                            ? "Submit"
                                            : "Xác nhận",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        )),
                              ))
                        ],
                      ))
                ],
              )),
            )),
      ),
    );
  }
}
