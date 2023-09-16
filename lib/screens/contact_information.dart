import 'package:flutter/material.dart';

class ContactInformation extends StatefulWidget {
  const ContactInformation(
      {Key? key, this.themeColor = const Color(0xff364DE7)})
      : super(key: key);

  final Color themeColor;

  @override
  _ContactInformationState createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height),
      color: const Color(0xffF2F3F5),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
              child: Wrap(
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: const Text(
                            "Please give us your information to support you better",
                            style: TextStyle(
                                color: Color(0xff2C2E33),
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: const Text(
                              "Your name *",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xff7D828B)),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle:
                                    const TextStyle(color: Color(0xffA3A9B3)),
                                contentPadding: const EdgeInsets.all(8),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff364DE7), width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD6DAE1), width: 1.0),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
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
                            child: const Text(
                              "Your email *",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xff7D828B)),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle:
                                    const TextStyle(color: Color(0xffA3A9B3)),
                                contentPadding: const EdgeInsets.all(8),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xff364DE7), width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xffD6DAE1), width: 1.0),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: widget.themeColor,
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {},
                            child: const Text("Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ))),
                      )
                    ],
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
