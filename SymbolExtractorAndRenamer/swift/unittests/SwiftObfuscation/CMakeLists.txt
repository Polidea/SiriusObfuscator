add_swift_unittest(SwiftObfuscationTests
    RandomTests.cpp
    SwiftObfuscationTests.cpp
    FileIOTests.cpp
    DataStructuresOperatorsTests.cpp
    DataStructuresSerializationTests.cpp
    DataStructuresDeserializationTests.cpp
)

target_link_libraries(SwiftObfuscationTests
    swiftObfuscation
)
