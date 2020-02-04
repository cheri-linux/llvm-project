; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: %riscv64_cheri_purecap_llc -mattr=+d -verify-machineinstrs < %s
; RUN: %riscv64_cheri_purecap_llc -mattr=+d -verify-machineinstrs -relocation-model=pic < %s
; RUN: %riscv64_cheri_purecap_llc -mattr=+d -verify-machineinstrs < %s | FileCheck %s

target datalayout = "A200-P200-G200" ; Needed for blockaddress to work

; Constant pools should not use the captable:
define double @constant_pool(double %a) nounwind {
; CHECK-LABEL: constant_pool:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB0_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca1, %pcrel_hi(.LCPI0_0)
; CHECK-NEXT:    cincoffset ca1, ca1, %pcrel_lo(.LBB0_1)
; CHECK-NEXT:    cfld ft0, 0(ca1)
; CHECK-NEXT:    fmv.d.x ft1, a0
; CHECK-NEXT:    fadd.d ft0, ft1, ft0
; CHECK-NEXT:    fmv.x.d a0, ft0
; CHECK-NEXT:    cret
  %1 = fadd double %a, 1.0
  ret double %1
}


; Block addresses should also use auipcc+cincoffset
define i8 addrspace(200)* @blockaddress() nounwind {
; CHECK-LABEL: blockaddress:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:  .Ltmp0: # Block address taken
; CHECK-NEXT:  # %bb.1: # %block
; CHECK-NEXT:  .LBB1_2: # %block
; CHECK-NEXT:    # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %pcrel_hi(.Ltmp0)
; CHECK-NEXT:    cincoffset ca0, ca0, %pcrel_lo(.LBB1_2)
; CHECK-NEXT:    cret
entry:
  br label %block
block:
  ret i8 addrspace(200)* blockaddress(@blockaddress, %block)
}

; External variables always have to be loaded from the captable to get bounds
; and to allow for them to be provided by another DSO without requiring copy
; relocations. Read-only accesses in the same DSO *could* theoretically use
; pc-relative addressing, but that would mean we get a capability bounded
; to the $pcc bounds and therefore would not be checked when we pass the
; reference to another function. Therefore, we always load from the captable
; for all global variables.

@external_variable = external addrspace(200) global i64
define i64 @load_external_global_variable(double %a) nounwind {
; CHECK-LABEL: load_external_global_variable:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB2_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(external_variable)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB2_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @external_variable
  ret i64 %ret
}

@external_constant = external addrspace(200) constant i64
define i64 @load_external_global_constant(double %a) nounwind {
; CHECK-LABEL: load_external_global_constant:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB3_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(external_constant)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB3_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @external_constant
  ret i64 %ret
}

@dso_local_external_variable = external dso_local addrspace(200) global i64
define i64 @load_dso_local_external_global_variable(double %a) nounwind {
; CHECK-LABEL: load_dso_local_external_global_variable:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB4_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(dso_local_external_variable)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB4_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @dso_local_external_variable
  ret i64 %ret
}

; But not if they are defined in the same DSO:
@dso_local_external_constant = external dso_local addrspace(200) constant i64
define i64 @load_dso_local_external_global_constant(double %a) nounwind {
; CHECK-LABEL: load_dso_local_external_global_constant:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB5_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(dso_local_external_constant)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB5_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @dso_local_external_constant
  ret i64 %ret
}

@defined_variable = addrspace(200) global i64 1
define i64 @load_defined_variable(double %a) nounwind {
; CHECK-LABEL: load_defined_variable:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB6_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(defined_variable)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB6_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @defined_variable
  ret i64 %ret
}

@defined_constant = hidden addrspace(200) constant i64 2
define i64 @load_defined_constant(double %a) nounwind {
; CHECK-LABEL: load_defined_constant:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB7_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(defined_constant)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB7_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @defined_constant
  ret i64 %ret
}

@hidden_variable = hidden addrspace(200) global i64 3
define i64 @load_hidden_variable(double %a) nounwind {
; CHECK-LABEL: load_hidden_variable:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB8_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(hidden_variable)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB8_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @hidden_variable
  ret i64 %ret
}

@hidden_constant = hidden addrspace(200) constant i64 4
define i64 @load_hidden_constant(double %a) nounwind {
; CHECK-LABEL: load_hidden_constant:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB9_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(hidden_constant)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB9_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @hidden_constant
  ret i64 %ret
}

@dso_local_variable = dso_local addrspace(200) global i64 5
define i64 @load_dso_local_variable(double %a) nounwind {
; CHECK-LABEL: load_dso_local_variable:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB10_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(dso_local_variable)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB10_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @dso_local_variable
  ret i64 %ret
}

@dso_local_constant = dso_local addrspace(200) constant i64 6
define i64 @load_dso_local_constant(double %a) nounwind {
; CHECK-LABEL: load_dso_local_constant:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .LBB11_1: # Label of block must be emitted
; CHECK-NEXT:    auipcc ca0, %captab_pcrel_hi(dso_local_constant)
; CHECK-NEXT:    clc ca0, %pcrel_lo(.LBB11_1)(ca0)
; CHECK-NEXT:    cld a0, 0(ca0)
; CHECK-NEXT:    cret
  %ret = load i64, i64 addrspace(200)* @dso_local_constant
  ret i64 %ret
}
