%{
#include <stdio.h>
#include <string.h>
#include "tiny_sql.hh"
extern YYSTYPE yylval;
%}
%%
CREATE printf("CREATE\n"); return CREATE;
TABLE printf("TABLE\n"); return TABLE;
INT printf("INT\n"); yylval.number=0; return INTTOK;
STR20 printf("STR20\n"); yylval.number=1; return STR20TOK;
DROP printf("DROP\n"); return DROP;
SELECT printf("SELECT\n"); return SELECT;
DISTINCT printf("DISTINCT\n"); return DISTINCT;
FROM printf("FROM\n"); return FROM;
WHERE printf("WHERE\n"); return WHERE;
ORDER printf("ORDERBY\n"); return ORDERBY;
BY /* ignore BY of ORDER BY */;
DELETE printf("DELETE\n"); return DELETE;
INSERT printf("INSERTINTO\n"); return INSERTINTO;
INTO /* ignore INTO of INSERT INTO */;
VALUES printf("VALUES\n"); return VALUES;
OR printf("OR\n"); return OR;
AND printf("AND\n"); return AND;
NOT printf("NOT\n"); return NOT;
\( printf("OPAREN\n"); return OPAREN;
\) printf("EPAREN\n"); return EPAREN;
,  printf("COLON\n"); return COLON;
\* printf("STAR_MULTIPLICATION\n"); return STAR_MULTIPLICATION;
\+ printf("PLUS\n"); return PLUS;
- printf("MINUS\n"); return MINUS;
\/ printf("DIVISION\n"); return DIVISION;
\<|>|= printf("COMPOP\n"); return COMPOP;
\. printf("DOT"); return DOT;
NULL printf("NULL\n"); return TOKNULL;
\"[a-zA-Z0-9 ]*\"         yylval.str=strndup(yytext+1,strlen(yytext)-2); printf("LITERAL:%s\n",yylval.str); return LITERAL;
[a-zA-Z][a-zA-Z0-9]*    yylval.str=strdup(yytext); printf("NAME\n"); return NAME;
[0-9]+                  yylval.number=atoi(yytext); printf("INTEGER\n"); return INTEGER;
\n                      printf("NEWLINE\n"); return NEWLINE;
[ \t]+                  /* ignore whitespace */;
%%
