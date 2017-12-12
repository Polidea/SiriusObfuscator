//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#if NOSTDLIBUNITTEST
#else
import StdlibUnittest

#if os(OSX)
import Cocoa
#else
import Foundation
#endif

#if APPLE_FRAMEWORKS_AVAILABLE
import SpriteKit
#endif

class VersionDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "VersionDecoding" }
    var explanation: String { return "Check that the correct protocol version number is decoded" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let logdata = playground_log_impl(1, "", TestHelpers.defaultSourceRange())
        let opt_decoded = playground_log_decode(logdata)
        let decoded = TestHelpers.unwrapOrFail(opt_decoded)
        expectEqual(10, decoded.version)
    }
}

class SourceRangesTestCase : TestCase {
    required init?() {}
    var name: String { return "SourceRanges" }
    var explanation: String { return "Check that we emit correct source ranges" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let myrange = SourceRange(begin: (line: 12, col: 3), end: (line: 13, col: 2))
        let logdata = playground_log(1,
                                     "",
                                     0,
                                     Int(myrange.begin.line),
                                     Int(myrange.end.line),
                                     Int(myrange.begin.col),
                                     Int(myrange.end.col))
        let opt_decoded = playground_log_decode(logdata)
        let decoded = TestHelpers.unwrapOrFail(opt_decoded)
        expectEqual(myrange.begin.line, decoded.range.begin.line)
        expectEqual(myrange.begin.col, decoded.range.begin.col)
        expectEqual(myrange.end.line, decoded.range.end.line)
        expectEqual(myrange.end.col, decoded.range.end.col)
    }
}
    
class TIDSentTestCase : TestCase {
    required init?() {
#if APPLE_FRAMEWORKS_AVAILABLE
#else
        return nil
#endif
    }
    var name: String { return "TIDSent" }
    var explanation: String { return "Check that the header contains a numeric TID" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let logdata = playground_log_impl(1, "", TestHelpers.defaultSourceRange())
        let opt_decoded = playground_log_decode(logdata)
        let decoded = TestHelpers.unwrapOrFail(opt_decoded)
        var found = false
        for (key,value) in decoded.header {
            if key == "tid" {
                if Int(value) != nil {
                    found = true
                }
            }
        }
        expectTrue(found)
    }
}

class NameDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "NameDecoding" }
    var explanation: String { return "Check that object names are decoded correctly" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        struct S { var a = 1; var b = 2; }
        let logdata = playground_log_impl(S(),"s", TestHelpers.defaultSourceRange())
        let opt_decoded = playground_log_decode(logdata)
        let decoded = TestHelpers.unwrapOrFail(opt_decoded)
        let s = decoded.object
        expectEqual("s", s.name)
        let structured = TestHelpers.unwrapOrFail(s as? PlaygroundDecodedObject_Structured)
        expectEqual(2, structured.count)
        let child0 = structured[0]
        let child1 = structured[1]
        expectEqual(child0.name,"a")
        expectEqual(child1.name,"b")
    }
}

class BaseTypesDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "BaseTypesDecoding" }
    var explanation: String { return "Check that basic data types are decoded correctly" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        struct S { var a = 1; var b = "hello world"; var c: Double = 12.15; var d: Float = 12.15 }
        let logdata = playground_log_impl(S(),"s", TestHelpers.defaultSourceRange())
        let opt_decoded = playground_log_decode(logdata)
        let decoded = TestHelpers.unwrapOrFail(opt_decoded)
        let structured = TestHelpers.unwrapOrFail(decoded.object as? PlaygroundDecodedObject_Structured)
        expectEqual(4, structured.count)
        let child0 = structured[0]
        let child1 = structured[1]
        let child2 = structured[2]
        let child3 = structured[3]
        let child0_iderepr = TestHelpers.unwrapOrFail(child0 as? PlaygroundDecodedObject_IDERepr)
        let child1_iderepr = TestHelpers.unwrapOrFail(child1 as? PlaygroundDecodedObject_IDERepr)
        let child2_iderepr = TestHelpers.unwrapOrFail(child2 as? PlaygroundDecodedObject_IDERepr)
        let child3_iderepr = TestHelpers.unwrapOrFail(child3 as? PlaygroundDecodedObject_IDERepr)
        let a = Int(TestHelpers.unwrapOrFail( (TestHelpers.unwrapOrFail(child0_iderepr.payload)) as? Int64 ))
        let b = TestHelpers.unwrapOrFail( (TestHelpers.unwrapOrFail(child1_iderepr.payload)) as? String )
        let c = TestHelpers.unwrapOrFail( (TestHelpers.unwrapOrFail(child2_iderepr.payload)) as? Double )
        let d = TestHelpers.unwrapOrFail( (TestHelpers.unwrapOrFail(child3_iderepr.payload)) as? Float )
        let realS = S()
        expectEqual(a, realS.a)
        expectEqual(b, realS.b)
        expectEqual(c, realS.c)
        expectEqual(d, realS.d)
    }
}

class StructuredTypesDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "StructuredTypesDecoding" }
    var explanation: String { return "Check that structured types are decoded with the correct tag" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        struct S {}
        class C {}

        let s_logdata = playground_log_impl(S(),"s", TestHelpers.defaultSourceRange())
        let c_logdata = playground_log_impl(C(),"c", TestHelpers.defaultSourceRange())
        let t_logdata = playground_log_impl((1,1),"t", TestHelpers.defaultSourceRange())

        let s_opt_decoded = playground_log_decode(s_logdata)
        let c_opt_decoded = playground_log_decode(c_logdata)
        let t_opt_decoded = playground_log_decode(t_logdata)

        let s_decoded = TestHelpers.unwrapOrFail(s_opt_decoded)
        let c_decoded = TestHelpers.unwrapOrFail(c_opt_decoded)
        let t_decoded = TestHelpers.unwrapOrFail(t_opt_decoded)

        let s = TestHelpers.unwrapOrFail(s_decoded.object as? PlaygroundDecodedObject_Structured)
        let c = TestHelpers.unwrapOrFail(c_decoded.object as? PlaygroundDecodedObject_Structured)
        let t = TestHelpers.unwrapOrFail(t_decoded.object as? PlaygroundDecodedObject_Structured)

        expectEqual(s.type, PlaygroundRepresentation.Struct.description)
        expectEqual(c.type, PlaygroundRepresentation.Class.description)
        expectEqual(t.type, PlaygroundRepresentation.Tuple.description)
    }
}

class NSNumberDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "NSNumberDecoding" }
    var explanation: String { return "Check that NSNumber decodes correctly" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let num: NSNumber = NSNumber(value: 12345)
        let logdata = playground_log_impl(num,"num", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let iderepr = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_IDERepr )
        let data = TestHelpers.unwrapOrFail( iderepr.payload )
        expectEqual("\(data)", "12345")
    }
}

class OnePlusOneDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "One+OneDecoding" }
    var explanation: String { return "Check that 1+1 is not logged as an NSNumber" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let logdata = playground_log_impl(1+1,"num", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let iderepr = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_IDERepr )
        let summary = iderepr.summary
        expectEqual(summary, "2")
    }
}

