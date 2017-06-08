
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     CREATE = 258,
     TABLE = 259,
     DROP = 260,
     SELECT = 261,
     DISTINCT = 262,
     FROM = 263,
     WHERE = 264,
     ORDERBY = 265,
     DELETE = 266,
     INSERTINTO = 267,
     VALUES = 268,
     OR = 269,
     AND = 270,
     NOT = 271,
     OPAREN = 272,
     EPAREN = 273,
     COLON = 274,
     STAR_MULTIPLICATION = 275,
     PLUS = 276,
     MINUS = 277,
     DIVISION = 278,
     DOT = 279,
     TOKNULL = 280,
     NEWLINE = 281,
     INTEGER = 282,
     NAME = 283,
     LITERAL = 284,
     COMPOP = 285,
     INTTOK = 286,
     STR20TOK = 287
   };
#endif
/* Tokens.  */
#define CREATE 258
#define TABLE 259
#define DROP 260
#define SELECT 261
#define DISTINCT 262
#define FROM 263
#define WHERE 264
#define ORDERBY 265
#define DELETE 266
#define INSERTINTO 267
#define VALUES 268
#define OR 269
#define AND 270
#define NOT 271
#define OPAREN 272
#define EPAREN 273
#define COLON 274
#define STAR_MULTIPLICATION 275
#define PLUS 276
#define MINUS 277
#define DIVISION 278
#define DOT 279
#define TOKNULL 280
#define NEWLINE 281
#define INTEGER 282
#define NAME 283
#define LITERAL 284
#define COMPOP 285
#define INTTOK 286
#define STR20TOK 287




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 56 "tiny_sql.y"

	int number;
	char *str;



/* Line 1676 of yacc.c  */
#line 123 "tiny_sql.hh"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


