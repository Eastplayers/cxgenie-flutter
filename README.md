# CXGenie

The cxgenie Flutter Package seamlessly integrates https://cxgenie.ai cutting-edge Conversational AI and NLP capabilities into Flutter apps. Effortlessly deploy chatbots, leverage multilingual support, customize the UI, and access rich media features for immersive user interactions. With flexible deployment options and comprehensive documentation, developers can create intelligent, user-centric Flutter applications, enhancing user engagement and satisfaction.

## Installation

1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):

```yaml
dependencies:
  cxgenie: ^0.0.17
```

2. Import the package and use it in your Flutter App.

```dart
import 'package:cxgenie/cxgenie.dart';
```

## Example

### Chat

There are a number of properties that you can modify:

- virtualAgentId
- userToken (optional)
- showChatWithAgent (optional)
- onChatWithAgentClick (optional)

```dart
class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const ChatContainer(
          virtualAgentId: 'string',
          userToken: 'string',
          showChatWithAgent: true,
          onChatWithAgentClick: (String userId, String workspaceId, String themeColor) {},
        ),
      ),
    );
  }
}
```

### Tickets

There are a number of properties that you can modify:

- workspaceId
- chatUserId
- themeColor (optional)

```dart
class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Tickets(
          workspaceId: 'string',
          chatUserId: 'string',
          themeColor: 'string',
        ),
      ),
    );
  }
}
```