class MetatypeLoggingTestCase : TestCase {
    required init?() {}
    var name: String { return "MetatypeLogging" }
    var explanation: String { return "Check that a type object can be correctly logged" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        struct S {}
        let logdata = playground_log_impl(S.self,"S", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let _ = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
    }
}

class ExceptionSafetyTestCase : TestCase {
    required init?() {}
    var name: String { return "ExceptionSafety" }
    var explanation: String { return "Check that we can correctly wrap ObjC exceptions in a Swift-safe manner" }
    var behavior: TestBehavior { return .FailOnNonApplePlatform("no NSException support") }
    func doTest() {
        let except = SwiftExceptionSafety.doTry {
            let arr = NSArray()
            arr.object(at: 22)
        }
        TestHelpers.unwrapOrFail(except)
    }
}

class NSViewLoggingTestCase : TestCase {
    required init?() {
#if APPLE_FRAMEWORKS_AVAILABLE
#else
    return nil
#endif
    }
    var name: String { return "NSViewLogging" }
    var explanation: String { return "Check that we can correctly log an NSView without crashing" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        #if os(OSX)
        let button = NSButton(frame: NSRect(x: 0,y: 0,width: 100,height: 100))
        let logdata  = playground_log_impl(button, "button", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let iderepr = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_IDERepr )
        expectEqual(iderepr.tag, "VIEW")
        #endif
    }
}

class NSImageLoggingTestCase : TestCase {
    required init?() {
#if APPLE_FRAMEWORKS_AVAILABLE
#else
    return nil
#endif
    }
    var name: String { return "NSImageLogging" }
    var explanation: String { return "Check that we can correctly log an NSImage without crashing" }
    var behavior: TestBehavior { return .Skip("SR-3613") }
    func doTest() {
        #if os(OSX)
        let image = NSImage(contentsOf: NSURL(string: "http://images.apple.com/support/assets/images/home/qp_apple_icon.png")! as URL)
        TestHelpers.unwrapOrFail(image)
        let logdata  = playground_log_impl(image!, "image", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let iderepr = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_IDERepr )
        expectEqual(iderepr.tag, "IMAG")
        #endif
    }
}

class SpriteKitLoggingTestCase : TestCase {
    required init?() {
#if APPLE_FRAMEWORKS_AVAILABLE
#else
    return nil
#endif
    }
    var name: String { return "SpriteKitLogging" }
    var explanation: String { return "Check that we correctly choose PNG over JPG when necessary" }
    var behavior: TestBehavior { return .Skip("SR-3613") }
    func doTest() {
        #if os(OSX)
            let spritekit_image_encoder = SpriteKitImageRepresentation()
            if let jpg_image = NSImage(contentsOf: NSURL(string: "http://images.apple.com/pr/products/images/MacPro_PFHI_PRINT_131021_HERO.jpg")! as URL) {
                if let data = spritekit_image_encoder.getImageData(jpg_image) {
                    let bytes = BytesStorage(data as NSData)
                    expectEqual(bytes[0], 0xFF)
                    expectEqual(bytes[1], 0xD8)
                }
            } else {
                TestHelpers.unwrapOrFail(Optional<Int>.none)
            }
            if let png_image = NSImage(contentsOf: NSURL(string: "http://images.apple.com/v/home/bx/images/home_hero_macbook_large.png")! as URL) {
                if let data = spritekit_image_encoder.getImageData(png_image) {
                    let bytes = BytesStorage(data as NSData)
                    expectEqual(bytes[0], 137)
                    expectEqual(bytes[1], 80)
                    expectEqual(bytes[2], 78)
                    expectEqual(bytes[3], 71)
                    expectEqual(bytes[4], 13)
                    expectEqual(bytes[5], 10)
                    expectEqual(bytes[6], 26)
                    expectEqual(bytes[7], 10)
                }
            } else {
                TestHelpers.unwrapOrFail(Optional<Int>.none)
            }
        #endif
    }
}

class OptionalGetsStrippedTestCase : TestCase {
    required init?() {}
    var name: String { return "OptionalGetsStripped" }
    var explanation: String { return "Check that we strip away layers of optionality" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let some: String?? = "hello"
        let none: String?? = nil

        let some_logged = playground_log_impl(some, "some", TestHelpers.defaultSourceRange())
        let none_logged = playground_log_impl(none, "none", TestHelpers.defaultSourceRange())

        let some_decoded = TestHelpers.unwrapOrFail( playground_log_decode(some_logged) )
        let none_decoded = TestHelpers.unwrapOrFail( playground_log_decode(none_logged) )

        let some_iderepr = TestHelpers.unwrapOrFail( some_decoded.object as? PlaygroundDecodedObject_IDERepr )
        let none_structured = TestHelpers.unwrapOrFail( none_decoded.object as? PlaygroundDecodedObject_Structured )

        expectEqual(none_structured.summary, "nil")
        expectEqual(some_iderepr.tag, "STRN")
        expectEqual(some_iderepr.summary, "hello")
    }
}

class StackWorksTestCase : TestCase {
    required init?() {}
    var name: String { return "StackWorks" }
    var explanation: String { return "Check that Stack<T> works correctly" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let stack = Stack<Int>()
        expectTrue(stack.empty)
        stack.push(1)
        stack.push(2)
        stack.push(3)
        expectFalse(stack.empty)
        expectEqual(3, stack.pop())
        expectEqual(2, stack.pop())
        expectEqual(1, stack.pop())
        expectTrue(stack.empty)
        expectNil(stack.tryPop())
        stack.push(4)
        expectFalse(stack.empty)
        TestHelpers.unwrapOrFail(stack.tryPop())
        expectNil(stack.tryPop())
    }
}

class NeverLoggingPolicyTestCase : TestCase {
    required init?() {}
    var name: String { return "NeverLoggingPolicy" }
    var explanation: String { return "Check that we can correctly push a 'Never' logging policy and get a Gap back" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let object = "Hello world"
        var logdata: NSData = NSData()
        playground_log_never { () -> () in logdata = playground_log (object, "object", 1, 0,0,0,0); return () }
        var decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        _ = TestHelpers.unwrapOrFail ( decoded.object as? PlaygroundDecodedObject_Gap )
        logdata = playground_log (object, "object", 1, 0,0,0,0)
        decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let gap2 = decoded.object as? PlaygroundDecodedObject_Gap
        expectNil(gap2)
    }
}

class AdaptiveLoggingPolicyTestCase : TestCase {
    required init?() {}
    var name: String { return "AdaptiveLoggingPolicy" }
    var explanation: String { return "Check that we can correctly push a 'Adaptive' logging policy and get a Gap back" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let object = "Hello world!!!"
        LoggingPolicyStack.get().push(LoggingLevelPolicy_Adaptive(10))
        let _ = playground_log(object, "object", 1, 0,0,0,0)
        let logdata = playground_log(object, "object", 1, 0,0,0,0)
        LoggingPolicyStack.get().pop()
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        _ = TestHelpers.unwrapOrFail ( decoded.object as? PlaygroundDecodedObject_Gap )
    }
}

class SetIsMembershipContainerTestCase : TestCase {
    required init?() {}
    var name: String { return "SetIsMembershipContainer" }
    var explanation: String { return "Check that we log Set objects as MembershipContainers" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let object = Set([1,2,3])
        let logdata = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let set_structured = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
        expectEqual("MembershipContainer", set_structured.type)
    }
}

class TypenameManagementTestCase : TestCase {
    required init?() {}
    var name: String { return "TypenameManagement" }
    var explanation: String { return "Check that typenames sent over make sense" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        struct SomeStruct {
            var a = 12
            var b = 24
        }
        var object: Any = SomeStruct()
        var logdata = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        var decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        var structured = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
        expectEqual("SomeStruct #1 in PlaygroundLogger.TypenameManagementTestCase.doTest() -> ()", structured.typeName)
        object = (1,2,2,4)
        logdata = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        structured = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
        expectEqual("(Int, Int, Int, Int)", structured.typeName)
        object = [1: "1", 2: "2"]
        logdata = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        structured = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
        expectEqual("Dictionary<Int, String>", structured.typeName)
        class Foo { class Swift { class Bar { class Baz { } } } }
        object = Foo.Swift.Bar.Baz()
        logdata = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        structured = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
        expectEqual("Bar.Baz in Foo #1 in PlaygroundLogger.TypenameManagementTestCase.doTest() -> ()", structured.typeName)
    }
}

class FloatDoubleDecodingTestCase : TestCase {
    required init?() {}
    var name: String { return "FloatDoubleDecoding" }
    var explanation: String { return "Check that Float and Double encode different" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let f: Float = 1.25
        let d: Double = 1.25
        let f_ld = playground_log_impl(f, "f", TestHelpers.defaultSourceRange())
        let d_ld = playground_log_impl(d, "d", TestHelpers.defaultSourceRange())
        let f_dc = TestHelpers.unwrapOrFail( playground_log_decode(f_ld) )
        let d_dc = TestHelpers.unwrapOrFail( playground_log_decode(d_ld) )
        
        let f_repr = TestHelpers.unwrapOrFail( f_dc.object as? PlaygroundDecodedObject_IDERepr )
        let d_repr = TestHelpers.unwrapOrFail( d_dc.object as? PlaygroundDecodedObject_IDERepr )
        
        expectEqual(f_repr.tag, "FLOT")
        expectEqual(d_repr.tag, "DOBL")
        
        let f2 = TestHelpers.unwrapOrFail( f_repr.payload as? Float )
        let d2 = TestHelpers.unwrapOrFail( d_repr.payload as? Double )
        
        expectEqual(f, f2)
        expectEqual(d, d2)
    }
}

class SKShapeNodeTestCase : TestCase {
    required init?() {
#if APPLE_FRAMEWORKS_AVAILABLE
#else
    return nil
#endif
    }
    var name: String { return "SKShapeNode" }
    var explanation: String { return "Check that an SKShapeNode encodes without error" }
    var behavior: TestBehavior { return .Skip("") }
    func doTest() {
#if os(OSX)
        let blahNode = SKShapeNode(circleOfRadius: 30.0)
        let logdata = playground_log_impl(blahNode, "blahNode", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let bn_repr = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_IDERepr )
        expectEqual(bn_repr.tag, "SKIT")
        expectEqual(bn_repr.typeName, "SKShapeNode")
#endif
    }
}

class BaseClassLoggingTestCase : TestCase {
    required init?() {}
    var name: String { return "BaseClassLogging" }
    var explanation: String { return "Check that we can log a class with a base class" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        class Parent { var a = 1; var b = 2 }
        class Child : Parent { var c = 3 }
        let object = Child()
        let logdata = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
        let structured = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_Structured )
        var seen_parent = false
        var seen_a = false
        var seen_b = false
        var seen_c = false
        for child in structured.children {
            if let structured_child = child as? PlaygroundDecodedObject_Structured {
                if structured_child.name == "super" {
                    seen_parent = true
                    for parent_child in structured_child.children {
                        if parent_child.name == "a" { seen_a = true }
                        if parent_child.name == "b" { seen_b = true }
                    }
                }
            }
            if child.name == "c" {
                seen_c = true
            }
        }
        expectTrue(seen_parent && seen_a && seen_b && seen_c)
    }
}

