add_swift_unittest(SwiftObfuscationTests
    RandomTests.cpp
    SwiftObfuscationTests.cpp
)

target_link_libraries(SwiftObfuscationTests
    swiftObfuscation
)
