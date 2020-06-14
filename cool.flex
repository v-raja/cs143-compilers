/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

digit           [0-9]
letter          [a-zA-Z]
id              [a-z][{digit}{letter}_]+
type_id         [A-Z][{digit}{letter}_]+
whitespace      [ \t\n\r\v]+
/*
 * Define names for regular expressions here.
 */

%x              comment
/* CLASS           ("class " TYPEID " inherits " TYPEID " {"
                [FEATURE";"]* "}") */

DARROW          =>
NEW             (?i:new)
ISVOID          (?i:isvoid)
INT_CONST       {digit}{digit}*
BOOL_TRUE       true
BOOL_FALSE      false
TYPEID          {id}
OBJECTID        {id}
assign          <-
NOT             "not"
LE              "le"
LET_STMT        "let"
%x              string

/* {STR_CONST}     { cool_yylval.symbol = stringtable.add_string(yytext);
                  return (STR_CONST); } */


%%

 /*
  *  Nested comments
  */


 /*
  *  The multiple-character operators.
  */

"(*"         BEGIN(comment);
<comment>{
  [^\n\*]*
  [^\n\*]*\n curr_lineno++;
  <<EOF>>    {
    yylval.error_msg = "EOF in comment";
    BEGIN(INITIAL);
    return (ERROR);
  }
  "*)"       BEGIN(INITIAL);
}

{id}  {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (OBJECTID); }

{type_id}  {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (TYPEID); }

(?i:else)
  return (ELSE);
(?i:fi)
  return (FI);
(?i:if)
  return (IF);
(?i:in)
  return (IN);
(?i:inherits)
  return (INHERITS);
(?i:let)
  return (LET);
(?i:loop)
  return (LOOP);
(?i:pool)
  return (POOL);
(?i:then)
  return (THEN);
(?i:while)
  return (WHILE);
(?i:case)
  return (CASE);
(?i:esac)
  return (ESAC);
(?i:of)
  return (OF);
=>
  return (DARROW);
(?i:new)
  return (NEW);
(?i:isvoid)
  return (ISVOID);
{digit}+ {
  cool_yylval.symbol = inttable.add_string(yytext);
  return (INT_CONST); }

\" {
  string_buf_ptr = string_buf;
  BEGIN(string);
}

<string>{
  \" {
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    cool_yylval.symbol = stringtable.add_string(string_buf);
    return (STR_CONST);
  }

  \\[0-7]{1,3} {
    /* octal escape sequence */
    int oct;
    sscanf(yytext + 1, "%o", &oct);
    if (oct > 0xff) {
      cool_yylval.error_msg = "octal number too big";
      return (ERROR);
    }
    char* yptr = yytext + 1;
    while (*yptr)
      *string_buf_ptr++ = *yptr++;
  }

  \\[0-9]+ {
    cool_yylval.error_msg = "bad escape sequence";
    return (ERROR);
  }

  \n {
    BEGIN(INITIAL);
    cool_yylval.error_msg = "Unterminated string constant";
    return(ERROR);
  }

  \\n      *string_buf_ptr++ = '\n';
  \\t      *string_buf_ptr++ = '\t';
  \\b      *string_buf_ptr++ = '\b';
  \\f      *string_buf_ptr++ = '\f';
  \\(.|\n) *string_buf_ptr++ = yytext[1];

  [^\n\\\"]+ {
    char* yptr = yytext;
    while (*yptr)
      *string_buf_ptr++ = *yptr++;
  }

  <<EOF>> {
    cool_yylval.error_msg = "encountered EOF in string";
    yyterminate();
    return(ERROR);
  }
}

true  {
  cool_yylval.boolean = true;
  return (BOOL_CONST); }
false {
  cool_yylval.boolean = false;
  return (BOOL_CONST); }


<-
  return (ASSIGN);
(.|\n)
  curr_lineno++;

%%