// generic so can't be nested in the test case itself
private enum EnumSummaryTestCase_GEither<T1,T2> { case First(T1), Second(T2), Neither }
private enum EnumSummaryTestCase_Either { case First(Int), Second(String), Neither }
class EnumSummaryTestCase_Generic : TestCase {
    required init?() {}
    var name: String { return "EnumSummary_Generic" }
    var explanation: String { return "Check that generic enum summaries show up properly" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        typealias GEither = EnumSummaryTestCase_GEither<Int,String>
        let t1 = GEither.First(1)
        let t2 = GEither.Second("A")
        let t3 = GEither.Neither
        
        let logdata_t1 = playground_log_impl(t1, "t1", TestHelpers.defaultSourceRange())
        let logdata_t2 = playground_log_impl(t2, "t2", TestHelpers.defaultSourceRange())
        let logdata_t3 = playground_log_impl(t3, "t3", TestHelpers.defaultSourceRange())
        
        let decoded_t1 = TestHelpers.unwrapOrFail( playground_log_decode(logdata_t1) )
        let decoded_t2 = TestHelpers.unwrapOrFail( playground_log_decode(logdata_t2) )
        let decoded_t3 = TestHelpers.unwrapOrFail( playground_log_decode(logdata_t3) )
        
        let structured_t1 = TestHelpers.unwrapOrFail( decoded_t1.object as? PlaygroundDecodedObject_Structured )
        let structured_t2 = TestHelpers.unwrapOrFail( decoded_t2.object as? PlaygroundDecodedObject_Structured )
        let structured_t3 = TestHelpers.unwrapOrFail( decoded_t3.object as? PlaygroundDecodedObject_Structured )
        
        expectEqual(structured_t1.summary, "First(1)")
        expectEqual(structured_t2.summary, "Second(\"A\")")
        expectEqual(structured_t3.summary, "Neither")
    }
}

