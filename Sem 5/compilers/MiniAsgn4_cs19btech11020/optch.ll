; ModuleID = 'consthoist.ll'
source_filename = "consthoist.ll"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

define i32 @cast_inst_test() {
  %const = bitcast i64 4646526064 to i64
  %1 = inttoptr i64 %const to i32*
  %v0 = load i32, i32* %1, align 16
  %const_mat = add i64 %const, 16
  %2 = inttoptr i64 %const_mat to i32*
  %v1 = load i32, i32* %2, align 16
  %const_mat1 = add i64 %const, 32
  %3 = inttoptr i64 %const_mat1 to i32*
  %v2 = load i32, i32* %3, align 16
  %r0 = add i32 %v0, %v1
  %r1 = add i32 %r0, %v2
  ret i32 %r1
}
