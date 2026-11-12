# gw-mob-sdk-cordova

Cordova plugin `cordova-plugin-smallcase-gateway` (plugin id = npm name), published to npm (npmjs.org).
The old id was `com.scgateway.phonegap`; the JS global `scgateway` and native class names are unchanged.

## Release (release-please, same as react-native-smallcase-gateway)

1. Merge PRs into `master` with Conventional Commit titles (`feat:`, `fix:`, `chore:` ...). These set the next version.
2. `.github/workflows/publish.yml` keeps a `chore(master): release X.Y.Z` PR open. It bumps `package.json`,
   `package-lock.json`, `plugin.xml` and `CHANGELOG.md`.
3. Merging that PR tags `vX.Y.Z`, publishes to npm (trusted publishing, no token) and posts to #gateway-deployments.

## Rules (the publish job fails otherwise)

- Never edit versions by hand. The `x-release-please-version` marker in `plugin.xml` must stay on the `version=` line.
- Native pins in `plugin.xml` (`SCGateway` pod) and `build.gradle` (`com.smallcase.gateway:sdk`) must be production
  versions, not prereleases (`X.Y.Z-...`).
- `build.gradle` must not contain credentials. The Android SDK comes from the public
  `artifactory.smallcase.com/artifactory/SCGateway` repo.
- Files shipped to npm are listed in `package.json` `files`. Add any new plugin source file there.
- Do not rename `.github/workflows/publish.yml`: npm trusted publishing is bound to that file name.
