%{
#include "parse.tab.h"
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

%%
"PROGRAM"       {   return(PROGRAM);    }
"VAR"           {   return(VAR);        }
"BEGIN"         {   return(START);      }
"END"           {   return(END);        }
"INTEGER"       {   return(INTEGER);    }
"PRINT"         {   return(PRINT);      }

\.             {   return(PERIOD);     }
\:             {   return(COLON);      }
\;             {   return(SEMICOLON);  }
\,             {   return(COMMA);      }
\(             {   return(LPAREN);     }
\)             {   return(RPAREN);     }
\+             {   return(ADD);        }
\-             {   return(SUBT);       }
\*             {   return(MULT);       }
\/             {   return(DIV);        }
\=             {   return(EQ);         }
\'             {   return(QUOTE);     }

'.*'                            {   
                                    char text[strlen(yytext)];
                                    for(int ind = 0; ind <= strlen(yytext); ++ind) {
                                        if(yytext[ind] == '\'') {
                                            text[ind] = '\"';
                                        }
                                        else {
                                            text[ind] = yytext[ind];
                                        }
                                    }
                                    yylval.s = strdup(text);
                                    return(STRING);
                                }
[0-9]+                          {   yylval.s = strdup(yytext);
                                    return(NUM);                }
[a-zA-Z_][a-zA-Z0-9_]*          {   yylval.s = strdup(yytext);
                                    return(IDENTIFIER);         }
%%