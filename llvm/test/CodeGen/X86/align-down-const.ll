; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X64

; Fold
;   ptr - (ptr & C)
; To
;   ptr & (~C)
;
; This needs to be a backend-level fold because only by now pointers
; are just registers; in middle-end IR this can only be done via @llvm.ptrmask()
; intrinsic which is not sufficiently widely-spread yet.
;
; https://bugs.llvm.org/show_bug.cgi?id=44448

; The basic positive tests

define i32 @t0_32(i32 %ptr) nounwind {
; X86-LABEL: t0_32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $15, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t0_32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    andl $15, %ecx
; X64-NEXT:    subl %ecx, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, 15
  %r = sub i32 %ptr, %bias
  ret i32 %r
}
define i64 @t1_64(i64 %ptr) nounwind {
; X86-LABEL: t1_64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $15, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    sbbl $0, %edx
; X86-NEXT:    retl
;
; X64-LABEL: t1_64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    andl $15, %ecx
; X64-NEXT:    subq %rcx, %rax
; X64-NEXT:    retq
  %bias = and i64 %ptr, 15
  %r = sub i64 %ptr, %bias
  ret i64 %r
}

define i32 @t2_powerof2(i32 %ptr) nounwind {
; X86-LABEL: t2_powerof2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $16, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t2_powerof2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    andl $16, %ecx
; X64-NEXT:    subl %ecx, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, 16
  %r = sub i32 %ptr, %bias
  ret i32 %r
}
define i32 @t3_random_constant(i32 %ptr) nounwind {
; X86-LABEL: t3_random_constant:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $42, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t3_random_constant:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    andl $42, %ecx
; X64-NEXT:    subl %ecx, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, 42
  %r = sub i32 %ptr, %bias
  ret i32 %r
}

; Extra use tests

define i32 @t4_extrause(i32 %ptr, i32* %bias_storage) nounwind {
; X86-LABEL: t4_extrause:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    andl $15, %edx
; X86-NEXT:    movl %edx, (%ecx)
; X86-NEXT:    subl %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t4_extrause:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    andl $15, %ecx
; X64-NEXT:    movl %ecx, (%rsi)
; X64-NEXT:    subl %ecx, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, 15
  store i32 %bias, i32* %bias_storage
  %r = sub i32 %ptr, %bias
  ret i32 %r
}

; Negative tests

define i32 @n5_different_ptrs(i32 %ptr0, i32 %ptr1) nounwind {
; X86-LABEL: n5_different_ptrs:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl $15, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n5_different_ptrs:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $15, %esi
; X64-NEXT:    subl %esi, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr1, 15 ; not %ptr0
  %r = sub i32 %ptr0, %bias ; not %ptr1
  ret i32 %r
}

define i32 @n6_sub_is_not_commutative(i32 %ptr) nounwind {
; X86-LABEL: n6_sub_is_not_commutative:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    andl $15, %eax
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n6_sub_is_not_commutative:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $15, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, 15
  %r = sub i32 %bias, %ptr ; wrong order
  ret i32 %r
}
