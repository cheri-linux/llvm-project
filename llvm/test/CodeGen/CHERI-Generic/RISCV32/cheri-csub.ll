; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: %riscv32_cheri_llc %s -o - | FileCheck %s --check-prefix=HYBRID
; RUN: %riscv32_cheri_purecap_llc %s -o - | FileCheck %s --check-prefix=PURECAP

define i32 @subp(i8 addrspace(200)* readnone %a, i8 addrspace(200)* readnone %b) nounwind {
; HYBRID-LABEL: subp:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    csub a0, ca0, ca1
; HYBRID-NEXT:    ret
;
; PURECAP-LABEL: subp:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    csub a0, ca0, ca1
; PURECAP-NEXT:    cret
entry:
  %0 = tail call i32 @llvm.cheri.cap.diff.i32(i8 addrspace(200)* %a, i8 addrspace(200)* %b)
  ret i32 %0
}

declare i32 @llvm.cheri.cap.diff.i32(i8 addrspace(200)*, i8 addrspace(200)*)
