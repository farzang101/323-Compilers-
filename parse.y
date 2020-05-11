//parse.y
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include <ctype.h>

    extern int yylex();
    FILE * output;
    bool exist(char* filename);
    bool id_exists(char* identify);
    void yyerror(char* msg);

    //Something to hold the identifiers
    char dec_ids[20][20];
    int i = 0, num_ids = 0;
%}

%union{
    char* s;
    int i;
}

//* and / have HIGHER PRECEDENCE than - and +
// %left SUBT ADD
// %left MULT DIV


%token <s> NUM
%token <s> PROGRAM VAR START END INTEGER PRINT 
%token SEMICOLON LPAREN RPAREN ADD SUBT MULT DIV EQ PERIOD COLON COMMA QUOTE
%token <s> STRING IDENTIFIER
%type <s> id holdid dec pname type string assign expr term factor number digit

%nonassoc "least"
%nonassoc ADD
%nonassoc SUBT
%nonassoc MULT
%nonassoc DIV


%%
start       :   PROGRAM { printf("PROGRAM"); } pname semicolon var declist semicolon begin statlist end period
            |   { yyerror("PROGRAM is expected\n"); exit(1); }
            ;
pname       :   IDENTIFIER   { $$ = $1; printf("Program name %s ", $1); }
            |   { yyerror("Program name is missing\n"); exit(1); }
            ;
var         :   VAR     { printf("VAR"); }
            |   { yyerror("VAR is expected\n"); exit(1); }
            ;
colon       :   COLON { printf("COLON\n"); }
            |   { yyerror("COLON : is missing\n"); exit(1); }
            ;
semicolon   :   SEMICOLON { printf("SEMICOLON"); }
            |   { yyerror("SEMICOLON ; is missing\n"); exit(1); }
            ;
begin       :   START   { printf("BEGIN"); }
            |   { yyerror("BEGIN is expected\n"); exit(1); }
            ;
end         :   END { printf("END\n"); }
            |   { yyerror("END is expected\n"); exit(1); }
            ;
prnt        :   PRINT { printf("PRINT\n"); }
            ;
string      :   STRING { $$ = $1; printf("STRING\n"); }
            ;
lparen      :   LPAREN { printf("LPAREN\n"); }
            |   { yyerror("LPAREN ( is missing\n"); exit(1); }
            ;
rparen      :   RPAREN { printf("RPAREN\n"); }
            |   { yyerror("RPAREN ) is missing\n"); exit(1); }
            ;

eq          :   EQ { fprintf(output, " = "); printf("EQ\n"); }
            |   { yyerror("EQ = is missing\n"); exit(1); }
            ;
add         :   ADD { printf("ADD\n"); }
            ;
subt        :   SUBT { printf("SUBT\n"); }
            ;
mult        :   mult { printf("MULT\n"); }
            ;
div         :   DIV { printf("DIV\n"); }
            ;
period      :   PERIOD  { printf("PERIOD\n"); }
            |   { yyerror("PERIOD . is missing\n"); exit(1); }
            ;
id          :   IDENTIFIER  { fprintf(output, "%s", $1); printf("IDENTIFIER -- %s\n", $1); }
            ;
holdid      :   IDENTIFIER  { strcpy(dec_ids[num_ids++], $1); }
            ;
declist     :   dec colon type { fprintf(output, "int "); while(i < num_ids - 1) { fprintf(output, "%s, ", dec_ids[i++]); } fprintf(output, "%s;\n", dec_ids[i]); }
            ;
dec         :   holdid COMMA dec
            |   holdid dec { yyerror("COMMA , is missing\n"); exit(1); }
            |   holdid
            ;
statlist    :   stat semicolon  { fprintf(output, ";\n"); }
            |   stat semicolon { fprintf(output, ";\n"); } statlist
            ;
stat        :   print
            |   assign
            ;
print       :   prnt { fprintf(output, "cout << "); } lparen output rparen  
            ; 
output      :   string { fprintf(output, "%s << ", $1); } COMMA { printf("COMMA\n"); } id
            |   IDENTIFIER { if(id_exists($1)) { fprintf(output, "%s", $1); } }
            ;
assign      :   IDENTIFIER { if(!id_exists($1)) { printf("UKNOWN IDENTIFIER\n"); exit(1); } fprintf(output, "%s", $1);  printf("IDENTIFIER -- %s\n", $1); } 
                eq expr     
            ;
expr        :   term
            |   expr ADD { fprintf(output, " + "); printf("ADD"); } term
            |   expr SUBT { fprintf(output, " - "); printf("SUBT"); } term
            ;
term        :   factor  
            |   term MULT { fprintf(output, " * "); printf("MULT"); } factor  
            |   term DIV { fprintf(output, " / "); printf("DIV"); } factor    
            ;
factor      :   IDENTIFIER      { if(!id_exists($1)) { printf("UKNOWN IDENTIFIER\n"); exit(1); } fprintf(output, "%s", $1); printf("IDENTIFIER -- %s\n", $1); }
            |   number  
            |   lparen { fprintf(output, "("); } expr rparen { fprintf(output, ")"); }
            ;
number      :   digit  
            ;
type        :   INTEGER
            ;
digit       :   NUM     { fprintf(output, "%d", atoi($1)); printf("NUM\n"); }
            ;
%%

bool exist(char* filename) {
    FILE* checkfile = fopen(filename, "r");      //Pass in "r" since read does not create a file
    if(!checkfile) {
        return false;
    }
    else {
        return true;
    }
}

bool id_exists(char* identify) {
    for(int index = 0; index < num_ids; ++index) {
        if(strcmp(dec_ids[index], identify) == 0) {
            return true;
        }
    }
    return false;
}

void yyerror(char* msg) {
    fprintf(stderr, "Error! %s", msg);
} 

int main() {
    //Delete "abc13.cpp" if already exists
    if(exist("abc13.cpp")) {
        remove("abc13.cpp");
    }
    //Create the file "abc13.cpp"
    output = fopen("abc13.cpp", "a");       //Pass "a" to create the file and append to it -- SEE pname
    if(!output) {
        fprintf(stderr, "Could not create abc13.cpp!\n");
        exit(1);
    }
    //Init the output file
    fprintf(output, "#include <iostream>\n\nusing namespace std;\n\nint main(int argc, const char* argv[]) {\n");
    yyparse();      //Generate the code by parsing the input
    fprintf(output, "\nreturn 0;\n}");      //The end of the output file
    fclose(output);
}