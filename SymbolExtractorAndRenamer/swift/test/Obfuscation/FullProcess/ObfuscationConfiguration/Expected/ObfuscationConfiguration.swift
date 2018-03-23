class SampleClass {}

struct SampleStruct {}

enum SampleEnum {}

protocol SampleProtocol {}

class T1_SampleBaseClass {}

class SampleInheritingClass: T1_SampleBaseClass {}

class T1_SampleDeeperInheritanceClass: SampleInheritingClass {}

class T1_SampleTransitiveBaseClass {}

class SampleTransitiveInheritingClass: T1_SampleTransitiveBaseClass {}

class SampleTransitiveDeeperInheritanceClass: SampleTransitiveInheritingClass {}

protocol T1_SampleUsedProtocol {}

class SampleConformingClass: T1_SampleUsedProtocol {}

struct SampleConformingStruct: T1_SampleUsedProtocol {}

enum SampleConformingEnum: T1_SampleUsedProtocol {}

protocol SampleExtendingProtocol: T1_SampleUsedProtocol {}

protocol T1_SampleDeeperExtendingProtocol: SampleExtendingProtocol {}

class T1_SampleInheritingFromConformingClass: SampleConformingClass {}

protocol T1_SampleTransitiveUsedProtocol {}

class SampleTransitiveConformingClass: T1_SampleTransitiveUsedProtocol {}

struct SampleTransitiveConformingStruct: T1_SampleTransitiveUsedProtocol {}

enum SampleTransitiveConformingEnum: T1_SampleTransitiveUsedProtocol {}

protocol SampleTransitiveExtendingProtocol: T1_SampleTransitiveUsedProtocol {}

protocol SampleTransitiveDeeperExtendingProtocol: SampleTransitiveExtendingProtocol {}

class SampleTransitiveInheritingFromConformingClass: SampleTransitiveConformingClass {}
