; ModuleID = 'inputs/input.c'
source_filename = "inputs/input.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx14.0.0"

@.str = private unnamed_addr constant [9 x i8] c"Foo: %d\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [9 x i8] c"Bar: %d\0A\00", align 1, !dbg !7

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @foo(i32 noundef %0) #0 !dbg !19 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !24, metadata !DIExpression()), !dbg !25
  %3 = load i32, ptr %2, align 4, !dbg !26
  %4 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %3), !dbg !27
  ret void, !dbg !28
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone ssp uwtable
define void @bar(i32 noundef %0) #0 !dbg !29 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !30, metadata !DIExpression()), !dbg !31
  %3 = load i32, ptr %2, align 4, !dbg !32
  %4 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %3), !dbg !33
  ret void, !dbg !34
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 !dbg !35 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !38, metadata !DIExpression()), !dbg !40
  call void @llvm.dbg.declare(metadata ptr %3, metadata !41, metadata !DIExpression()), !dbg !42
  store i32 0, ptr %3, align 4, !dbg !43
  br label %4, !dbg !45

4:                                                ; preds = %20, %0
  %5 = load i32, ptr %3, align 4, !dbg !46
  %6 = icmp slt i32 %5, 2, !dbg !48
  br i1 %6, label %7, label %23, !dbg !49

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !50
  %9 = srem i32 %8, 2, !dbg !53
  %10 = icmp eq i32 %9, 0, !dbg !54
  br i1 %10, label %11, label %16, !dbg !55

11:                                               ; preds = %7
  %12 = load i32, ptr %3, align 4, !dbg !56
  %13 = srem i32 %12, 2, !dbg !57
  %14 = icmp eq i32 %13, 0, !dbg !58
  br i1 %14, label %15, label %16, !dbg !59

15:                                               ; preds = %11
  store ptr @foo, ptr %2, align 8, !dbg !60
  br label %17, !dbg !62

16:                                               ; preds = %11, %7
  store ptr @bar, ptr %2, align 8, !dbg !63
  br label %17

17:                                               ; preds = %16, %15
  %18 = load ptr, ptr %2, align 8, !dbg !65
  %19 = load i32, ptr %3, align 4, !dbg !66
  call void %18(i32 noundef %19), !dbg !67
  br label %20, !dbg !68

20:                                               ; preds = %17
  %21 = load i32, ptr %3, align 4, !dbg !69
  %22 = add nsw i32 %21, 1, !dbg !69
  store i32 %22, ptr %3, align 4, !dbg !69
  br label %4, !dbg !70, !llvm.loop !71

23:                                               ; preds = %4
  ret i32 0, !dbg !74
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.dbg.cu = !{!16}
!llvm.ident = !{!18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 3, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "inputs/input.c", directory: "/Users/tscp/testdir/csc512-proj/part1-dev")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 9)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 5, type: !3, isLocal: true, isDefinition: true)
!9 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 0]}
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 8, !"PIC Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 17.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk", sdk: "MacOSX.sdk")
!17 = !{!0, !7}
!18 = !{!"Homebrew clang version 17.0.6"}
!19 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 3, type: !20, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !23)
!20 = !DISubroutineType(types: !21)
!21 = !{null, !22}
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !{}
!24 = !DILocalVariable(name: "x", arg: 1, scope: !19, file: !2, line: 3, type: !22)
!25 = !DILocation(line: 3, column: 14, scope: !19)
!26 = !DILocation(line: 3, column: 39, scope: !19)
!27 = !DILocation(line: 3, column: 19, scope: !19)
!28 = !DILocation(line: 3, column: 43, scope: !19)
!29 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 5, type: !20, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !23)
!30 = !DILocalVariable(name: "x", arg: 1, scope: !29, file: !2, line: 5, type: !22)
!31 = !DILocation(line: 5, column: 14, scope: !29)
!32 = !DILocation(line: 5, column: 39, scope: !29)
!33 = !DILocation(line: 5, column: 19, scope: !29)
!34 = !DILocation(line: 5, column: 43, scope: !29)
!35 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 7, type: !36, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !23)
!36 = !DISubroutineType(types: !37)
!37 = !{!22}
!38 = !DILocalVariable(name: "fun_ptr", scope: !35, file: !2, line: 8, type: !39)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!40 = !DILocation(line: 8, column: 10, scope: !35)
!41 = !DILocalVariable(name: "c", scope: !35, file: !2, line: 9, type: !22)
!42 = !DILocation(line: 9, column: 7, scope: !35)
!43 = !DILocation(line: 12, column: 10, scope: !44)
!44 = distinct !DILexicalBlock(scope: !35, file: !2, line: 12, column: 3)
!45 = !DILocation(line: 12, column: 8, scope: !44)
!46 = !DILocation(line: 12, column: 15, scope: !47)
!47 = distinct !DILexicalBlock(scope: !44, file: !2, line: 12, column: 3)
!48 = !DILocation(line: 12, column: 17, scope: !47)
!49 = !DILocation(line: 12, column: 3, scope: !44)
!50 = !DILocation(line: 13, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !52, file: !2, line: 13, column: 9)
!52 = distinct !DILexicalBlock(scope: !47, file: !2, line: 12, column: 27)
!53 = !DILocation(line: 13, column: 11, scope: !51)
!54 = !DILocation(line: 13, column: 15, scope: !51)
!55 = !DILocation(line: 13, column: 20, scope: !51)
!56 = !DILocation(line: 13, column: 23, scope: !51)
!57 = !DILocation(line: 13, column: 25, scope: !51)
!58 = !DILocation(line: 13, column: 29, scope: !51)
!59 = !DILocation(line: 13, column: 9, scope: !52)
!60 = !DILocation(line: 14, column: 15, scope: !61)
!61 = distinct !DILexicalBlock(scope: !51, file: !2, line: 13, column: 35)
!62 = !DILocation(line: 15, column: 5, scope: !61)
!63 = !DILocation(line: 16, column: 15, scope: !64)
!64 = distinct !DILexicalBlock(scope: !51, file: !2, line: 15, column: 12)
!65 = !DILocation(line: 18, column: 7, scope: !52)
!66 = !DILocation(line: 18, column: 16, scope: !52)
!67 = !DILocation(line: 18, column: 5, scope: !52)
!68 = !DILocation(line: 19, column: 3, scope: !52)
!69 = !DILocation(line: 12, column: 23, scope: !47)
!70 = !DILocation(line: 12, column: 3, scope: !47)
!71 = distinct !{!71, !49, !72, !73}
!72 = !DILocation(line: 19, column: 3, scope: !44)
!73 = !{!"llvm.loop.mustprogress"}
!74 = !DILocation(line: 21, column: 3, scope: !35)
