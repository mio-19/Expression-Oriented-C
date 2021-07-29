#lang racket

{define-syntax-rule (LINE x ...) (string-append x ... "\n")}
{define-syntax-rule (LIST x ...) (string-join (list x ...) ",")}
{define-syntax-rule (++ x ...) (string-append x ...)}
{define-syntax-rule (BEGIN x ...) (string-append x ...)}
{define-syntax DEFINE
  {syntax-rules ()
    [(_ (f arg ...) body) (LINE "#define "f"("(LIST arg ...)") "body)]
    [(_ id x) (LINE "#define "f" "x)]}}
{define ... "..."}
{define VA_ARGS "__VA_ARGS__"}

{define prelude
  (BEGIN
   (DEFINE ("begin" "body") (++ "({" "body" "})"))
   (DEFINE ("start" "body") (++ "{return ({" "body" "});}")))}

(display-to-file prelude "prelude.h" #:exists 'replace)