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

int nested_comments = 0;
int string_size = 0;
int string_size_ok(int len_to_add);


%}

digit           [0-9]
id              [a-z][a-zA-Z0-9"_"]*
type_id         [A-Z][a-zA-Z0-9"_"]*
whitespace      [ \t\r\v\f]
allowed_chars   [\<\=;\(\)\{\}\.\+\-\*/~@\:\,]

%x              comment
%x              string
%x              single_line_comment

%%

"--"            BEGIN(single_line_comment);
<single_line_comment>{
  .+
  .+\n {
    curr_lineno++;
    BEGIN(INITIAL);
  }
  \n {
    curr_lineno++;
    BEGIN(INITIAL);
  }
  <<EOF>> BEGIN(INITIAL);
}

"(*"            {
  nested_comments++;
  BEGIN(comment);
}
<comment>{
  "*)"       {
    nested_comments--;
    if (nested_comments == 0)
      BEGIN(INITIAL);
  }
  [^\n\*]*
  [^\n\*]*\n curr_lineno++;
  "*"
  "*"\n      curr_lineno++;
  <<EOF>>    {
    yylval.error_msg = "EOF in comment";
    BEGIN(INITIAL);
    return (ERROR);
  }
}

"*)" {
  cool_yylval.error_msg = "Unmatched *)";
  return (ERROR);
}

true  {
  cool_yylval.boolean = true;
  return (BOOL_CONST); }
false {
  cool_yylval.boolean = false;
  return (BOOL_CONST); }

(?i:class)      return (CLASS);
(?i:else)       return (ELSE);
(?i:fi)         return (FI);
(?i:if)         return (IF);
(?i:in)         return (IN);
(?i:inherits)   return (INHERITS);
(?i:let)        return (LET);
(?i:loop)       return (LOOP);
(?i:pool)       return (POOL);
(?i:then)       return (THEN);
(?i:while)      return (WHILE);
(?i:case)       return (CASE);
(?i:esac)       return (ESAC);
(?i:of)         return (OF);
"=>"            return (DARROW);
(?i:new)        return (NEW);
(?i:isvoid)     return (ISVOID);
(?i:not)         return (NOT);

{digit}+ {
  cool_yylval.symbol = inttable.add_string(yytext);
  return (INT_CONST); }

{id}  {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (OBJECTID); }

{type_id}  {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (TYPEID); }

\" {
  string_buf_ptr = string_buf;
  string_size = 0;
  BEGIN(string);
}

<string>{
  \" {
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    cool_yylval.symbol = stringtable.add_string(string_buf);
    return (STR_CONST);
  }

  <<EOF>> {
    cool_yylval.error_msg = "EOF in string constant";
    yyterminate();
    return(ERROR);
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
    if (string_size_ok(yyleng - 1) == ERROR) return (ERROR);
    while (*yptr) {
      *string_buf_ptr++ = *yptr++;
    }
  }

  \\[0-9]+ {
    cool_yylval.error_msg = "bad escape sequence";
    return (ERROR);
  }

  \n {
    curr_lineno++;
    BEGIN(INITIAL);
    cool_yylval.error_msg = "Unterminated string constant";
    return(ERROR);
  }

  \0 {
    BEGIN(INITIAL);
    cool_yylval.error_msg = "String contains null character";
    return (ERROR);
  }

  \\n {
    if (string_size_ok(1) == ERROR) return (ERROR);
    *string_buf_ptr++ = '\n';
  }
  \\t {
    if (string_size_ok(1) == ERROR) return (ERROR);
    *string_buf_ptr++ = '\t';
  }
  \\b {
    if (string_size_ok(1) == ERROR) return (ERROR);
    *string_buf_ptr++ = '\b';
  }
  \\f {
    if (string_size_ok(1) == ERROR) return (ERROR);
    *string_buf_ptr++ = '\f';
  }
  \\(.|\n) {
    if (string_size_ok(1) == ERROR) return (ERROR);
    *string_buf_ptr++ = yytext[1];
  }

  [^\n\\\"]+ {
    if (string_size_ok(yyleng) == ERROR) return (ERROR);
    char* yptr = yytext;
    while (*yptr)
      *string_buf_ptr++ = *yptr++;
  }
}

"<-"              return (ASSIGN);
"<="              return (LE);
(\n)              curr_lineno++;
{whitespace}
{allowed_chars}   return *yytext;
(.) {
  cool_yylval.error_msg = yytext;
  return (ERROR);
}

%%


int string_size_ok(int len_to_add)
{
  if ((string_size += len_to_add) >= MAX_STR_CONST) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN (INITIAL);
    return (ERROR);
  }
  return 1;
}
