; ModuleID = '3.ll'
source_filename = "3.ll"

define void @testfunc(i32 %i) {
  %i2 = mul i32 %i, 17
  br label %Loop

Loop:                                             ; preds = %Loop, %0
  %j = phi i32 [ 0, %0 ], [ %Next, %Loop ]
  %Next = add i32 %j, %i2
  %cond = icmp eq i32 %Next, 0
  br i1 %cond, label %Out, label %Loop

Out:                                              ; preds = %Loop
  ret void
}
