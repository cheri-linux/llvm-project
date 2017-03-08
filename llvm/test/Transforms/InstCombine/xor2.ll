; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; PR1253
define i1 @test0(i32 %A) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 %A, 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = xor i32 %A, -2147483648
  %C = icmp sgt i32 %B, -1
  ret i1 %C
}

define <2 x i1> @test0vec(<2 x i32> %A) {
; CHECK-LABEL: @test0vec(
; CHECK-NEXT:    [[C:%.*]] = icmp slt <2 x i32> %A, zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = xor <2 x i32> %A, <i32 -2147483648, i32 -2147483648>
  %C = icmp sgt <2 x i32> %B, <i32 -1, i32 -1>
  ret <2 x i1> %C
}

define i1 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 %A, 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = xor i32 %A, 12345
  %C = icmp slt i32 %B, 0
  ret i1 %C
}

; PR1014
define i32 @test2(i32 %tmp1) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[OVM:%.*]] = and i32 %tmp1, 32
; CHECK-NEXT:    [[OV1101:%.*]] = or i32 [[OVM]], 8
; CHECK-NEXT:    ret i32 [[OV1101]]
;
  %ovm = and i32 %tmp1, 32
  %ov3 = add i32 %ovm, 145
  %ov110 = xor i32 %ov3, 153
  ret i32 %ov110
}

define i32 @test3(i32 %tmp1) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[OVM:%.*]] = and i32 %tmp1, 32
; CHECK-NEXT:    [[OV1101:%.*]] = or i32 [[OVM]], 8
; CHECK-NEXT:    ret i32 [[OV1101]]
;
  %ovm = or i32 %tmp1, 145
  %ov31 = and i32 %ovm, 177
  %ov110 = xor i32 %ov31, 153
  ret i32 %ov110
}

define i32 @test4(i32 %A, i32 %B) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i32 %A, %B
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = xor i32 %A, -1
  %2 = ashr i32 %1, %B
  %3 = xor i32 %2, -1
  ret i32 %3
}

; defect-2 in rdar://12329730
; (X^C1) >> C2) ^ C3 -> (X>>C2) ^ ((C1>>C2)^C3)
;   where the "X" has more than one use
define i32 @test5(i32 %val1) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 %val1, 1234
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 %val1, 8
; CHECK-NEXT:    [[XOR1:%.*]] = xor i32 [[SHR]], 5
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[XOR1]], [[XOR]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %xor = xor i32 %val1, 1234
  %shr = lshr i32 %xor, 8
  %xor1 = xor i32 %shr, 1
  %add = add i32 %xor1, %xor
  ret i32 %add
}

; defect-1 in rdar://12329730
; Simplify (X^Y) -> X or Y in the user's context if we know that
; only bits from X or Y are demanded.
; e.g. the "x ^ 1234" can be optimized into x in the context of "t >> 16".
;  Put in other word, t >> 16 -> x >> 16.
; unsigned foo(unsigned x) { unsigned t = x ^ 1234; ;  return (t >> 16) + t;}
define i32 @test6(i32 %x) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 %x, 1234
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 %x, 16
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[SHR]], [[XOR]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %xor = xor i32 %x, 1234
  %shr = lshr i32 %xor, 16
  %add = add i32 %shr, %xor
  ret i32 %add
}


; (A | B) ^ (~A) -> (A | ~B)
define i32 @test7(i32 %a, i32 %b) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[B_NOT:%.*]] = xor i32 %b, -1
; CHECK-NEXT:    [[XOR:%.*]] = or i32 [[B_NOT]], %a
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %or = or i32 %a, %b
  %neg = xor i32 %a, -1
  %xor = xor i32 %or, %neg
  ret i32 %xor
}

; (~A) ^ (A | B) -> (A | ~B)
define i32 @test8(i32 %a, i32 %b) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[B_NOT:%.*]] = xor i32 %b, -1
; CHECK-NEXT:    [[XOR:%.*]] = or i32 [[B_NOT]], %a
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %neg = xor i32 %a, -1
  %or = or i32 %a, %b
  %xor = xor i32 %neg, %or
  ret i32 %xor
}

; (A & B) ^ (A ^ B) -> (A | B)
define i32 @test9(i32 %b, i32 %c) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[XOR2:%.*]] = or i32 %b, %c
; CHECK-NEXT:    ret i32 [[XOR2]]
;
  %and = and i32 %b, %c
  %xor = xor i32 %b, %c
  %xor2 = xor i32 %and, %xor
  ret i32 %xor2
}

; (A ^ B) ^ (A & B) -> (A | B)
define i32 @test10(i32 %b, i32 %c) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[XOR2:%.*]] = or i32 %b, %c
; CHECK-NEXT:    ret i32 [[XOR2]]
;
  %xor = xor i32 %b, %c
  %and = and i32 %b, %c
  %xor2 = xor i32 %xor, %and
  ret i32 %xor2
}

define i32 @test11(i32 %A, i32 %B) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    ret i32 0
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  %xor2 = xor i32 %not, %B
  %and = and i32 %xor1, %xor2
  ret i32 %and
}

define i32 @test12(i32 %a, i32 %b) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, %b
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %negb = xor i32 %b, -1
  %and = and i32 %a, %negb
  %nega = xor i32 %a, -1
  %xor = xor i32 %and, %nega
  ret i32 %xor
}

define i32 @test12commuted(i32 %a, i32 %b) {
; CHECK-LABEL: @test12commuted(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, %b
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %negb = xor i32 %b, -1
  %and = and i32 %negb, %a
  %nega = xor i32 %a, -1
  %xor = xor i32 %and, %nega
  ret i32 %xor
}

; This is a test of canonicalization via operand complexity.
; The final xor has a binary operator and a (fake) unary operator,
; so binary (more complex) should come first.

define i32 @test13(i32 %a, i32 %b) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, %b
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %nega = xor i32 %a, -1
  %negb = xor i32 %b, -1
  %and = and i32 %a, %negb
  %xor = xor i32 %nega, %and
  ret i32 %xor
}

define i32 @test13commuted(i32 %a, i32 %b) {
; CHECK-LABEL: @test13commuted(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, %b
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %nega = xor i32 %a, -1
  %negb = xor i32 %b, -1
  %and = and i32 %negb, %a
  %xor = xor i32 %nega, %and
  ret i32 %xor
}

; (A ^ C) ^ (A | B) -> ((~A) & B) ^ C
define i32 @test14(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 %a, -1
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], %b
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP2]], %c
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %neg = xor i32 %a, %c
  %or = or i32 %a, %b
  %xor = xor i32 %neg, %or
  ret i32 %xor
}

