%{
#include <cstdio>
#include <cstring>
#include <vector>
#include <string>
#include <iostream>
#include "Block.h"
#include "Config.h"
#include "Disk.h"
#include "Field.h"
#include "MainMemory.h"
#include "Relation.h"
#include "Schema.h"
#include "SchemaManager.h"
#include "Tuple.h"

extern "C"
{
        int yyparse(void);
        int yylex(void);
        int yywrap()
        {
                return 1;
        }
        void yyerror(const char *str)
        {
                fprintf(stderr,"error: %s\n",str);
        }
        
}

extern int yydebug;

MainMemory mem;
Disk disk;
SchemaManager schema_manager(&mem,&disk);
vector<enum FIELD_TYPE> field_types;
vector<string> field_names;

main()
{
        //yydebug=1;
        yyparse();

}

%}

%token CREATE TABLE DROP SELECT DISTINCT FROM WHERE ORDERBY
       DELETE INSERTINTO VALUES OR AND NOT
       OPAREN EPAREN COLON STAR_MULTIPLICATION PLUS MINUS DIVISION
       DOT TOKNULL
       NEWLINE

%union 
{
	int number;
	char *str;
}

%token <number> INTEGER
%token <str> NAME
%token <str> LITERAL
%token <char> COMPOP

%type <number> data_type
%token <number> INTTOK
%token <number> STR20TOK

%%

statements:
	statement NEWLINE
	| statements statement NEWLINE
;

statement: 
         create_table_statement
	| drop_table_statement
        | select_statement
        | insert_statement
        | delete_statement
;

create_table_statement:
          CREATE TABLE NAME OPAREN attribute_type_list EPAREN
{
  Schema schema(field_names,field_types);
  string relation_name=$3;
  Relation* relation_ptr=schema_manager.createRelation(relation_name,schema);

  // Print the information about the Relation
  cout << "The table has name " << relation_ptr->getRelationName() << endl;
  cout << "The table has schema:" << endl;
  cout << relation_ptr->getSchema() << endl;
  cout << "The table currently have " << relation_ptr->getNumOfBlocks() << " blocks" << endl;
  cout << "The table currently have " << relation_ptr->getNumOfTuples() << " tuples" << endl;

  field_names.clear();
  field_types.clear();
}
;

attribute_type_list:
          NAME data_type
{
  field_names.push_back($1);
  if ($2==INT) // Here INT is not a lex token. It is a field type defined in Field.h
    field_types.push_back(INT);
  else if ($2==STR20)
    field_types.push_back(STR20);
}
        | NAME data_type COLON attribute_type_list
{
  field_names.push_back($1);
  if ($2==INT) // Here INT is not a lex token. It is a field type defined in Field.h
    field_types.push_back(INT);
  else if ($2==STR20)
    field_types.push_back(STR20);
}
;

data_type: INTTOK { $$=$1; } | STR20TOK { $$=$1; }
;

drop_table_statement: DROP TABLE NAME
;

select_statement:
          SELECT select_list FROM table_list
        | SELECT DISTINCT select_list FROM table_list
        | SELECT select_list FROM table_list WHERE search_condition
        | SELECT DISTINCT select_list FROM table_list WHERE search_condition
        | SELECT select_list FROM table_list ORDERBY column_name
        | SELECT DISTINCT select_list FROM table_list ORDERBY column_name
        | SELECT select_list FROM table_list WHERE search_condition ORDERBY column_name
        | SELECT DISTINCT select_list FROM table_list WHERE search_condition ORDERBY column_name
;

select_list: STAR_MULTIPLICATION | select_sublist
;

select_sublist: column_name | column_name COLON select_sublist
;

table_list: NAME | NAME COLON table_list
;

insert_statement:
          INSERTINTO NAME OPAREN attribute_list EPAREN insert_tuples
;

attribute_list:
          NAME
        | NAME COLON attribute_list
;

insert_tuples:
          VALUES OPAREN value_list EPAREN
        | select_statement
;

value_list:
          value
	| value COLON value_list
;

value: LITERAL | INTEGER | TOKNULL
;

delete_statement:
          DELETE FROM NAME
        | DELETE FROM NAME WHERE search_condition
;

search_condition: boolean_term | boolean_term OR search_condition
;

boolean_term: boolean_factor | boolean_factor AND boolean_term
;

boolean_factor: boolean_primary | NOT boolean_primary
;

boolean_primary: comparison_predicate | OPAREN search_condition EPAREN
;

comparison_predicate: expression COMPOP expression
;

expression: term
	  | term PLUS expression
	  | term MINUS expression
;

term: factor
    | factor STAR_MULTIPLICATION term
    | factor DIVISION term
;

factor: column_name
      | LITERAL
      | INTEGER
      | OPAREN expression EPAREN
;

column_name: NAME | NAME DOT NAME
;


