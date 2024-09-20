# Flutter Deep Linking Setup

This README outlines the steps to set up deep linking in your Flutter app using the `app_links` package.

## Prerequisites

- Flutter SDK installed
- A Flutter project set up

## Steps to Enable Deep Linking

### Step 1: Configure Platform-Specific Files

#### Android (AndroidManifest.xml)

Add the following inside the `<activity>` tag in your `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="your-domain.com" />
</intent-filter>
```

Replace `your-domain.com` with your actual domain.

#### iOS (Info.plist)

Add the following to your `ios/Runner/Info.plist`:

```xml
<key>FlutterDeepLinkingEnabled</key>
<true/>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your-scheme</string>
        </array>
    </dict>
</array>
```

Replace `your-scheme` with your app's custom URL scheme.

### Step 2: Install the app_links Package

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  app_links: #use latest
```

Then run:

```
flutter pub get
```

### Step 3: Set Up the Listener

In your main.dart file, import the package and set up the listener:

```dart
import 'package:app_links/app_links.dart';

class _MyHomePageState extends State<MyHomePage> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was launched from dead
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      handleDeepLink(appLink);
    }

    // Listen to app links while app is in memory
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      handleDeepLink(uri);
    });
  }

  void handleDeepLink(Uri uri) {
    // Handle your deep link here
    print('Deep link received: $uri');
    // You can navigate to specific pages based on the URI
    // For example:
    if (uri.path.startsWith('/candidate/')) {
      final candidateId = uri.pathSegments.last;
      Navigator.pushNamed(context, '/candidate/$candidateId');
    }
  }

  // Rest of your widget code...
}
```

## Testing Deep Links

To test your deep links:

1. Using browser inside your device or simulator 
    you can simulate the route by typing this in the url (deeplinks is the your-scheme i have used in the code)<br>
    `deeplinks://link/home`<br>
    or for candidate do <br>
    `deeplinks://links/candidate/{query_params_separated_by_}`
<br>
Replace  `your-scheme` with your actual domain and scheme.

## Troubleshooting

- Ensure that your app is properly configured to handle the specific URL scheme you're testing.
- For Android, make sure the `android:autoVerify="true"` attribute is set in your manifest.
- For iOS, ensure that Associated Domains are properly configured if you're using Universal Links.

## Additional Resources

- [app_links package documentation](https://pub.dev/packages/app_links)
- [Flutter Deep Linking documentation](https://docs.flutter.dev/development/ui/navigation/deep-linking)

Remember to replace placeholder values with your actual app-specific information.