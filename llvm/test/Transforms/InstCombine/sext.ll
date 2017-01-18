; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128"

declare i32 @llvm.ctpop.i32(i32)
declare i32 @llvm.ctlz.i32(i32, i1)
declare i32 @llvm.cttz.i32(i32, i1)

define i64 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[T:%.*]] = call i32 @llvm.ctpop.i32(i32 %x)
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[T]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %t = call i32 @llvm.ctpop.i32(i32 %x)
  %s = sext i32 %t to i64
  ret i64 %s
}

define i64 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T:%.*]] = call i32 @llvm.ctlz.i32(i32 %x, i1 true)
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[T]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %t = call i32 @llvm.ctlz.i32(i32 %x, i1 true)
  %s = sext i32 %t to i64
  ret i64 %s
}

define i64 @test3(i32 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[T:%.*]] = call i32 @llvm.cttz.i32(i32 %x, i1 true)
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[T]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %t = call i32 @llvm.cttz.i32(i32 %x, i1 true)
  %s = sext i32 %t to i64
  ret i64 %s
}

define i64 @test4(i32 %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[T:%.*]] = udiv i32 %x, 3
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[T]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %t = udiv i32 %x, 3
  %s = sext i32 %t to i64
  ret i64 %s
}

define i64 @test5(i32 %x) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[T:%.*]] = urem i32 %x, 30000
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[T]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %t = urem i32 %x, 30000
  %s = sext i32 %t to i64
  ret i64 %s
}

define i64 @test6(i32 %x) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[U:%.*]] = lshr i32 %x, 3
; CHECK-NEXT:    [[T:%.*]] = mul nuw nsw i32 [[U]], 3
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[T]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %u = lshr i32 %x, 3
  %t = mul i32 %u, 3
  %s = sext i32 %t to i64
  ret i64 %s
}

define i64 @test7(i32 %x) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[T:%.*]] = and i32 %x, 511
; CHECK-NEXT:    [[U:%.*]] = sub nsw i32 20000, [[T]]
; CHECK-NEXT:    [[S1:%.*]] = zext i32 [[U]] to i64
; CHECK-NEXT:    ret i64 [[S1]]
;
  %t = and i32 %x, 511
  %u = sub i32 20000, %t
  %s = sext i32 %u to i64
  ret i64 %s
}

define i32 @test8(i8 %a, i32 %f, i1 %p, i32* %z) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[D:%.*]] = lshr i32 %f, 24
; CHECK-NEXT:    [[N:%.*]] = select i1 %p, i32 [[D]], i32 0
; CHECK-NEXT:    ret i32 [[N]]
;
  %d = lshr i32 %f, 24
  %e = select i1 %p, i32 %d, i32 0
  %s = trunc i32 %e to i16
  %n = sext i16 %s to i32
  ret i32 %n
}

; rdar://6013816
define i16 @test9(i16 %t, i1 %cond) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %cond, label %T, label %F
; CHECK:       T:
; CHECK-NEXT:    br label %F
; CHECK:       F:
; CHECK-NEXT:    [[V_OFF0:%.*]] = phi i16 [ %t, %T ], [ 42, %entry ]
; CHECK-NEXT:    ret i16 [[V_OFF0]]
;
entry:
  br i1 %cond, label %T, label %F
T:
  %t2 = sext i16 %t to i32
  br label %F

F:
  %V = phi i32 [%t2, %T], [42, %entry]
  %W = trunc i32 %V to i16
  ret i16 %W
}

; PR2638
define i32 @test10(i32 %i) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[B1:%.*]] = shl i32 %i, 30
; CHECK-NEXT:    [[B:%.*]] = ashr exact i32 [[B:%.*]]1, 30
; CHECK-NEXT:    ret i32 [[B]]
;
  %tmp12 = trunc i32 %i to i8
  %tmp16 = shl i8 %tmp12, 6
  %a = ashr i8 %tmp16, 6
  %b = sext i8 %a to i32
  ret i32 %b
}

define void @test11(<2 x i16> %srcA, <2 x i16> %srcB, <2 x i16>* %dst) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i16> %srcB, %srcA
; CHECK-NEXT:    [[SEXT:%.*]] = sext <2 x i1> [[CMP]] to <2 x i16>
; CHECK-NEXT:    store <2 x i16> [[SEXT]], <2 x i16>* %dst, align 4
; CHECK-NEXT:    ret void
;
  %cmp = icmp eq <2 x i16> %srcB, %srcA
  %sext = sext <2 x i1> %cmp to <2 x i16>
  %tmask = ashr <2 x i16> %sext, <i16 15, i16 15>
  store <2 x i16> %tmask, <2 x i16>* %dst
  ret void
}

define i64 @test12(i32 %x) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 %x, 1
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[SHR]]
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[SUB]] to i64
; CHECK-NEXT:    ret i64 [[CONV]]
;
  %shr = lshr i32 %x, 1
  %sub = sub nsw i32 0, %shr
  %conv = sext i32 %sub to i64
  ret i64 %conv
}

define i32 @test13(i32 %x) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[AND:%.*]] = lshr i32 %x, 3
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[AND]], 1
; CHECK-NEXT:    [[SEXT:%.*]] = add nsw i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[SEXT]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %ext = sext i1 %cmp to i32
  ret i32 %ext
}

define i32 @test14(i16 %x) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[AND:%.*]] = lshr i16 %x, 4
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 [[AND]], 1
; CHECK-NEXT:    [[SEXT:%.*]] = add nsw i16 [[TMP1]], -1
; CHECK-NEXT:    [[EXT:%.*]] = sext i16 [[SEXT]] to i32
; CHECK-NEXT:    ret i32 [[EXT]]
;
  %and = and i16 %x, 16
  %cmp = icmp ne i16 %and, 16
  %ext = sext i1 %cmp to i32
  ret i32 %ext
}

define i32 @test15(i32 %x) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 %x, 27
; CHECK-NEXT:    [[SEXT:%.*]] = ashr i32 [[TMP1]], 31
; CHECK-NEXT:    ret i32 [[SEXT]]
;
  %and = and i32 %x, 16
  %cmp = icmp ne i32 %and, 0
  %ext = sext i1 %cmp to i32
  ret i32 %ext
}

define i32 @test16(i16 %x) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i16 %x, 12
; CHECK-NEXT:    [[SEXT:%.*]] = ashr i16 [[TMP1]], 15
; CHECK-NEXT:    [[EXT:%.*]] = sext i16 [[SEXT]] to i32
; CHECK-NEXT:    ret i32 [[EXT]]
;
  %and = and i16 %x, 8
  %cmp = icmp eq i16 %and, 8
  %ext = sext i1 %cmp to i32
  ret i32 %ext
}

define i32 @test17(i1 %x) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[C2:%.*]] = zext i1 %x to i32
; CHECK-NEXT:    ret i32 [[C2]]
;
  %c1 = sext i1 %x to i32
  %c2 = sub i32 0, %c1
  ret i32 %c2
}

define i32 @test18(i16 %x) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 %x, 0
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP]], i16 0, i16 %x
; CHECK-NEXT:    [[TMP1:%.*]] = zext i16 [[SEL]] to i32
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i16 %x, 0
  %sel = select i1 %cmp, i16 0, i16 %x
  %ext = sext i16 %sel to i32
  ret i32 %ext
}

