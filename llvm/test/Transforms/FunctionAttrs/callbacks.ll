; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; FIXME: Add -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations below.
;        This flag was removed because max iterations is 2 in most cases, but in windows it is 1.
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-annotate-decl-cs < %s | FileCheck %s
; ModuleID = 'callback_simple.c'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; Test 0
;
; Make sure we propagate information from the caller to the callback callee but
; only for arguments that are mapped through the callback metadata. Here, the
; first two arguments of the call and the callback callee do not correspond to
; each other but argument 3-5 of the transitive call site in the caller match
; arguments 2-4 of the callback callee. Here we should see information and value
; transfer in both directions.
; FIXME: The callee -> call site direction is not working yet.

define void @t0_caller(i32* %a) {
; CHECK-LABEL: @t0_caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 32
; CHECK-NEXT:    [[C:%.*]] = alloca i32*, align 64
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 128
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[B]] to i8*
; CHECK-NEXT:    store i32 42, i32* [[B]], align 32
; CHECK-NEXT:    store i32* [[B]], i32** [[C]], align 64
; CHECK-NEXT:    call void (i32*, i32*, void (i32*, i32*, ...)*, ...) @t0_callback_broker(i32* noalias null, i32* nonnull align 128 dereferenceable(4) [[PTR]], void (i32*, i32*, ...)* nonnull bitcast (void (i32*, i32*, i32*, i64, i32**)* @t0_callback_callee to void (i32*, i32*, ...)*), i32* [[A:%.*]], i64 99, i32** nonnull align 64 dereferenceable(8) [[C]])
; CHECK-NEXT:    ret void
;
entry:
  %b = alloca i32, align 32
  %c = alloca i32*, align 64
  %ptr = alloca i32, align 128
  %0 = bitcast i32* %b to i8*
  store i32 42, i32* %b, align 4
  store i32* %b, i32** %c, align 8
  call void (i32*, i32*, void (i32*, i32*, ...)*, ...) @t0_callback_broker(i32* null, i32* %ptr, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*, i64, i32**)* @t0_callback_callee to void (i32*, i32*, ...)*), i32* %a, i64 99, i32** %c)
  ret void
}

; Note that the first two arguments are provided by the callback_broker according to the callback in !1 below!
; The others are annotated with alignment information, amongst others, or even replaced by the constants passed to the call.
define internal void @t0_callback_callee(i32* %is_not_null, i32* %ptr, i32* %a, i64 %b, i32** %c) {
; CHECK-LABEL: @t0_callback_callee(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_VAL:%.*]] = load i32, i32* [[PTR:%.*]], align 8
; CHECK-NEXT:    store i32 [[PTR_VAL]], i32* [[IS_NOT_NULL:%.*]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** [[C:%.*]], align 64
; CHECK-NEXT:    tail call void @t0_check(i32* align 256 [[A:%.*]], i64 99, i32* [[TMP0]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr_val = load i32, i32* %ptr, align 8
  store i32 %ptr_val, i32* %is_not_null
  %0 = load i32*, i32** %c, align 8
  tail call void @t0_check(i32* %a, i64 %b, i32* %0)
  ret void
}

declare void @t0_check(i32* align 256, i64, i32*)

declare !callback !0 void @t0_callback_broker(i32*, i32*, void (i32*, i32*, ...)*, ...)

!0 = !{!1}
!1 = !{i64 2, i64 -1, i64 -1, i1 true}
