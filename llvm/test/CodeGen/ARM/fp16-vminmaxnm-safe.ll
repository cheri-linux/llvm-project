; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=armv8-eabi -mattr=+fullfp16 | FileCheck %s
; RUN: llc < %s -mtriple thumbv7a -mattr=+fullfp16 | FileCheck %s

define half @fp16_vminnm_o(half %a, half %b) {
; CHECK-LABEL: fp16_vminnm_o:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r1
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp olt half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vminnm_o_rev(half %a, half %b) {
; CHECK-LABEL: fp16_vminnm_o_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r1
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ogt half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vminnm_u(half %a, half %b) {
; CHECK-LABEL: fp16_vminnm_u:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, r1
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ult half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vminnm_ule(half %a, half %b) {
; CHECK-LABEL: fp16_vminnm_ule:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, r1
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ule half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vminnm_u_rev(half %a, half %b) {
; CHECK-LABEL: fp16_vminnm_u_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r1
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ugt half %a, %b
  %cond = select i1 %cmp, half %b, half %a
  ret half %cond
}

define half @fp16_vmaxnm_o(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_o:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r1
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ogt half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vmaxnm_oge(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_oge:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r1
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp oge half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vmaxnm_o_rev(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_o_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, r1
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp olt half %a, %b
  %cond = select i1 %cmp, half %b, half %a
  ret half %cond
}

define half @fp16_vmaxnm_ole_rev(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_ole_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, r1
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ole half %a, %b
  %cond = select i1 %cmp, half %b, half %a
  ret half %cond
}

define half @fp16_vmaxnm_u(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_u:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, r1
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ugt half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vmaxnm_uge(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_uge:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, r1
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp uge half %a, %b
  %cond = select i1 %cmp, half %a, half %b
  ret half %cond
}

define half @fp16_vmaxnm_u_rev(half %a, half %b) {
; CHECK-LABEL: fp16_vmaxnm_u_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r1
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %cmp = fcmp ult half %a, %b
  %cond = select i1 %cmp, half %b, half %a
  ret half %cond
}

; known non-NaNs

define half @fp16_vminnm_NNNo(half %a) {
; CHECK-LABEL: fp16_vminnm_NNNo:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, #1.200000e+01
; CHECK-NEXT:    vminnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI12_0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI12_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
entry:
  %cmp1 = fcmp olt half %a, 12.
  %cond1 = select i1 %cmp1, half %a, half 12.
  %cmp2 = fcmp olt half 34., %cond1
  %cond2 = select i1 %cmp2, half 34., half %cond1
  ret half %cond2
}

define half @fp16_vminnm_NNNo_rev(half %a) {
; CHECK-LABEL: fp16_vminnm_NNNo_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI13_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vldr.16 s2, .LCPI13_1
; CHECK-NEXT:    vminnm.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI13_0:
; CHECK-NEXT:    .short 0x5300 @ half 56
; CHECK-NEXT:  .LCPI13_1:
; CHECK-NEXT:    .short 0x54e0 @ half 78
entry:
  %cmp1 = fcmp ogt half %a, 56.
  %cond1 = select i1 %cmp1, half 56., half %a
  %cmp2 = fcmp ogt half 78., %cond1
  %cond2 = select i1 %cmp2, half %cond1, half 78.
  ret half %cond2
}

define half @fp16_vminnm_NNNu(half %b) {
; CHECK-LABEL: fp16_vminnm_NNNu:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, #1.200000e+01
; CHECK-NEXT:    vminnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI14_0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI14_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
entry:
  %cmp1 = fcmp ult half 12., %b
  %cond1 = select i1 %cmp1, half 12., half %b
  %cmp2 = fcmp ult half %cond1, 34.
  %cond2 = select i1 %cmp2, half %cond1, half 34.
  ret half %cond2
}

define half @fp16_vminnm_NNNule(half %b) {
; CHECK-LABEL: fp16_vminnm_NNNule:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI15_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vminnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI15_1
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI15_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
; CHECK-NEXT:  .LCPI15_1:
; CHECK-NEXT:    .short 0x5300 @ half 56

entry:
  %cmp1 = fcmp ule half 34., %b
  %cond1 = select i1 %cmp1, half 34., half %b
  %cmp2 = fcmp ule half %cond1, 56.
  %cond2 = select i1 %cmp2, half %cond1, half 56.
  ret half %cond2
}

define half @fp16_vminnm_NNNu_rev(half %b) {
; CHECK-LABEL: fp16_vminnm_NNNu_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI16_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vldr.16 s2, .LCPI16_1
; CHECK-NEXT:    vminnm.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI16_0:
; CHECK-NEXT:    .short 0x5300 @ half 56
; CHECK-NEXT:  .LCPI16_1:
; CHECK-NEXT:    .short 0x54e0 @ half 78


entry:
  %cmp1 = fcmp ugt half 56., %b
  %cond1 = select i1 %cmp1, half %b, half 56.
  %cmp2 = fcmp ugt half %cond1, 78.
  %cond2 = select i1 %cmp2, half 78., half %cond1
  ret half %cond2
}

define half @fp16_vmaxnm_NNNo(half %a) {
; CHECK-LABEL: fp16_vmaxnm_NNNo:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, #1.200000e+01
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI17_0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI17_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
entry:
  %cmp1 = fcmp ogt half %a, 12.
  %cond1 = select i1 %cmp1, half %a, half 12.
  %cmp2 = fcmp ogt half 34., %cond1
  %cond2 = select i1 %cmp2, half 34., half %cond1
  ret half %cond2
}

define half @fp16_vmaxnm_NNNoge(half %a) {
; CHECK-LABEL: fp16_vmaxnm_NNNoge:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI18_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI18_1
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI18_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
; CHECK-NEXT:  .LCPI18_1:
; CHECK-NEXT:    .short 0x5300 @ half 56
entry:
  %cmp1 = fcmp oge half %a, 34.
  %cond1 = select i1 %cmp1, half %a, half 34.
  %cmp2 = fcmp oge half 56., %cond1
  %cond2 = select i1 %cmp2, half 56., half %cond1
  ret half %cond2
}

define half @fp16_vmaxnm_NNNo_rev(half %a) {
; CHECK-LABEL: fp16_vmaxnm_NNNo_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI19_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vldr.16 s2, .LCPI19_1
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI19_0:
; CHECK-NEXT:    .short 0x5300 @ half 56
; CHECK-NEXT:  .LCPI19_1:
; CHECK-NEXT:    .short 0x54e0 @ half 78
entry:
  %cmp1 = fcmp olt half %a, 56.
  %cond1 = select i1 %cmp1, half 56., half %a
  %cmp2 = fcmp olt half 78., %cond1
  %cond2 = select i1 %cmp2, half %cond1, half 78.
  ret half %cond2
}

define half @fp16_vmaxnm_NNNole_rev(half %a) {
; CHECK-LABEL: fp16_vmaxnm_NNNole_rev:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI20_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vldr.16 s2, .LCPI20_1
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI20_0:
; CHECK-NEXT:    .short 0x54e0 @ half 78
; CHECK-NEXT:  .LCPI20_1:
; CHECK-NEXT:    .short 0x55a0 @ half 90
entry:
  %cmp1 = fcmp ole half %a, 78.
  %cond1 = select i1 %cmp1, half 78., half %a
  %cmp2 = fcmp ole half 90., %cond1
  %cond2 = select i1 %cmp2, half %cond1, half 90.
  ret half %cond2
}

define half @fp16_vmaxnm_NNNu(half %b) {
; CHECK-LABEL: fp16_vmaxnm_NNNu:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmov.f16 s2, #1.200000e+01
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI21_0
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI21_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
entry:
  %cmp1 = fcmp ugt half 12., %b
  %cond1 = select i1 %cmp1, half 12., half %b
  %cmp2 = fcmp ugt half %cond1, 34.
  %cond2 = select i1 %cmp2, half %cond1, half 34.
  ret half %cond2
}

define half @fp16_vmaxnm_NNNuge(half %b) {
; CHECK-LABEL: fp16_vmaxnm_NNNuge:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s2, .LCPI22_0
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vldr.16 s2, .LCPI22_1
; CHECK-NEXT:    vcmp.f16 s2, s0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselgt.f16 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI22_0:
; CHECK-NEXT:    .short 0x5040 @ half 34
; CHECK-NEXT:  .LCPI22_1:
; CHECK-NEXT:    .short 0x5300 @ half 56
entry:
  %cmp1 = fcmp uge half 34., %b
  %cond1 = select i1 %cmp1, half 34., half %b
  %cmp2 = fcmp uge half %cond1, 56.
  %cond2 = select i1 %cmp2, half %cond1, half 56.
  ret half %cond2
}

define half @fp16_vminmaxnm_neg0(half %a) {
; CHECK-LABEL: fp16_vminmaxnm_neg0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s0, .LCPI23_0
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vminnm.f16 s2, s2, s0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI23_0:
; CHECK-NEXT:    .short 0x8000 @ half -0
entry:
  %cmp1 = fcmp olt half %a, -0.
  %cond1 = select i1 %cmp1, half %a, half -0.
  %cmp2 = fcmp ugt half %cond1, -0.
  %cond2 = select i1 %cmp2, half %cond1, half -0.
  ret half %cond2
}

define half @fp16_vminmaxnm_e_0(half %a) {
; CHECK-LABEL: fp16_vminmaxnm_e_0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.f16 s0, r0
; CHECK-NEXT:    vldr.16 s2, .LCPI24_0
; CHECK-NEXT:    vcmp.f16 s0, #0
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s2, s0
; CHECK-NEXT:    vmaxnm.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI24_0:
; CHECK-NEXT:    .short 0x0000 @ half 0
entry:
  %cmp1 = fcmp nsz ole half 0., %a
  %cond1 = select i1 %cmp1, half 0., half %a
  %cmp2 = fcmp nsz uge half 0., %cond1
  %cond2 = select i1 %cmp2, half 0., half %cond1
  ret half %cond2
}

define half @fp16_vminmaxnm_e_neg0(half %a) {
; CHECK-LABEL: fp16_vminmaxnm_e_neg0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldr.16 s0, .LCPI25_0
; CHECK-NEXT:    vmov.f16 s2, r0
; CHECK-NEXT:    vminnm.f16 s2, s2, s0
; CHECK-NEXT:    vcmp.f16 s0, s2
; CHECK-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-NEXT:    vselge.f16 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 1
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI25_0:
; CHECK-NEXT:    .short 0x8000 @ half -0
entry:
  %cmp1 = fcmp nsz ule half -0., %a
  %cond1 = select i1 %cmp1, half -0., half %a
  %cmp2 = fcmp nsz oge half -0., %cond1
  %cond2 = select i1 %cmp2, half -0., half %cond1
  ret half %cond2
}
