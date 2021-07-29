#lang racket

{define-syntax-rule (LINE x ...) (string-append x ... "\n")}
{define-syntax-rule (LIST x ...) (string-join (list x ...) ",")}
{define-syntax-rule (++ x ...) (string-append x ...)}
{define-syntax-rule (BEGIN x ...) (string-append x ...)}
{define-syntax DEFINE
  {syntax-rules ()
    [(_ (f arg ...) body) (LINE "#define "f"("(LIST arg ...)") "body)]
    [(_ id x) (LINE "#define "id" "x)]}}
{define ... "..."}
{define VA_ARGS "__VA_ARGS__"}

{define-syntax DEFINE-FUNC
  {syntax-rules (: ->)
    [(_ (f) -> result body) (LINE result" "f"(void){"body"}")]
    [(_ prefix (f) -> result body) (LINE prefix" "result" "f"(void){"body"}")]
    [(_ prefix (f (arg : type) ...) -> result body) (LINE prefix" "result" "f"("(LIST (++ type" "arg) ...)"){"body"}")]
    [(_ (f (arg : type) ...) -> result body) (LINE result" "f"("(LIST (++ type" "arg) ...)"){"body"}")]}}

{define internal-prefix "___EOC___internal___WAHAHA___"}

{define temp1 "___EOC___temp___VARIABLE___1___"}
{define local-inline "static inline"}

{define Void "void"}

{define prelude
  (BEGIN
   (DEFINE "let" "auto")
   (DEFINE ("begin" "body") "({body})")
   (DEFINE ("start" "body") "{return ({body});}")
   (DEFINE ("the" "type" "value") (++ "({(type) "temp1"=(value);"temp1"})"))
   (DEFINE ("as" "type" "value") "(type)(value)")
   (DEFINE-FUNC local-inline ("mkvoid") -> Void "")
   
   (DEFINE ("when" "b") (++ "((b)?"internal-prefix"when_helper"))
   (DEFINE ((++ internal-prefix"when_helper") "body") (++ "({body}):"internal-prefix"when_helper_2"))
   (DEFINE ((++ internal-prefix"when_helper_2") "body") "({body}))")
   )}

(display-to-file prelude "prelude.h" #:exists 'replace)