// https://github.com/ncsu-csc512-project/part1-dev
//
// CSC 512 Course Project
//
// Teddy Xinyuan Chen
//
//     xchen87
//
//     200539142
//
//     https://github.com/tddschn

#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

#include "nlohmann/json.hpp"

#include <fstream>
#include <unordered_map>

using namespace llvm;
using Json = nlohmann::json;

namespace {

std::unordered_map<BranchInst *, int> branchIds;
Json jsonBranches;
int branchIdCounter = 1;

void logBranchInstruction(BranchInst *BI, const std::string &filepath) {
  if (BI->isConditional()) {
    if (branchIds.find(BI) == branchIds.end()) {
      branchIds[BI] = branchIdCounter++;
    }
    int id = branchIds[BI];
    int srcLine = BI->getDebugLoc() ? BI->getDebugLoc().getLine() : -1;
    int destLine = -1;
    if (srcLine != -1 && BI->getNumSuccessors() > 0) {
      BasicBlock *DestBlock = BI->getSuccessor(0);
      if (!DestBlock->empty()) {
        Instruction &FirstInstInDest = *DestBlock->begin();
        if (FirstInstInDest.getDebugLoc()) {
          destLine = FirstInstInDest.getDebugLoc().getLine();
        }
      }
    }

    jsonBranches.push_back({{"filepath", filepath},
                            {"branch_id", id},
                            {"src_lno", srcLine},
                            {"dest_lno", destLine}});
  }
}

void logFunctionPointer(CallInst *CI) {
  if (CI->isIndirectCall()) {
    Value *calledValue = CI->getCalledOperand();
    if (calledValue) {
      errs() << "*funcptr_" << calledValue << "\n";
    }
  }
}

void visitor(Function &F) {
  std::string filepath;
  if (DISubprogram *SP = F.getSubprogram()) {
    filepath = SP->getDirectory().str() + "/" + SP->getFilename().str();
  }

  for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) {
    Instruction *Inst = &*I;

    if (BranchInst *BI = dyn_cast<BranchInst>(Inst)) {
      logBranchInstruction(BI, filepath);
    }

    if (CallInst *CI = dyn_cast<CallInst>(Inst)) {
      logFunctionPointer(CI);
    }
  }
}

struct BranchPointerPass : PassInfoMixin<BranchPointerPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    visitor(F);
    return PreservedAnalyses::all();
  }

  static bool isRequired() { return true; }
};

} // namespace

llvm::PassPluginLibraryInfo getBranchPointerPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "BranchPointerPass", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "branch-pointer-pass") {
                    FPM.addPass(BranchPointerPass());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getBranchPointerPluginInfo();
}

struct JsonFileWriter {
  ~JsonFileWriter() {
    std::ofstream file("dict.json");
    file << jsonBranches.dump(4);
    file.close();

    // Output the branch information with full file path in the desired format
    for (const auto &branch : jsonBranches) {
      errs() << "br_" << branch["branch_id"].get<int>() << ": ";
      errs() << branch["filepath"].get<std::string>() << ", ";
      errs() << branch["src_lno"].get<int>() << ", ";
      errs() << branch["dest_lno"].get<int>() << "\n";
    }
  }
} jsonFileWriter;
