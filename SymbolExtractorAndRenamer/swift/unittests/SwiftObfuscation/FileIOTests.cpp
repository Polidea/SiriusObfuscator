#include "llvm/Support/FileSystem.h"

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/FileIO.h"
#include "swift/Obfuscation/Utils.h"
#include "gtest/gtest.h"

namespace swift {
namespace obfuscation {

using BufferOrError = llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>>;

struct FakeMemoryBuffer: protected llvm::MemoryBuffer {

    bool hasAskedForBufferViaGetFile;
    std::string Path;

    FakeMemoryBuffer(bool hasAskedForBufferViaGetFile, std::string Path)
    : hasAskedForBufferViaGetFile(hasAskedForBufferViaGetFile), Path(Path) {};

    BufferKind getBufferKind() const override { return MemoryBuffer_Malloc; }

    StringRef getBufferIdentifier() const override {
        return StringRef("Fake");
    }

    static std::string Payload;

    static llvm::ErrorOr<std::unique_ptr<MemoryBuffer>>
    getFile(const Twine &Filename, int64_t FileSize = -1,
            bool RequiresNullTerminator = true, bool IsVolatileSize = false) {
        FakeMemoryBuffer *Buffer = new FakeMemoryBuffer(true, Filename.str());
        StringRef Text(Payload);
        Buffer->init(reinterpret_cast<const char *>(Text.bytes_begin()),
                     reinterpret_cast<const char *>(Text.bytes_end()),
                     false);
        std::unique_ptr<llvm::MemoryBuffer> MB(Buffer);
        return std::move(MB);
    }
};

std::string FakeMemoryBuffer::Payload;

struct FakeMemoryBufferProvider: MemoryBufferProvider {
    std::error_code Error;

    virtual llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>>
    getBuffer(std::string Path) const override {
        if (Error) {
            return Error;
        }
        return FakeMemoryBuffer::getFile(Path);
    }
};

TEST(ParseJson, ErrorReadingFile) {
    FakeMemoryBufferProvider FakeProvider = FakeMemoryBufferProvider();
    std::error_code Error(1, std::generic_category());
    FakeProvider.Error = Error;
    std::string Path = "";
    std::string Expected = "Error during JSON file read";

    auto Result = parseJson<FilesJson>(Path, FakeProvider);

    if (llvm::Error Error = Result.takeError()) {
        std::string Result = llvm::toString(std::move(Error));
        EXPECT_EQ(Result, Expected);
        return;
    }
    EXPECT_TRUE(false);
}

TEST(ParseJson, ErrorParsingText) {
    FakeMemoryBufferProvider FakeProvider = FakeMemoryBufferProvider();
    FakeMemoryBuffer::Payload = "test json";
    std::string Path = "";
    std::string Expected = "Error during JSON parse";

    auto Result = parseJson<FilesJson>(Path, FakeProvider);

    if (llvm::Error Error = Result.takeError()) {
        std::string Result = llvm::toString(std::move(Error));
        EXPECT_EQ(Result, Expected);
        return;
    }
    EXPECT_TRUE(false);
}

TEST(ParseJson, SuccessParsingText) {
    FakeMemoryBufferProvider FakeProvider = FakeMemoryBufferProvider();
    std::string RootPath = "testRootPath";
    std::string ModuleName = "testModuleName";
    std::string SdkName = "testName";
    std::string SdkPath = "testSDKPath";
    std::string FileName1 = "testFileName1";
    std::string FileName2 = "testFileName2";
    std::string ExplicitFrameworkName = "testExplicitFrameworkName";
    std::string ExplicitFrameworkPath = "testExplicitFrameworkPath";
    std::string SystemFramework = "testSystemFramework";
    FakeMemoryBuffer::Payload = "{\r\n  \"project\":{\r\n"
        "\"rootPath\":\"" + RootPath + "\"\r\n   },"
        "\"module\":{\r\n"
        "\"name\":\"" + ModuleName + "\"\r\n   },\r\n"
        "\"sdk\":{\r\n"
        "\"name\":\"" + SdkName + "\",\r\n"
        "\"path\":\"" + SdkPath + "\"\r\n   },\r\n"
        "\"filenames\":[\r\n"
        "\"" + FileName1 + "\",\r\n"
        "\"" + FileName2 + "\"\r\n   ],\r\n"
        "\"explicitelyLinkedFrameworks\":[\r\n {\r\n"
        "\"name\":\"" + ExplicitFrameworkName + "\",\r\n"
        "\"path\":\"" + ExplicitFrameworkPath + "\"\r\n }\r\n ],\r\n"
        "\"systemLinkedFrameworks\":[\r\n \"" + SystemFramework + "\"\r\n   ]\r\n}";
    std::string Path = "";
    std::string Expected = "Error during JSON parse";

    auto Result = parseJson<FilesJson>(Path, FakeProvider);

    if (llvm::Error Error = Result.takeError()) {
        std::string Result = llvm::toString(std::move(Error));
        FAIL() << "Json should be parsed";
        return;
    }
    auto FilesJson = Result.get();
    EXPECT_EQ(FilesJson.Project.RootPath, RootPath);
    EXPECT_EQ(FilesJson.Module.Name, ModuleName);
    EXPECT_EQ(FilesJson.Sdk.Name, SdkName);
    EXPECT_EQ(FilesJson.Sdk.Path, SdkPath);
    std::vector<std::string> ExpectedFilenames = {FileName1, FileName2};
    EXPECT_EQ(FilesJson.Filenames, ExpectedFilenames);
    EXPECT_EQ(FilesJson.ExplicitelyLinkedFrameworks.size(), 1U);
    EXPECT_EQ(FilesJson.ExplicitelyLinkedFrameworks[0].Name, ExplicitFrameworkName);
    EXPECT_EQ(FilesJson.ExplicitelyLinkedFrameworks[0].Path, ExplicitFrameworkPath);
    EXPECT_EQ(FilesJson.SystemLinkedFrameworks.size(), 1U);
    EXPECT_EQ(FilesJson.SystemLinkedFrameworks[0], SystemFramework);
}

struct FakeFile {
    static bool DidClose;
    static std::string CapturedString;

