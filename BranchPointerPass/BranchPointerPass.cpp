#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h" // Include for BranchInst
#include "llvm/IR/InstIterator.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

    void logBranchInstruction(BranchInst *BI) {
        if (BI->isConditional()) {
            errs() << "br_" << BI->getParent()->getName() << "\n";
        }
    }

    void logFunctionPointer(CallInst *CI) {
        if (Function *calledFunction = CI->getCalledFunction()) {
            errs() << "*func_" << calledFunction << "\n";
        }
    }

    void visitor(Function &F) {
        errs() << "Analyzing function " << F.getName() << '\n';

        for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) {
            Instruction *Inst = &*I;

            if (BranchInst *BI = dyn_cast<BranchInst>(Inst)) {
                errs() << "Found a branch instruction!\n";
                logBranchInstruction(BI);
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
                    [](StringRef Name, FunctionPassManager &FPM, ArrayRef<PassBuilder::PipelineElement>) {
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