class EnumSummaryTestCase_NotGeneric : TestCase {
    required init?() {}
    var name: String { return "EnumSummary_NotGeneric" }
    var explanation: String { return "Check that non-generic enum summaries show up properly" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        typealias Either = EnumSummaryTestCase_Either
        let t1 = Either.First(1)
        let t2 = Either.Second("A")
        let t3 = Either.Neither
        
        let logdata_t1 = playground_log_impl(t1, "t1", TestHelpers.defaultSourceRange())
        let logdata_t2 = playground_log_impl(t2, "t2", TestHelpers.defaultSourceRange())
        let logdata_t3 = playground_log_impl(t3, "t3", TestHelpers.defaultSourceRange())
        
        let decoded_t1 = TestHelpers.unwrapOrFail( playground_log_decode(logdata_t1) )
        let decoded_t2 = TestHelpers.unwrapOrFail( playground_log_decode(logdata_t2) )
        let decoded_t3 = TestHelpers.unwrapOrFail( playground_log_decode(logdata_t3) )
        
        let structured_t1 = TestHelpers.unwrapOrFail( decoded_t1.object as? PlaygroundDecodedObject_Structured )
        let structured_t2 = TestHelpers.unwrapOrFail( decoded_t2.object as? PlaygroundDecodedObject_Structured )
        let structured_t3 = TestHelpers.unwrapOrFail( decoded_t3.object as? PlaygroundDecodedObject_Structured )
        
        expectEqual(structured_t1.summary, "First(1)")
        expectEqual(structured_t2.summary, "Second(\"A\")")
        expectEqual(structured_t3.summary, "Neither")
    }
}

