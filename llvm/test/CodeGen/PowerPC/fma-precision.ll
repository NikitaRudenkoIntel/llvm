; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mcpu=pwr9 -mtriple=powerpc64le-linux-gnu | FileCheck %s

; Verify that the fold of a*b-c*d respect the uses of a*b
define double @fsub1(double %a, double %b, double %c, double %d)  {
; CHECK-LABEL: fsub1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmuldp 3, 4, 3
; CHECK-NEXT:    xsmuldp 0, 2, 1
; CHECK-NEXT:    xsmsubadp 3, 2, 1
; CHECK-NEXT:    xsmuldp 1, 0, 3
; CHECK-NEXT:    blr
entry:
  %mul = fmul fast double %b, %a
  %mul1 = fmul fast double %d, %c
  %sub = fsub fast double %mul, %mul1
  %mul3 = fmul fast double %mul, %sub
  ret double %mul3
}

; Verify that the fold of a*b-c*d respect the uses of c*d
define double @fsub2(double %a, double %b, double %c, double %d)  {
; CHECK-LABEL: fsub2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmuldp 0, 4, 3
; CHECK-NEXT:    fmr 3, 0
; CHECK-NEXT:    xsmsubadp 3, 2, 1
; CHECK-NEXT:    xsmuldp 1, 0, 3
; CHECK-NEXT:    blr
entry:
  %mul = fmul fast double %b, %a
  %mul1 = fmul fast double %d, %c
  %sub = fsub fast double %mul, %mul1
  %mul3 = fmul fast double %mul1, %sub
  ret double %mul3
}

; Verify that the fold of a*b-c*d if there is no uses of a*b and c*d
define double @fsub3(double %a, double %b, double %c, double %d)  {
; CHECK-LABEL: fsub3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmuldp 0, 4, 3
; CHECK-NEXT:    xsmsubadp 0, 2, 1
; CHECK-NEXT:    fmr 1, 0
; CHECK-NEXT:    blr
entry:
  %mul = fmul fast double %b, %a
  %mul1 = fmul fast double %d, %c
  %sub = fsub fast double %mul, %mul1
  ret double %sub
}

; Verify that the fold of a*b+c*d respect the uses of a*b
define double @fadd1(double %a, double %b, double %c, double %d)  {
; CHECK-LABEL: fadd1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmuldp 0, 2, 1
; CHECK-NEXT:    fmr 1, 0
; CHECK-NEXT:    xsmaddadp 1, 4, 3
; CHECK-NEXT:    xsmuldp 1, 0, 1
; CHECK-NEXT:    blr
entry:
  %mul = fmul fast double %b, %a
  %mul1 = fmul fast double %d, %c
  %add = fadd fast double %mul1, %mul
  %mul3 = fmul fast double %mul, %add
  ret double %mul3
}

; Verify that the fold of a*b+c*d respect the uses of c*d
define double @fadd2(double %a, double %b, double %c, double %d)  {
; CHECK-LABEL: fadd2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmuldp 0, 4, 3
; CHECK-NEXT:    fmr 3, 0
; CHECK-NEXT:    xsmaddadp 3, 2, 1
; CHECK-NEXT:    xsmuldp 1, 0, 3
; CHECK-NEXT:    blr
entry:
  %mul = fmul fast double %b, %a
  %mul1 = fmul fast double %d, %c
  %add = fadd fast double %mul1, %mul
  %mul3 = fmul fast double %mul1, %add
  ret double %mul3
}

; Verify that the fold of a*b+c*d if there is no uses of a*b and c*d
define double @fadd3(double %a, double %b, double %c, double %d)  {
; CHECK-LABEL: fadd3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmuldp 1, 2, 1
; CHECK-NEXT:    xsmaddadp 1, 4, 3
; CHECK-NEXT:    blr
entry:
  %mul = fmul fast double %b, %a
  %mul1 = fmul fast double %d, %c
  %add = fadd fast double %mul1, %mul
  ret double %add
}
