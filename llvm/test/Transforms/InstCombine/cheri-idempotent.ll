; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUNnot: opt -instcombine -S %s -o - -debug-only=instcombine,instsimplify -simplify-cheri-setbounds=false
; RUN: opt -instcombine -S %s -o - | FileCheck %s -check-prefixes CHECK,INSTCOMBINE
; RUN: opt -instsimplify -S %s -o - | FileCheck %s -check-prefixes CHECK,INSTSIMPLIFY
target datalayout = "E-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-n32:64-S128-A200-P200-G200"
target triple = "cheri-unknown-freebsd"

declare i64 @llvm.cheri.cap.diff.i64(i8 addrspace(200)*, i8 addrspace(200)*) addrspace(200) #1
declare i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)*, i64) addrspace(200) #1
declare i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)*, i64) addrspace(200) #1
declare i8 addrspace(200)* @llvm.cheri.cap.address.set.i64(i8 addrspace(200)*, i64) addrspace(200) #1


declare void @use(i8 addrspace(200)*) addrspace(200) #1


define i8 addrspace(200)* @setbounds_idempotent(i8 addrspace(200)* %ptr, i64 %size) {
; Same argument so we can combine
; CHECK-LABEL: @setbounds_idempotent(
; CHECK-NEXT:    [[FIRST:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    ret i8 addrspace(200)* [[FIRST]]
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %ptr, i64 %size)
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %first, i64 %size)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %second, i64 %size)
  ret i8 addrspace(200)* %third
}

define i8 addrspace(200)* @setbounds_different_args_1(i8 addrspace(200)* %ptr, i64 %size) {
; Can't combine here:
; CHECK-LABEL: @setbounds_different_args_1(
; CHECK-NEXT:    [[FIRST:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    [[SECOND:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[FIRST]], i64 1)
; CHECK-NEXT:    [[THIRD:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[SECOND]], i64 [[SIZE]])
; CHECK-NEXT:    ret i8 addrspace(200)* [[THIRD]]
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %ptr, i64 %size)
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %first, i64 1)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %second, i64 %size)
  ret i8 addrspace(200)* %third
}

; If one of the instructions is a setbounds exact we have to use the exact version:
define i8 addrspace(200)* @setbounds_idempotent_exact1(i8 addrspace(200)* %ptr, i64 %size) {
; Must use exact version when combining
; CHECK-LABEL: @setbounds_idempotent_exact1(
; CHECK-NEXT:    [[FIRST:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    ret i8 addrspace(200)* [[FIRST]]
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %ptr, i64 %size)
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %first, i64 %size)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %second, i64 %size)
  ret i8 addrspace(200)* %third
}

define i8 addrspace(200)* @setbounds_idempotent_exact2(i8 addrspace(200)* %ptr, i64 %size) {
; Must use exact version when combining
; CHECK-LABEL: @setbounds_idempotent_exact2(
; Can't upgrade inexact to exact when running instsimplify
; INSTSIMPLIFY-NEXT: [[PTR:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    [[SECOND:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    ret i8 addrspace(200)* [[SECOND]]
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %ptr, i64 %size)
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %first, i64 %size)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %second, i64 %size)
  ret i8 addrspace(200)* %third
}

define i8 addrspace(200)* @setbounds_idempotent_exact3(i8 addrspace(200)* %ptr, i64 %size) {
; Must use exact version when combining
; CHECK-LABEL: @setbounds_idempotent_exact3(
; Can't upgrade inexact to exact when running instsimplify
; INSTSIMPLIFY-NEXT: [[PTR:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    [[THIRD:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    ret i8 addrspace(200)* [[THIRD]]
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %ptr, i64 %size)
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %first, i64 %size)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %second, i64 %size)
  ret i8 addrspace(200)* %third
}

define i8 addrspace(200)* @setbounds_idempotent_exact4(i8 addrspace(200)* %ptr, i64 %size) {
; Must use exact version when combining
; CHECK-LABEL: @setbounds_idempotent_exact4(
; CHECK-NEXT:    [[THIRD:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    ret i8 addrspace(200)* [[THIRD]]
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %ptr, i64 %size)
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %first, i64 %size)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %second, i64 %size)
  ret i8 addrspace(200)* %third
}

define i8 addrspace(200)* @no_remove_exact(i8 addrspace(200)* %ptr, i64 %size, i1 %maybe_use) {
; Can't just replace the inexact version with exact if the exact one might not be used (this could trigger a trap)
; CHECK-LABEL: @no_remove_exact(
; INSTSIMPLIFY-NEXT:    [[FIRST:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    br i1 [[MAYBE_USE:%.*]], label [[USE:%.*]], label [[NO_USE:%.*]]
; CHECK:       use:
; INSTCOMBINE-NEXT:    [[FIRST:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* [[PTR:%.*]], i64 [[SIZE:%.*]])
; CHECK-NEXT:    call void @use(i8 addrspace(200)* [[FIRST]])
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       no_use:
; INSTCOMBINE-NEXT:    [[THIRD:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* [[PTR]], i64 [[SIZE]])
; INSTSIMPLIFY-NEXT:    [[THIRD:%.*]] = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* [[FIRST]], i64 [[SIZE]])
; CHECK-NEXT:    call void @use(i8 addrspace(200)* [[THIRD]])
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret i8 addrspace(200)* null
;
  %first = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %ptr, i64 %size)
  br i1 %maybe_use, label %use, label %no_use
use:
  call void @use(i8 addrspace(200)* %first)
  br label %end
no_use:
  %second = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.i64(i8 addrspace(200)* %first, i64 %size)
  %third = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact.i64(i8 addrspace(200)* %second, i64 %size)
  call void @use(i8 addrspace(200)* %third)
  br label %end
end:
  ret i8 addrspace(200)* null
}
