; ModuleID = 'loop.ll'
source_filename = "loop.ll"

define void @test() {
entry:
  br i1 true, label %bb1, label %bb2

bb1:                                              ; preds = %entry
  br label %bb3.preheader

bb2:                                              ; preds = %entry
  br label %bb3.preheader

bb3.preheader:                                    ; preds = %bb1, %bb2
  br label %bb3

bb3:                                              ; preds = %bb3.preheader, %bb3
  br label %bb3
}

define void @test_multiple_exits_from_single_block(i8 %a, i8* %b.ptr) {
entry:
  switch i8 %a, label %loop.preheader [
    i8 0, label %exit.a
    i8 1, label %exit.b
  ]

loop.preheader:                                   ; preds = %entry
  br label %loop

loop:                                             ; preds = %loop.backedge, %loop.preheader
  %b = load volatile i8, i8* %b.ptr
  switch i8 %b, label %loop.backedge [
    i8 0, label %exit.a.loopexit
    i8 1, label %exit.b.loopexit
    i8 2, label %loop.backedge
    i8 3, label %exit.a.loopexit
    i8 4, label %loop.backedge
    i8 5, label %exit.a.loopexit
    i8 6, label %loop.backedge
  ]

loop.backedge:                                    ; preds = %loop, %loop, %loop, %loop
  br label %loop

exit.a.loopexit:                                  ; preds = %loop, %loop, %loop
  br label %exit.a

exit.a:                                           ; preds = %exit.a.loopexit, %entry
  ret void

exit.b.loopexit:                                  ; preds = %loop
  br label %exit.b

exit.b:                                           ; preds = %exit.b.loopexit, %entry
  ret void
}

define void @test_pre_existing_dedicated_exits(i1 %a, i1* %ptr) {
entry:
  br i1 %a, label %loop.ph, label %non_dedicated_exit

loop.ph:                                          ; preds = %entry
  br label %loop.header

loop.header:                                      ; preds = %loop.backedge, %loop.ph
  %c1 = load volatile i1, i1* %ptr
  br i1 %c1, label %loop.body1, label %dedicated_exit1

loop.body1:                                       ; preds = %loop.header
  %c2 = load volatile i1, i1* %ptr
  br i1 %c2, label %loop.body2, label %non_dedicated_exit.loopexit

loop.body2:                                       ; preds = %loop.body1
  %c3 = load volatile i1, i1* %ptr
  br i1 %c3, label %loop.backedge, label %dedicated_exit2

loop.backedge:                                    ; preds = %loop.body2
  br label %loop.header

dedicated_exit1:                                  ; preds = %loop.header
  ret void

dedicated_exit2:                                  ; preds = %loop.body2
  ret void

non_dedicated_exit.loopexit:                      ; preds = %loop.body1
  br label %non_dedicated_exit

non_dedicated_exit:                               ; preds = %non_dedicated_exit.loopexit, %entry
  ret void
}

define void @test_form_some_dedicated_exits_despite_indirectbr(i8 %a, i8* %ptr, i8** %addr.ptr) {
entry:
  switch i8 %a, label %loop.ph [
    i8 0, label %exit.a
    i8 1, label %exit.b
    i8 2, label %exit.c
  ]

loop.ph:                                          ; preds = %entry
  br label %loop.header

loop.header:                                      ; preds = %loop.backedge, %loop.ph
  %addr1 = load volatile i8*, i8** %addr.ptr
  indirectbr i8* %addr1, [label %loop.body1, label %exit.a]

loop.body1:                                       ; preds = %loop.header
  %b = load volatile i8, i8* %ptr
  switch i8 %b, label %loop.body2 [
    i8 0, label %exit.a
    i8 1, label %exit.b.loopexit
    i8 2, label %exit.c
  ]

loop.body2:                                       ; preds = %loop.body1
  %addr2 = load volatile i8*, i8** %addr.ptr
  indirectbr i8* %addr2, [label %loop.backedge, label %exit.c]

loop.backedge:                                    ; preds = %loop.body2
  br label %loop.header

exit.a:                                           ; preds = %loop.body1, %loop.header, %entry
  ret void

exit.b.loopexit:                                  ; preds = %loop.body1
  br label %exit.b

exit.b:                                           ; preds = %exit.b.loopexit, %entry
  ret void

exit.c:                                           ; preds = %loop.body2, %loop.body1, %entry
  ret void
}
