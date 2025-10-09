# SCGateway Cordova Plugin

A Cordova/Capacitor plugin for integrating SCGateway financial services into mobile applications.

## Supported Platforms

| Platform | Version | Status |
|----------|---------|--------|
| **Cordova Android** | 13.0+ | ✅ Supported |
| **Cordova iOS** | 8.0+ | ✅ Supported |
| **Capacitor** | 5.0+ | ✅ Supported (manual setup) |
| **Ionic** | 6.0+ | ✅ Supported |

## Host App Requirements

### Android
- **compileSdkVersion**: 35
- **minSdkVersion**: 23
- **targetSdkVersion**: 35
- **AGP**: 8.7.2+
- **Java**: source/target 21 (Gradle runtime JDK 17 via AGP 8.x)
- **AndroidX**: Required

### iOS
- **iOS Deployment Target**: 13.0+
- **Xcode**: 15.0+
- **Swift**: 5.0+
- **CocoaPods**: Latest

## Installation

### Cordova

```bash
cordova plugin add com.scgateway.phonegap
```

### Capacitor

1. **Install the plugin:**
```bash
npm install com.scgateway.phonegap
npx cap sync
```

2. **Follow manual setup steps below**

## Manual Setup for Capacitor

### Android Setup

1. **Add Dependencies to `android/app/build.gradle`:**
```gradle
dependencies {
    implementation 'com.smallcase.gateway:sdk:4.4.0'
    implementation 'androidx.annotation:annotation:1.7.0'
    implementation 'androidx.core:core:1.12.0'
}
```

2. **Add Repositories to `android/build.gradle`:**
```gradle
allprojects {
    repositories {
        maven {
            url "https://artifactory.smallcase.com/artifactory/SCGateway"
            credentials {
                username = project.hasProperty('SCGATEWAY_USERNAME') ? project.property('SCGATEWAY_USERNAME') : ''
                password = project.hasProperty('SCGATEWAY_PASSWORD') ? project.property('SCGATEWAY_PASSWORD') : ''
            }
        }
        google()
        mavenCentral()
    }
}
```

3. **Add Permission to `android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

4. **Set Credentials in `android/gradle.properties`:**
```properties
SCGATEWAY_USERNAME=your_username
SCGATEWAY_PASSWORD=your_password
```

### iOS Setup

1. **Add to `ios/App/Podfile`:**
```ruby
source 'https://github.com/smallcase/cocoapodspecs.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '13.0'

target 'App' do
  pod 'SCGateway', '4.1.0'
  # ... other pods ...
end
```

2. **Set Build Settings in Xcode:**
   - Open `ios/App/App.xcodeproj`
   - Set `iOS Deployment Target` to `13.0`
   - Set `Swift Language Version` to `Swift 5.0`

3. **Run Pod Install:**
```bash
cd ios/App
pod install
```

## Usage

```javascript
// Initialize SDK
scgateway.setConfigEnvironment(
    (success) => console.log('Config set'),
    (error) => console.error('Config error'),
    ['production', 'your-gateway-name', true, true, ['broker1', 'broker2']]
);

// Initialize with auth token
scgateway.initSCGateway(
    (success) => console.log('SDK initialized'),
    (error) => console.error('Init error'),
    ['your-auth-token']
);

// Trigger transaction
scgateway.triggerTransaction(
    (result) => console.log('Transaction result:', result),
    (error) => console.error('Transaction error:', error),
    ['transaction-id']
);
```

## API Reference

### Methods

- `getSdkVersion(success, error)` - Get SDK version
- `setConfigEnvironment(success, error, args)` - Configure environment
- `initSCGateway(success, error, args)` - Initialize SDK
- `triggerTransaction(success, error, args)` - Trigger transaction
- `triggerMfTransaction(success, error, args)` - Trigger MF transaction
- `triggerLeadGen(args)` - Trigger lead generation
- `triggerLeadGenWithStatus(success, error, args)` - Trigger lead gen with status
- `triggerLeadGenWithLoginCta(success, error, args)` - Trigger lead gen with login CTA
- `getUserInvestments(success, error, args)` - Get user investments
- `logout(success, error, args)` - Logout user
- `showOrders(success, error, args)` - Show orders
- `launchSmallplug(success, error, args)` - Launch smallplug
- `launchSmallplugWithBranding(success, error, args)` - Launch smallplug with branding
- `isUserConnected(success, error)` - Check user connection

### Constants

```javascript
scgateway.ENVIRONMENT = {
    PRODUCTION: 'production',
    DEVELOPMENT: 'development',
    STAGING: 'staging'
};

scgateway.TRANSACTION_INTENT = {
    CONNECT: 'CONNECT',
    TRANSACTION: 'TRANSACTION',
    HOLDINGS_IMPORT: 'HOLDINGS_IMPORT',
    FETCH_FUNDS: 'FETCH_FUNDS'
};
```

## Repository Access

### Public Access
The SCGateway Maven repository at `https://artifactory.smallcase.com/artifactory/SCGateway` is accessible but requires authentication.

### Authentication Methods

**Option 1: Environment Variables**
```bash
export SCGATEWAY_USERNAME=your_username
export SCGATEWAY_PASSWORD=your_password
```

**Option 2: gradle.properties**
```properties
SCGATEWAY_USERNAME=your_username
SCGATEWAY_PASSWORD=your_password
```

**Option 3: settings.xml**
```xml
<settings>
    <servers>
        <server>
            <id>scgateway</id>
            <username>your_username</username>
            <password>your_password</password>
        </server>
    </servers>
</settings>
```

## Troubleshooting

### Android Build Issues

**AGP 8.x Compatibility:**
- Ensure you're using Java 17+ for AGP 8.x runtime
- Verify AndroidX migration is complete
- Check that all dependencies use AndroidX

**Repository Access:**
- Verify SCGateway repository credentials
- Ensure network access to artifactory.smallcase.com
- Check gradle.properties for correct credentials

**Java Compatibility:**
- Plugin is compatible with Java 21 (source/target)
- Gradle runtime should use JDK 17 (required by AGP 8.x)

### iOS Build Issues

**CocoaPods:**
- Run `pod repo update` before `pod install`
- Clear derived data if build fails
- Verify iOS deployment target is 13.0+

**Swift Compatibility:**
- Ensure Swift 5.0 is set in Xcode
- Check for Swift version conflicts

### Capacitor Issues

**Manual Integration:**
- Follow the detailed setup steps above
- Ensure all dependencies are added correctly
- Verify repository access and credentials

## Changelog

### 3.0.0
- ✅ Updated SmallcaseGatewaySdk to v4.4.0
- ✅ Modernized for AGP 8.7.2 and compileSdk 35
- ✅ Added Capacitor support with manual integration steps
- ✅ Updated engine requirements for modern Cordova versions
- ✅ Migrated to new SCGateway Artifactory repository
- ✅ Removed hardcoded credentials (now uses environment variables)
- ✅ Enhanced documentation and troubleshooting guide

## License

ISC

