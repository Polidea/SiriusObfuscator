# Important topics for Bitcode, Symbols and other stuff

The goal of this document is to be a bag of important ideas, concepts and discoveries related to system and other low level things. Currently these include:

1. [What is Bitcode and how does it affect obfuscation?](#bitcode)
2. [How can someone disassemble my app?](#jailbreak)
3. [What does Xcode's "Strip Swift Symbols" option do?](#strip)
4. [What are dSYM files?](#dsym)
5. [How can I symbolicate crash logs from an obfuscated app?](#symbolicate)
6. [Resources](#resources)

# <a name="bitcode"></a> Bitcode

TODO

# <a name="jailbreak"></a> Disassembling an app

This section describes the example process of dissasembling an iOS app that is available in App Store. The process might require different software for each step, depending on tools availability for specific iOS version and device.

Caution: the process involve jailbreaking the device which is strongly advised against.

1. Download the app from the App Store.
2. Jailbreak the device. For iOS versions 11.0-11.1.2 this can be done using [Electra](https://coolstar.org/electra/).
3. The app bundle stored on the device is protected by [DRM system](https://en.wikipedia.org/wiki/Digital_rights_management) - the app's symbols that could be retrieved from app's binary are encrypted. The binary is decrypted upon running the app, when it's loaded to RAM. Retrieving the decrypted .ipa from the device can be done using [frida-ios-dump](https://github.com/AloneMonkey/frida-ios-dump).
4. Dissasembling the app's mach-o executable can be done using [Hopper](https://www.hopperapp.com).

# <a name="strip"></a> Stripping Swift symbols

Stripping Swift symbols from the mach-o executable can be achieved by turning on the `Strip Swift Symbols` flag (it is enabled by deefault). The flag can be found in Xcode build settings (Build Settings > Deployment > Strip Swift Symbols) and in archive process settings before sending the app to App Store review. With this flag only the swift symbols that are not accesible from ObjectiveC runtime are stripped from the binary.

# <a name="dsym"></a> dSYM files

dSYM files contain debug symbols of an app and allow for [symbolicating crash logs](#symbolicate).

That means that debug symbols can be removed from a release build of an app reducing its binary size and making it harder to reverse engineer.

Under the hood dSYM files are using [DWARF](http://dwarfstd.org/) format. It allows the compiler to tell the debugger how the original source code relates to the binary.

# <a name="symbolicate"></a> Symbolicating crash logs

Symbolication is the process of replacement of addresses in crash logs with human readable values. Without first symbolicating a crash report it is difficult to determine where the crash occurred.

In order to perform symbolication a dSYM file is needed. The process can be performed in Xcode or it can be done by services like Crashlytics ([you have to provide them with a proper dSYM file for your app first](https://docs.fabric.io/apple/crashlytics/missing-dsyms.html#upload-symbols)).

Unfortunately current version of the Sirius Swift Obfuscator doesn't support generating non-obfuscated dSYM files and doesn't provide a tool to deobfuscate crash logs. We're aware that this is an important feature and will provide such tool in the future. It's technically challenging because of the complexity of the [DWARF](http://dwarfstd.org/) format used by dSYM files.

# <a name="resources"></a> Resources

You can find more detailed information about Bitcode, dSYM files and crash log symbolication in an [Apple technical note TN2151](#https://developer.apple.com/library/content/technotes/tn2151/_index.html).
