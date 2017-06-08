all: tiny_sql

tiny_sql: StorageManager.o lex.yy.o
	g++ StorageManager.o lex.yy.o tiny_sql.cc -o tiny_sql

StorageManager.o: Block.h Disk.h Field.h MainMemory.h Relation.h Schema.h SchemaManager.h Tuple.h Config.h
	g++ -c StorageManager.cpp

lex.yy.o: lex.yy.h tiny_sql.hh
  cc -c lex.yy.c -o lex.yy.o

tiny_sql.cc: 
  bison --verbose --debug -d tiny_sql.y -o tiny_sql.cc
  
lex.yy.c:
  flex tiny_sql.l

clean:
	rm lex.yy.c lex.yy.h tiny_sql.cc tiny_sql.hh *.o tiny_sql
