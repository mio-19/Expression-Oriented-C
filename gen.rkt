#lang racket

{define-syntax-rule (LINE x ...) (string-append x ... "\n")}
{define (LIST . xs) (string-join xs ",")}
{define ++ string-append}
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

{define $ "___EOC___internal___WAHAHA___"}

{define temp1 "___EOC___temp___VARIABLE___1___"}
{define local-inline "static inline"}

{define Void "void"}

{define N 64}

{define ~ number->string}

; https://stackoverflow.com/questions/2124339/c-preprocessor-va-args-number-of-arguments
{define PP_NARG
  (++
   "#define "$"PP_NARG(...) "$"PP_NARG_(__VA_ARGS__,"$"PP_RSEQ_N())
#define "$"PP_NARG_(...) "$"PP_ARG_N(__VA_ARGS__)
#define "$"PP_ARG_N( \
          _1, _2, _3, _4, _5, _6, _7, _8, _9,_10, \
         _11,_12,_13,_14,_15,_16,_17,_18,_19,_20, \
         _21,_22,_23,_24,_25,_26,_27,_28,_29,_30, \
         _31,_32,_33,_34,_35,_36,_37,_38,_39,_40, \
         _41,_42,_43,_44,_45,_46,_47,_48,_49,_50, \
         _51,_52,_53,_54,_55,_56,_57,_58,_59,_60, \
         _61,_62,_63,N,...) N
#define "$"PP_RSEQ_N() \
         63,62,61,60,                   \
         59,58,57,56,55,54,53,52,51,50, \
         49,48,47,46,45,44,43,42,41,40, \
         39,38,37,36,35,34,33,32,31,30, \
         29,28,27,26,25,24,23,22,21,20, \
         19,18,17,16,15,14,13,12,11,10, \
         9,8,7,6,5,4,3,2,1,0\n")}

{define prelude-cpp
  (BEGIN
   (DEFINE "let" "auto")
   (DEFINE ("lambda" "type" "args") (++ "[&](args)->type "$"lambda_helper"))
   (DEFINE ((++ $"lambda_helper") "body") (++ "{return ({body;});}")))}
{define prelude-gcc
  (BEGIN
   (DEFINE "let" "__auto_type")
   (DEFINE ("lambda" "type" "args") (++ "({type "temp1" args "$"lambda_helper"))
   (DEFINE ((++ $"lambda_helper") "body") (++ "{return ({body;});}"temp1";})")))}

{define prelude
  (BEGIN
   PP_NARG
   (apply ++ (map (λ (n) (DEFINE ((++ $"map_"(~ n)) "f" (apply LIST (map (λ (x) (++ "n"(~ x))) (range n)))) (apply ++ (map (λ (x) (++ "f(n"(~ x)")")) (range n))))) (range 1 N)))
   (DEFINE ((++ $"concat0") "x" "y") "x##y")
   (DEFINE ((++ $"concat") "x" "y") (++ $"concat0(x,y)"))
   (DEFINE ((++ $"map") "f" ...) (++ $"concat("$"map_,"$"PP_NARG("VA_ARGS"))(f,"VA_ARGS")"))
   (DEFINE ("begin" "body") "({body;})")
   (DEFINE ("start" "body") "{return ({body;});}")
   (DEFINE ("the" "type" "value") (++ "({(type) "temp1"=(value);"temp1"})"))
   (DEFINE ("as" "type" "value") "(type)(value)")
   (DEFINE-FUNC local-inline ("mkvoid") -> Void "")
   
   (DEFINE ("when" "b") (++ "((b)?"$"when_helper"))
   (DEFINE ((++ $"when_helper") "body") (++ "({body;}):"$"when_helper_2"))
   (DEFINE ((++ $"when_helper_2") "body") "({body;}))")

   ;;(DEFINE ("case" "type" "x") (++ "({(type) "temp1";switch(x){"$"case_helper"))
   ;;(DEFINE ((++ $"case_helper") ...) (++ $"map("$"case_helper_each,"VA_ARGS")"))

   (LINE "#ifdef __cplusplus")
   prelude-cpp
   (LINE "#else")
   prelude-gcc
   (LINE "#endif")
   
   )}

(display-to-file prelude "prelude.h" #:exists 'replace)