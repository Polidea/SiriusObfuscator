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

enum TestBehavior {
    case ExpectedSuccess
    case ExpectedFailure(String)
    case Skip(String)
    case FailOnNonApplePlatform(String)
    case FailOnApplePlatform(String)
    case Custom(TestRunPredicate)
    
    func toString() -> String {
        switch self {
        case .ExpectedSuccess: return "Expected Success"
        case .ExpectedFailure(let str): return "Expected Failure (\(str))"
        case .Skip(let str): return "Skip (\(str))"
        case .FailOnNonApplePlatform(let str): return "Fail on non-Apple platforms (\(str))"
        case .FailOnApplePlatform(let str): return "Fail on Apple platforms (\(str))"
        case .Custom(let pred): return "Custom (\(pred))"
        }
    }
    
    var isXPass: Bool {
        switch self {
        case .ExpectedSuccess: return true
        default: return false
        }
    }
    
    var isXFail: Bool {
        switch self {
        case .ExpectedFailure(_): return true
        default: return false
        }
    }
    
    
    var isSkip: Bool {
        switch self {
        case .Skip(_): return true
        default: return false
        }
    }
    
    var isCustom: Bool {
        switch self {
        case .Custom(_): return true
        default: return false
        }
    }
}

protocol TestCase: CustomStringConvertible, CustomDebugStringConvertible {
    var name: String { get }
    var explanation: String { get }
    var behavior: TestBehavior { get }
    func doTest()
    init?()
}

extension TestCase {
    var description: String {
        return self.name
    }
    var debugDescription: String {
        return "[\(self.name) - \(self.explanation)]"
    }
}

class TestSuite {
    var test_types: [TestCase.Type]
    
    init(_ types: [TestCase.Type]) {
        test_types = types
    }
    
    func instantiate() -> [TestCase] {
        var tests = [TestCase]()
        for test_type in test_types {
            if let test = test_type.init() {
                tests.append(test)
            }
        }
        return tests
    }
}

public func playground_logger_test() {
    let test_types: [TestCase.Type] = [
        VersionDecodingTestCase.self,
        SourceRangesTestCase.self,
        TIDSentTestCase.self,
        NameDecodingTestCase.self,
        BaseTypesDecodingTestCase.self,
        StructuredTypesDecodingTestCase.self,
        NSNumberDecodingTestCase.self,
        OnePlusOneDecodingTestCase.self,
        MetatypeLoggingTestCase.self,
        ExceptionSafetyTestCase.self,
        NSViewLoggingTestCase.self,
        NSImageLoggingTestCase.self,
        SpriteKitLoggingTestCase.self,
        OptionalGetsStrippedTestCase.self,
        StackWorksTestCase.self,
        NeverLoggingPolicyTestCase.self,
        AdaptiveLoggingPolicyTestCase.self,
        SetIsMembershipContainerTestCase.self,
        TypenameManagementTestCase.self,
        FloatDoubleDecodingTestCase.self,
        SKShapeNodeTestCase.self,
        BaseClassLoggingTestCase.self,
        EnumSummaryTestCase_Generic.self,
        EnumSummaryTestCase_NotGeneric.self,
        //ViewIsAcceptableViewQuicklookTestCase.self,
        PrintHookTestCase.self,
        PlaygroundQuickLookCalledOnceTestCase.self,
        UInt64EightBytesEncodingTestCase.self,
        ColorLoggingTestCase.self,
        StructLoggingTestCase.self
        ]
    
    let suite = TestSuite(test_types)
    let tests = suite.instantiate()

    let ucTest = StdlibUnittest.TestSuite("PlaygroundLogger test suite")
    for test in tests {
        var behavior = test.behavior
        switch test.behavior {
        case .FailOnApplePlatform(let reason):
#if APPLE_FRAMEWORKS_AVAILABLE
    behavior = .ExpectedFailure(reason)
#else
    behavior = .ExpectedSuccess
#endif
        case .FailOnNonApplePlatform(let reason):
#if APPLE_FRAMEWORKS_AVAILABLE
    behavior = .ExpectedSuccess
#else
    behavior = .ExpectedFailure(reason)
#endif
        default: ()
        }
        switch behavior {
            case .ExpectedSuccess: ucTest.test(String(describing: test)) { test.doTest() }
            case .Skip(let reason):
                ucTest.test(String(describing: test)).skip(
                    .custom( { true }, reason: reason )
                ).code { test.doTest() }
            case .ExpectedFailure(let reason):
                ucTest.test(String(describing: test)).xfail(
                    .custom( { true }, reason: reason )
                ).code { test.doTest() }
            case .Custom(let predicate):
                ucTest.test(String(describing: test)).xfail(
                    .custom( { predicate.evaluate() }, reason: predicate.description )
                ).code { test.doTest() }
            default: ()
        }
    }
    StdlibUnittest.runAllTests()
}

struct TestHelpers {
    private init() { assert(false, "Do not create one of me") }
    
    @discardableResult
    static func unwrapOrFail<T>(_ x: T?) -> T {
        let _ = expectNotNil(x)
        return x!
    }
    
    static func defaultSourceRange() -> SourceRange {
        return SourceRange(begin: (line: 0, col: 0), end: (line: 0, col: 0))
    }
}
#endif
