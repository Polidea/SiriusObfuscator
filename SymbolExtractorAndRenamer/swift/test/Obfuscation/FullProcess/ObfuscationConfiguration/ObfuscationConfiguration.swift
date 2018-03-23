//RUN: %target-prepare-obfuscation-for-file "ObfuscationConfiguration" %target-run-full-obfuscation

class SampleClass {}

struct SampleStruct {}

enum SampleEnum {}

protocol SampleProtocol {}

class SampleBaseClass {}

class SampleInheritingClass: SampleBaseClass {}

class SampleDeeperInheritanceClass: SampleInheritingClass {}

class SampleTransitiveBaseClass {}

class SampleTransitiveInheritingClass: SampleTransitiveBaseClass {}

class SampleTransitiveDeeperInheritanceClass: SampleTransitiveInheritingClass {}

protocol SampleUsedProtocol {}

class SampleConformingClass: SampleUsedProtocol {}

struct SampleConformingStruct: SampleUsedProtocol {}

enum SampleConformingEnum: SampleUsedProtocol {}

protocol SampleExtendingProtocol: SampleUsedProtocol {}

protocol SampleDeeperExtendingProtocol: SampleExtendingProtocol {}

class SampleInheritingFromConformingClass: SampleConformingClass {}

protocol SampleTransitiveUsedProtocol {}

class SampleTransitiveConformingClass: SampleTransitiveUsedProtocol {}

struct SampleTransitiveConformingStruct: SampleTransitiveUsedProtocol {}

enum SampleTransitiveConformingEnum: SampleTransitiveUsedProtocol {}

protocol SampleTransitiveExtendingProtocol: SampleTransitiveUsedProtocol {}

protocol SampleTransitiveDeeperExtendingProtocol: SampleTransitiveExtendingProtocol {}

class SampleTransitiveInheritingFromConformingClass: SampleTransitiveConformingClass {}
