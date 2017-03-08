//===-- SymbolInfo.cpp - Symbol Info ----------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "SymbolInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/YAMLTraits.h"
#include "llvm/Support/raw_ostream.h"

using llvm::yaml::MappingTraits;
using llvm::yaml::IO;
using llvm::yaml::Input;
using ContextType = clang::find_all_symbols::SymbolInfo::ContextType;
using clang::find_all_symbols::SymbolInfo;
using clang::find_all_symbols::SymbolAndSignals;
using SymbolKind = clang::find_all_symbols::SymbolInfo::SymbolKind;

LLVM_YAML_IS_DOCUMENT_LIST_VECTOR(SymbolAndSignals)
LLVM_YAML_IS_FLOW_SEQUENCE_VECTOR(std::string)
LLVM_YAML_IS_SEQUENCE_VECTOR(SymbolInfo::Context)

namespace llvm {
namespace yaml {
template <> struct MappingTraits<SymbolAndSignals> {
  static void mapping(IO &io, SymbolAndSignals &Symbol) {
    io.mapRequired("Name", Symbol.Symbol.Name);
    io.mapRequired("Contexts", Symbol.Symbol.Contexts);
    io.mapRequired("FilePath", Symbol.Symbol.FilePath);
    io.mapRequired("LineNumber", Symbol.Symbol.LineNumber);
    io.mapRequired("Type", Symbol.Symbol.Type);
    io.mapRequired("Seen", Symbol.Signals.Seen);
    io.mapRequired("Used", Symbol.Signals.Used);
  }
};

template <> struct ScalarEnumerationTraits<ContextType> {
  static void enumeration(IO &io, ContextType &value) {
    io.enumCase(value, "Record", ContextType::Record);
    io.enumCase(value, "Namespace", ContextType::Namespace);
    io.enumCase(value, "EnumDecl", ContextType::EnumDecl);
  }
};

template <> struct ScalarEnumerationTraits<SymbolKind> {
  static void enumeration(IO &io, SymbolKind &value) {
    io.enumCase(value, "Variable", SymbolKind::Variable);
    io.enumCase(value, "Function", SymbolKind::Function);
    io.enumCase(value, "Class", SymbolKind::Class);
    io.enumCase(value, "TypedefName", SymbolKind::TypedefName);
    io.enumCase(value, "EnumDecl", SymbolKind::EnumDecl);
    io.enumCase(value, "EnumConstantDecl", SymbolKind::EnumConstantDecl);
    io.enumCase(value, "Macro", SymbolKind::Macro);
    io.enumCase(value, "Unknown", SymbolKind::Unknown);
  }
};

template <> struct MappingTraits<SymbolInfo::Context> {
  static void mapping(IO &io, SymbolInfo::Context &Context) {
    io.mapRequired("ContextType", Context.first);
    io.mapRequired("ContextName", Context.second);
  }
};

} // namespace yaml
} // namespace llvm

namespace clang {
namespace find_all_symbols {

SymbolInfo::SymbolInfo(llvm::StringRef Name, SymbolKind Type,
                       llvm::StringRef FilePath, int LineNumber,
                       const std::vector<Context> &Contexts)
    : Name(Name), Type(Type), FilePath(FilePath), Contexts(Contexts),
      LineNumber(LineNumber) {}

bool SymbolInfo::operator==(const SymbolInfo &Symbol) const {
  return std::tie(Name, Type, FilePath, LineNumber, Contexts) ==
         std::tie(Symbol.Name, Symbol.Type, Symbol.FilePath, Symbol.LineNumber,
                  Symbol.Contexts);
}

bool SymbolInfo::operator<(const SymbolInfo &Symbol) const {
  return std::tie(Name, Type, FilePath, LineNumber, Contexts) <
         std::tie(Symbol.Name, Symbol.Type, Symbol.FilePath, Symbol.LineNumber,
                  Symbol.Contexts);
}

std::string SymbolInfo::getQualifiedName() const {
  std::string QualifiedName = Name;
  for (const auto &Context : Contexts) {
    if (Context.first == ContextType::EnumDecl)
      continue;
    QualifiedName = Context.second + "::" + QualifiedName;
  }
  return QualifiedName;
}

SymbolInfo::Signals &SymbolInfo::Signals::operator+=(const Signals &RHS) {
  Seen += RHS.Seen;
  Used += RHS.Used;
  return *this;
}

SymbolInfo::Signals SymbolInfo::Signals::operator+(const Signals &RHS) const {
  Signals Result = *this;
  Result += RHS;
  return Result;
}

bool SymbolInfo::Signals::operator==(const Signals &RHS) const {
  return std::tie(Seen, Used) == std::tie(RHS.Seen, RHS.Used);
}

bool SymbolAndSignals::operator==(const SymbolAndSignals& RHS) const {
  return std::tie(Symbol, Signals) == std::tie(RHS.Symbol, RHS.Signals);
}

bool WriteSymbolInfosToStream(llvm::raw_ostream &OS,
                              const SymbolInfo::SignalMap &Symbols) {
  llvm::yaml::Output yout(OS);
  for (const auto &Symbol : Symbols) {
    SymbolAndSignals S{Symbol.first, Symbol.second};
    yout << S;
  }
  return true;
}

std::vector<SymbolAndSignals> ReadSymbolInfosFromYAML(llvm::StringRef Yaml) {
  std::vector<SymbolAndSignals> Symbols;
  llvm::yaml::Input yin(Yaml);
  yin >> Symbols;
  return Symbols;
}

} // namespace find_all_symbols
} // namespace clang
