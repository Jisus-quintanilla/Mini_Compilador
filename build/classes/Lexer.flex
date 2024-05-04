import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Tabla de validación */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*
Operadores_aritmeticos = [+|-|*|/]
Operadores_relacionales = [,|.|>=|<=|>|<|=|<>|{|}|[|]|(|)|;|..]
Palabras_reservadas = if|else|for|print|int
Menu = "Huevo"|"Panqueque"|"Pollo"|"Amburguesa"|"Alitas"
Bebida = "Naranaja"|"Sprite"|"limonada"|"Coca_cola"
Bebida_alcol = Cerveza|Rom|Sangria
Menu_Infantil = "Menu_Infantil"|"Desayuno_Infaltil"|"Michiamburguesa"
Postres = "Flan"|"Pie_Queso"|"Pie_Chancleta"|"Muffin"|"Helado" 

/* Número */
Numero = 0 | [0-9][0-9]*
%%

/* Menu */
{Menu} { return token(yytext(), "Menu", yyline, yycolumn); }

/* Bebida */
{Bebida} { return token(yytext(), "Bebida", yyline, yycolumn); }

/* Bebida_alcol */
{Bebida_alcol} { return token(yytext(), "Bebida_alcol", yyline, yycolumn); }

/* Menu_Infantil */
{Menu_Infantil} { return token(yytext(), "Menu_Infantil", yyline, yycolumn); }

/* Postres */
{Postres} { return token(yytext(), "Postres", yyline, yycolumn); }

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Palabras reservadas */
{Palabras_reservadas} { return token(yytext(), "Palabras_reservadas", yyline, yycolumn); }

/* Identificador */
{Identificador} { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }

/* Constantes */
{Numero} { return token(yytext(), "Constantes", yyline, yycolumn); }

/* Colores */
#[{Letra}{Digito}]{6} { return token(yytext(), "COLOR", yyline, yycolumn); }

/* Operadores relacionales */
{Operadores_relacionales} { return token(yytext(), "Operadores_relacionales", yyline, yycolumn); }

/* Operadores aritmeticos */
{Operadores_aritmeticos} { return token(yytext(), "Operadores_aritmeticos", yyline, yycolumn); }


/* Errores */
// Número erróneo
0 {Numero}+ { return token(yytext(), "ERROR_1", yyline, yycolumn); }
{Numero}{Identificador} { return token(yytext(), "ERROR_2", yyline, yycolumn); }
{Numero}{EspacioEnBlanco}{Identificador} { return token(yytext(), "ERROR_2", yyline, yycolumn); }
{Numero}{Menu} { return token(yytext(), "ERROR_3", yyline, yycolumn); }
{Menu_Infantil}{EspacioEnBlanco}{Bebida_alcol} { return token(yytext(), "ERROR_3", yyline, yycolumn); }
{Bebida_alcol}{EspacioEnBlanco}{Bebida_alcol}+ { return token(yytext(), "ERROR_3", yyline, yycolumn); }
. { return token(yytext(), "ERROR", yyline, yycolumn); }