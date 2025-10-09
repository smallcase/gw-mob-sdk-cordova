# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [4.0.0] - 2024-12-19

#### 🚀 MAJOR RELEASE: Android 16KB Page Size Support + iOS Requirements Update
- **BREAKING**: Updated Sentry Android SDK to v8.0.0 for 16KB page size compatibility
- **BREAKING**: Updated NDK requirement to 28.2.13676358 for automatic 16KB alignment
- **BREAKING**: Updated SmallcaseGatewaySdk from v4.2.0 to v4.4.0
- **BREAKING**: Updated minimum Cordova Android to 14.0.1+ and iOS to 7.1.1+
- **BREAKING**: Updated iOS requirements to latest SCGateway SDK standards
  - iOS Deployment Target: 14.0+ (was 13.0)
  - Swift Version: 6.0+ (was 5.0)
  - Xcode: 16.4+ (was 15.0)
- **FEATURE**: Added official support for Android 15+ 16KB page size devices
- **IMPROVEMENT**: Enhanced Gradle configuration with Sentry version management
- **IMPROVEMENT**: Updated Android build tools to 36.0.0
- **IMPROVEMENT**: Added 16KB page size alignment verification
- **IMPROVEMENT**: Migrated to new SCGateway Artifactory repository
- **IMPROVEMENT**: Updated iOS framework requirements for latest SCGateway SDK compatibility

#### 🔧 Technical Changes
- Updated `smallcase-sdk.gradle` with Sentry 8.0.0 dependency
- Added Sentry version resolution strategy
- Updated plugin.xml with modern engine requirements
- Enhanced README with 16KB compatibility information
- Updated AndroidX dependencies to latest versions
- Added comprehensive error handling and logging

### [3.1.0] - 2024-01-XX (Unreleased / Local)

#### 🚀 Local Development Updates
- **LOCAL**: Updated version to 3.1.0-local for local development
- **LOCAL**: Ready for integration with smart-investing sample app
- **LOCAL**: Compatible with AGP 8.7.2 and compileSdk 35

### [3.0.0] - 2024-01-XX

#### 🚀 Major Updates
- **BREAKING**: Updated SmallcaseGatewaySdk from v4.2.0 to v4.4.0
- **BREAKING**: Updated minimum Cordova Android to 13.0.0
- **BREAKING**: Updated minimum Cordova iOS to 8.0.0
- **BREAKING**: Migrated to new SCGateway Artifactory repository

#### ✅ Compatibility Improvements
- Added support for AGP 8.7.2 and compileSdk 35
- Added support for Java 21 (source/target) with JDK 17 runtime
- Migrated to AndroidX dependencies
- Added iOS 13.0+ deployment target support
- Added Swift 5.0 compatibility

#### 🔧 Build System Updates
- Replaced hardcoded credentials with environment variable support
- Updated repository URL to `https://artifactory.smallcase.com/artifactory/SCGateway`
- Created minimal Gradle snippet (`src/android/gradle/smallcase-sdk.gradle`)
- Removed hardcoded AGP/Gradle version constraints
- Enhanced repository configuration for private Maven repos

#### 📱 Capacitor Support
- Added comprehensive Capacitor integration guide
- Provided manual setup steps for Android and iOS
- Created detailed mapping table for Capacitor configuration
- Added troubleshooting section for Capacitor-specific issues

#### 📚 Documentation
- Completely rewritten README with modern setup instructions
- Added supported platforms matrix
- Enhanced API documentation with examples
- Added troubleshooting guide for common issues
- Added repository access and authentication documentation

#### 🔄 Migration Guide
- **Cordova Users**: No breaking changes, just update Cordova versions
- **Capacitor Users**: Follow manual integration steps in README
- **Android**: Ensure AndroidX migration is complete
- **iOS**: Update deployment target to 13.0+ and Swift to 5.0
- **Credentials**: Update to use environment variables instead of hardcoded values

#### ⚠️ Breaking Changes
- Minimum Cordova Android: 13.0.0 (was 3.7.0)
- Minimum Cordova iOS: 8.0.0 (was 3.7.0)
- iOS Deployment Target: 13.0+ (was not specified)
- Repository URL: Updated to new SCGateway endpoint
- Credentials: Now requires environment variables (no hardcoded values)

### [2.9.1](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.9.0...v2.9.1) (2023-02-16)

## [2.9.0](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.8.1...v2.9.0) (2023-02-16)

### [2.8.1](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.7.0...v2.8.1) (2022-12-05)


### Features

* mf holdings support ([de47582](https://github.com/smallcase/gw-mob-sdk-cordova/commit/de47582b77b9112515b78c7430a1cdaf91db32af))
* showLoginCta for leadgen ([033f199](https://github.com/smallcase/gw-mob-sdk-cordova/commit/033f199d19286acb370e49c34c23533799edc984))
* user investments ([24c18d1](https://github.com/smallcase/gw-mob-sdk-cordova/commit/24c18d1c671d08524fb615e163b6b41f611f8610))

## [2.7.0](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.8.0...v2.7.0) (2022-08-03)

### [2.6.2](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.6.1...v2.6.2) (2022-07-05)


### Bug Fixes

* lead gen response not returned if user is navigating via broker chooser ([de43168](https://github.com/smallcase/gw-mob-sdk-cordova/commit/de43168d79ef0eeb3d44fc1bc27c4856131024ea))

### [2.6.1](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.6.0...v2.6.1) (2022-06-27)


### Bug Fixes

* null pointer exceptions in DM partner branding (android) ([52e25c9](https://github.com/smallcase/gw-mob-sdk-cordova/commit/52e25c9b7486aafb518da9e5741d68dc8f9e1396))

## [2.6.0](https://github.com/smallcase/gw-mob-sdk-cordova/compare/v2.5.1...v2.6.0) (2022-06-22)


### Bug Fixes

* android dm default values ([b91d99c](https://github.com/smallcase/gw-mob-sdk-cordova/commit/b91d99cdcf94577f823c9af73ada6384df5730cd))

### 2.5.1 (2022-05-31)


### Features

* added lead status response to leadGen ([2064ec7](https://github.com/smallcase/gw-mob-sdk-cordova/commit/2064ec78d5eb516c1a3ad2dcaa58320abca2c2ce))
* added logout functionality, new broker chooser and 5paisa PWA account opening journey ([f419bca](https://github.com/smallcase/gw-mob-sdk-cordova/commit/f419bcaee1b322f8a19dab2d423e0c764c6f4ebe))
* log transactionId ([d309c09](https://github.com/smallcase/gw-mob-sdk-cordova/commit/d309c09a000defb04d2a924f7668cd3c4a305d4a))
* show_orders ([9f2544e](https://github.com/smallcase/gw-mob-sdk-cordova/commit/9f2544e59d345c25bf4f1561048dee71abe21624))
* upgraded native SDKs ([618dc2a](https://github.com/smallcase/gw-mob-sdk-cordova/commit/618dc2a36cfc847f61ed1fe144d66f2be8021aea))


### Bug Fixes

* lead status response for 5paisa and show orders error for connected leprechaun users ([747c5c3](https://github.com/smallcase/gw-mob-sdk-cordova/commit/747c5c30192bb3b78d444360e1342e93567e06ea))
