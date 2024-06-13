import 'package:cxgenie/services/app_service.dart';
import 'package:flutter/material.dart';

class MessageFeedback extends StatefulWidget {
  const MessageFeedback({
    Key? key,
    required this.color,
    required this.botId,
    required this.customerId,
    required this.blockId,
    required this.themeColor,
    this.ticketId,
  }) : super(key: key);

  final String color;
  final String botId;
  final String customerId;
  final String blockId;
  final String? ticketId;
  final String themeColor;

  @override
  MessageFeedbackState createState() => MessageFeedbackState();
}

class MessageFeedbackState extends State<MessageFeedback> {
  final AppService _service = AppService();
  bool _loading = false;
  String _selectedItem = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _loading = false;
    _selectedItem = '';
    super.dispose();
  }

  Future<void> createFeedback(String rating) async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
      _selectedItem = rating;
    });
    await _service.createFeedback(rating, widget.botId, widget.customerId,
        widget.blockId, widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1', '2', '3', '4', '5']
                .map(
                  (item) => GestureDetector(
                    child: Stack(children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffd6dae1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AssetImage(
                            'images/$item.png',
                          ).assetName,
                          fit: BoxFit.cover,
                          package: 'cxgenie',
                        ),
                      ),
                      if (_loading)
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          color: Colors.white.withOpacity(0.5),
                          child: Container(),
                        ),
                      if (_loading && _selectedItem == item)
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Color(int.parse(widget.themeColor)),
                          ),
                        )
                    ]),
                    onTap: () {
                      createFeedback(item);
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Not satisfied',
                style: TextStyle(
                  color: Color(0xffA3A9B3),
                  fontSize: 12,
                ),
              ),
              Text(
                'Very satisfied',
                style: TextStyle(
                  color: Color(0xffA3A9B3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
