; ModuleID = 'matmul.ll'
source_filename = "file.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32* @foo(i32* %0, i32* %1) #0 {
  br label %.split

.split:                                           ; preds = %2
  %3 = load i32, i32* %0, align 4
  %4 = load i32, i32* %1, align 4
  %5 = icmp sgt i32 %3, %4
  %. = select i1 %5, i32* %0, i32* %1
  ret i32* %.
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @bar(i32* %0, i32* %1) #0 {
  br label %.split

.split:                                           ; preds = %2
  %3 = load i32, i32* %1, align 4
  store i32 %3, i32* %0, align 4
  store i32 %3, i32* %1, align 4
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = tail call noalias dereferenceable_or_null(4) i8* @malloc(i64 4) #2
  %2 = bitcast i8* %1 to i32*
  %3 = tail call noalias dereferenceable_or_null(4) i8* @malloc(i64 4) #2
  %4 = bitcast i8* %3 to i32*
  %5 = tail call noalias dereferenceable_or_null(4) i8* @malloc(i64 4) #2
  %6 = bitcast i8* %5 to i32*
  %7 = tail call noalias dereferenceable_or_null(4) i8* @malloc(i64 4) #2
  %8 = bitcast i8* %7 to i32*
  store i32 0, i32* %2, align 4
  store i32 1, i32* %4, align 4
  store i32 2, i32* %6, align 4
  store i32 3, i32* %8, align 4
  %9 = tail call i32* @foo(i32* nonnull %2, i32* nonnull %4)
  tail call void @bar(i32* nonnull %6, i32* nonnull %8)
  %10 = load i32, i32* %2, align 4
  %11 = load i32, i32* %4, align 4
  %12 = add nsw i32 %11, %10
  %13 = load i32, i32* %6, align 4
  %14 = add nsw i32 %12, %13
  %15 = load i32, i32* %8, align 4
  %16 = add nsw i32 %14, %15
  %17 = load i32, i32* %9, align 4
  %18 = add nsw i32 %16, %17
  ret i32 %18
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

attributes #0 = { noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