    FakeFile() { }

    FakeFile(StringRef Filename, std::error_code &EC,
             llvm::sys::fs::OpenFlags Flags) { }

    FakeFile &operator<<(const std::string &Str) {
        CapturedString = Str;
        return *this;
    }

    void close() {
        DidClose = true;
    }
};

bool FakeFile::DidClose;
std::string FakeFile::CapturedString;

struct FakeFileFactory: FileFactory<FakeFile> {
    std::error_code Error;

    FakeFileFactory() { };

    llvm::ErrorOr<std::unique_ptr<FakeFile>>
    getFile(std::string Path) override {
        if (Error) {
            return Error;
        }

        return llvm::make_unique<FakeFile>();
    }
};

TEST(WriteToFile, SuccessWriting) {
    std::string PathToOutput = "";
    Symbol FakeSymbol = Symbol("testIdentifier",
                               "testName",
                               "testModule",
                               SymbolType::Type);
    SymbolsJson JsonToWrite;
    JsonToWrite.Symbols.push_back(FakeSymbol);
    FakeFileFactory Factory = FakeFileFactory();
    FakeFile::DidClose = false;
    std::string Expected = "{\n  \"symbols\": [\n    {\n      "
        "\"name\": \"testName\",\n      "
        "\"identifier\": \"testIdentifier\",\n      "
        "\"module\": \"testModule\",\n      "
        "\"type\": \"type\"\n    "
        "}\n  ]\n}";

    auto Error = writeToPath(JsonToWrite,
                             PathToOutput,
                             Factory,
                             llvm::outs());
    if (Error) {
        llvm::consumeError(std::move(Error));
        EXPECT_TRUE(false) << "should be parsed correctly";
    }

    EXPECT_EQ(FakeFile::CapturedString, Expected) << "should write correct string";
    EXPECT_TRUE(FakeFile::DidClose) << "should close file after write";
}

}
}
