#include "swift/Obfuscation/DataStructures.h"
#include "gtest/gtest.h"

using namespace swift;
using namespace swift::obfuscation;
using namespace llvm;

auto Symbol1 = Symbol("a_id", "a_name", "a_module", SymbolType::Operator);
auto Symbol1_1 = Symbol("a_id", "a_name", "a_module", SymbolType::Operator);
auto Symbol2 = Symbol("b_id", "a_name", "a_module", SymbolType::Operator);
auto Symbol3 = Symbol("a_id", "b_name", "a_module", SymbolType::Operator);
auto Symbol4 = Symbol("a_id", "a_name", "b_module", SymbolType::Operator);
auto Symbol5 = Symbol("a_id", "a_name", "a_module", SymbolType::NamedFunction);

TEST(SymbolLessThanOperator, ComparingIdentifierLess) {
  EXPECT_TRUE(Symbol1 < Symbol2);
}

TEST(SymbolLessThanOperator, ComparingIdentifierGreater) {
  EXPECT_FALSE(Symbol2 < Symbol1);
}

TEST(SymbolLessThanOperator, ComparingIdentifierEqual) {
  EXPECT_FALSE(Symbol1 < Symbol1_1);
}

TEST(SymbolEqualOperator, ComparingSymbolEqual) {
  EXPECT_TRUE(Symbol1 == Symbol1_1);
}

TEST(SymbolEqualOperator, ComparingSymbolNotEqualIdentifier) {
  EXPECT_FALSE(Symbol1 == Symbol2);
}

TEST(SymbolEqualOperator, ComparingSymbolNotEqualName) {
  EXPECT_FALSE(Symbol1 == Symbol3);
}

TEST(SymbolEqualOperator, ComparingSymbolNotEqualModule) {
  EXPECT_FALSE(Symbol1 == Symbol4);
}

TEST(SymbolEqualOperator, ComparingSymbolNotEqualType) {
  EXPECT_FALSE(Symbol1 == Symbol5);
}

std::string SourceContents = "sample source contents";

auto SourceLoc1 = SourceLoc(SMLoc::getFromPointer(SourceContents.c_str()));
auto SourceLoc2 = SourceLoc(SMLoc::getFromPointer(SourceContents.substr(1).c_str()));

auto SourceRange1 = CharSourceRange(SourceLoc1, 2);
auto SourceRange2 = CharSourceRange(SourceLoc2, 3);

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsLessRangesLess) {
  EXPECT_TRUE(SymbolWithRange(Symbol1, SourceRange1)
              < SymbolWithRange(Symbol2, SourceRange2));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsLessRangesGreater) {
  EXPECT_TRUE(SymbolWithRange(Symbol1, SourceRange2)
              < SymbolWithRange(Symbol2, SourceRange1));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsLessRangesEqual) {
  EXPECT_TRUE(SymbolWithRange(Symbol1, SourceRange1)
              < SymbolWithRange(Symbol2, SourceRange1));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsGreaterRangesLess) {
  EXPECT_FALSE(SymbolWithRange(Symbol2, SourceRange1)
              < SymbolWithRange(Symbol1, SourceRange2));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsGreaterRangesGreater) {
  EXPECT_FALSE(SymbolWithRange(Symbol2, SourceRange2)
               < SymbolWithRange(Symbol1, SourceRange1));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsGreaterRangesEqual) {
  EXPECT_FALSE(SymbolWithRange(Symbol2, SourceRange1)
               < SymbolWithRange(Symbol1, SourceRange1));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsEqualRangesLess) {
  EXPECT_TRUE(SymbolWithRange(Symbol1, SourceRange1)
              < SymbolWithRange(Symbol1, SourceRange2));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsEqualRangesGreater) {
  EXPECT_FALSE(SymbolWithRange(Symbol1, SourceRange2)
               < SymbolWithRange(Symbol1, SourceRange1));
}

TEST(SymbolWithRangeLessThanOperator, ComparingSymbolsEqualRangesEqual) {
  EXPECT_FALSE(SymbolWithRange(Symbol1, SourceRange1)
               < SymbolWithRange(Symbol1, SourceRange1));
}

auto SymbolRenaming1 = SymbolRenaming("a_id", "a_name", "a_obfuscated_name", "a_module", SymbolType::Type);
auto SymbolRenaming1_1 = SymbolRenaming("a_id", "a_name", "a_obfuscated_name", "a_module", SymbolType::Type);
auto SymbolRenaming2 = SymbolRenaming("b_id", "a_name", "a_obfuscated_name", "a_module", SymbolType::Type);
auto SymbolRenaming3 = SymbolRenaming("a_id", "b_name", "a_obfuscated_name", "a_module", SymbolType::Type);
auto SymbolRenaming4 = SymbolRenaming("a_id", "a_name", "b_obfuscated_name", "a_module", SymbolType::Type);
auto SymbolRenaming5 = SymbolRenaming("a_id", "a_name", "a_obfuscated_name", "b_module", SymbolType::Type);
auto SymbolRenaming6 = SymbolRenaming("a_id", "a_name", "a_obfuscated_name", "a_module", SymbolType::Operator);

TEST(SymbolRenamingEqualOperator, ComparingSymbolRenamingsEqual) {
  EXPECT_TRUE(SymbolRenaming1 == SymbolRenaming1_1);
}

TEST(SymbolRenamingEqualOperator, ComparingSymbolRenamingsNotEqualIdentifier) {
  EXPECT_FALSE(SymbolRenaming1 == SymbolRenaming2);
}

TEST(SymbolRenamingEqualOperator, ComparingSymbolRenamingsNotEqualOriginalName) {
  EXPECT_FALSE(SymbolRenaming1 == SymbolRenaming3);
}

TEST(SymbolRenamingEqualOperator, ComparingSymbolRenamingsNotEqualObfuscatedName) {
  EXPECT_FALSE(SymbolRenaming1 == SymbolRenaming4);
}

TEST(SymbolRenamingEqualOperator, ComparingSymbolRenamingsNotEqualModule) {
  EXPECT_FALSE(SymbolRenaming1 == SymbolRenaming5);
}

TEST(SymbolRenamingEqualOperator, ComparingSymbolRenamingsNotEqualType) {
  EXPECT_FALSE(SymbolRenaming1 == SymbolRenaming6);
}
