fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools/fastlane.zip">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs all the tests
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

- Ensure git clean status

- Increment build number

- Build

- Send to iTunesConnect skipping submission & skipping waiting for build to process

- Cleant build artifacts

- Commit version bump

- Add git tab b{build_number}

- Push to git remote
### ios commit_build_tag
```
fastlane ios commit_build_tag
```

### ios deploy
```
fastlane ios deploy
```
Deploy a new version to the App Store

- Ensure git clean status

- Match AppStore profile

- Build

- Send to iTunesConnect

- Clean build artifacts
### ios add_version_tag
```
fastlane ios add_version_tag
```
Adds git tag for current version
### ios screenshots
```
fastlane ios screenshots
```
Creates new screenshots
### ios deliver_screenshots
```
fastlane ios deliver_screenshots
```
Send screenshots for iTunes Connect
### ios screens
```
fastlane ios screens
```
Creates new screenshots and uploads them to iTunes Connect
### ios increment_version_patch
```
fastlane ios increment_version_patch
```
Increments patch
### ios increment_version_minor
```
fastlane ios increment_version_minor
```
Increments minor
### ios increment_version_major
```
fastlane ios increment_version_major
```
Increments major
### ios build_number_up
```
fastlane ios build_number_up
```
Increments build number

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