// fails to compile due to rdar://problem/24781709
//class ViewIsAcceptableViewQuicklookTestCase : TestCase {
//    required init?() {
//#if APPLE_FRAMEWORKS_AVAILABLE
//#else
//    return nil
//#endif
//    }
//    var name: String { return "ViewIsAcceptableViewQuicklook" }
//    var description: String { return "Check that an actual View can be used to generate a QuickLookObject.View" }
//    var behavior: TestBehavior { return .ExpectedSuccess }
//    func doTest() {
//#if os(OSX)
//        class HelperView: NSView {
//            override func drawRect(_ rect: CGRect) {
//                NSColor.redColor().set()
//                NSBezierPath(rect: rect).fill()
//            }
//        }
//        class MyView: NSView , CustomPlaygroundQuickLookable{
//            override func drawRect(_ rect: CGRect) {
//                NSColor.blueColor().set()
//                NSBezierPath(rect: rect).fill()
//            }
//            func customPlaygroundQuickLook() -> PlaygroundQuickLook {
//                let hv = HelperView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//                return PlaygroundQuickLook.View(hv)
//            }
//        }
//
//let thing = MyView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//
//let logdata = playground_log_impl(thing, "thing")
//
//let decoded = TestHelpers.unwrapOrFail( playground_log_decode(logdata) )
//let iderepr = TestHelpers.unwrapOrFail( decoded.object as? PlaygroundDecodedObject_IDERepr )
//
//expectEqual(iderepr.tag, "VIEW")
//
//#endif
//    }
//}

class PrintHookTestCase : TestCase {
    required init?() {}
    var name: String { return "PrintHook" }
    var explanation: String { return "Check that the print hook remembers things you print" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        playground_logger_print_hook("hello world")

        let logdata_1 = playground_log_postprint(0,0,0,0)
        let iderepr_1 = TestHelpers.unwrapOrFail( TestHelpers.unwrapOrFail(playground_log_decode(logdata_1)).object as? PlaygroundDecodedObject_IDERepr )
        expectEqual(iderepr_1.summary, "hello world")
        
        playground_logger_print_hook("not this one")
        playground_logger_print_hook("but this one")

        let logdata_2 = playground_log_postprint(0,0,0,0)
        let iderepr_2 = TestHelpers.unwrapOrFail( TestHelpers.unwrapOrFail(playground_log_decode(logdata_2)).object as? PlaygroundDecodedObject_IDERepr )
        expectEqual(iderepr_2.summary, "but this one")
    }
}
    
class PlaygroundQuickLookCalledOnceTestCase : TestCase {
    required init?() {}
    var name: String { return "PlaygroundQuickLookCalledOnce" }
    var explanation: String { return "Check that the logger only calls customPlaygroundQuickLook() one time per log operation" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        class MyObject : CustomPlaygroundQuickLookable {
            var numCalls = 0
            var customPlaygroundQuickLook: PlaygroundQuickLook {
                get {
                    numCalls = numCalls + 1
                    return PlaygroundQuickLook(reflecting: "Hello world")
                }
            }
        }
        
        let object = MyObject()
        let _ = playground_log_impl(object, "object", TestHelpers.defaultSourceRange())
        
        expectEqual(object.numCalls, 1)
    }
}

class UInt64EightBytesEncodingTestCase : TestCase {
    required init?() {}
    var name: String { return "UInt64EightBytesEncoding" }
    var explanation: String { return "Check that the eight-bytes encoding of UInt64 works" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        let value: UInt64 = 1234
        let stream = BytesStream()
        stream.write(value.toEightBytes())
        let data = stream.data
        let storage = BytesStorage(data)
        let newvalue: UInt64 = TestHelpers.unwrapOrFail( UInt64(eightBytesStorage: storage) )
        expectEqual(value,newvalue, "value should equal newvalue")
    }
}

class ColorLoggingTestCase : TestCase {
    required init?() {
        #if APPLE_FRAMEWORKS_AVAILABLE
        #else
            return nil
        #endif
    }
    var name: String { return "ColorLoggingTestCase" }
    var explanation: String { return "Check that LoggerMirror knows that {NS|UI}Color has quicklook data" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        #if os(OSX)
            let color = NSColor.red
            let mirror = LoggerMirror.reflect(color)
            TestHelpers.unwrapOrFail(mirror.quickLookObject)
        #endif
    }
}

class StructLoggingTestCase : TestCase {
    required init?() {
    }
    var name: String { return "StructLoggingTestCase" }
    var explanation: String { return "Check that LoggerMirror knows that simple types not conforming to CustomPlaygroundQuickLookable don't have quicklook data" }
    var behavior: TestBehavior { return .ExpectedSuccess }
    func doTest() {
        struct S { var a = 1 }
        let mirror = LoggerMirror.reflect(S())
        expectNil(mirror.quickLookObject)
    }
}
    
#endif
