%Los negros hacen esquina
%Los negros no pueden girar en el siguiente de la bola negra
%Los blancos atraviesan recto
%Los blancos tienen que girar una o dos veces despues del blanco
%Los negros en las esquinas hacen esquina
% 1 - - .
% |
% |
% .
%Los blancos en el borde siguen el borde 1 vez
% . - 0 - .
%Los blancos en paralelo a un blanco en el borde hacen una paralela
% - 0 - .
% - 0 - .

%Si hay un negro en la esquina y otro en la soguiente esquina interior tambien hace esquina
% 1 - - .
% | 1 - -
% | |
% . |
%No puede haber un blanco en la esquina
%Si hay un negro en el borde tiene 2 palos hacia el interior
% . . 1 . .
% . . | . .
% . . | . .
%Un negro en paralelo a un borde tiene 2 palos hacia el interior
% . . . . .
% . . 1 . .
% . . | . .
% . . | . .
%Si tengo un negro en el borde con un edge en el borde y el punto de al lado en el borde del negro
% es un edge, entonces el negro va hacia el interior 


%#const n = 2.

row(0..n-1).
col(0..n-1).
point( (X,Y) ) :- row(X), col(Y).


adj( (X,Y), (X,Y + 1)) :- row(X), col(Y), col(Y + 1). %x es adyacente a y, y no es la ultima
adj( (X,Y), (X + 1,Y)) :- row(X), col(Y), row(X + 1). %lo mismo verticalmente


{edge(P,Q)} :- adj(P,Q). %para cada adyacente se crea un edge
edge(Q,P) :- edge(P,Q). %crear el otro sentido para seguir operando

used(P) :- edge(P,_). % el primer argumento de un edge siempre es un used
:- used(P), #count{Q: edge(P,Q)} != 2. %no puede ser que si cuento el numero de edges que salen del punto de mas de dos

%El bucle debe pasar por todas las coordenadas en las que haya un circulo blanco o negro
circle((X/n,X\n)) :- black(X).
circle((X/n,X\n)) :- white(X).
%No hay un circulo si no esta usado.
:- circle(X), not used(X).

%Formar un bucle unico sin que se crucen las lineas.
reach (X, Y) :- edge (X, Y).
reach (X, Z) :- edge (Y, Z), reach(X, Y).

:-circle(X), used(P), not reach(X, P), X!=P.

%Condiciones de blancos y negros
%Los blancos son atravesados rectos y tiene uno o dos giros después
%Los negros hacen esquina y siguen recto

% Se comprueba para cada bola si tiene los edges salientes alineados horizontalmente (condicion de bola blanca)
%Mirar en vertical y en horizontal
whitecond(B)   :- circle(B), edge (B, (X1, Y1)), edge (B, (X2, Y2)), |Y1-Y2| == 2.
whitecond(B)   :- circle(B), edge (B, (X1, Y1)), edge (B, (X2, Y2)), |X1-X2| == 2.


%No puede haber una blanca que no cumpla la condicion de las blancas
%Para ello se mira la coordenada y se compara con white para saber si es white y luego se indica que cumpla la condicion
%Miro para la primera coord y la segunda

:- white(X), not whitecond((X/n,X\n)).

%:- white(X), edge((C1,C2),_), not whitecond((C1,C2)), X/n=C1, X\n=C2.
%:- white(X), edge(_,(C1,C2)), not whitecond((C1,C2)), X/n=C1, X\n=C2.

%No hay negros que esten alineados
:- black(X), whitecond((X/n,X\n)).

%Condicion de que el negro tiene que tener 2 edges seguidas rectas (diferencia de 4 ahora)
% a lo mejor crear unos nuevod q sea los que cumplan no cumplan whitecond y sean black
%blackcond (B) :- circle(B), edge(B, C1), edge(C2, (X1,Y1)), edge(B, D1), edge(D2, (X2,Y2)), |Y1-Y2| == 4, C1!=D1, C1!=D2, C2!=D1, C2!=D2, C1==C2, D1==2.
%blackcond (B) :- circle(B), edge(B, C1), edge(C2, (X1,Y1)), edge(B, D1), edge(D2, (X2,Y2)), |X1-X2| == 4, C1!=D1, C1!=D2, C2!=D1, C2!=D2, C1==C2, D1==2.

%Los negrso son estos
newblack(X) :- circle(X), not whitecond(X). 

%Aux es la coord adyacente a un negro
%aux(Y) :- newblack(X), edge(X, Y).
%aux2((X2,Y2)) :- aux((X1,Y1)), edge((X1,Y1),(X2,Y2)), X1=X2, |Y1-Y2| == 1.
%aux2((X2,Y2)) :- aux((X1,Y1)), edge((X1,Y1),(X2,Y2)), Y1=Y2, |X1-X2| == 1.

%Para cada negro y su adyacente cumple la condicion si la diferencia entre el extremo y el negro es 2
%blackcond((X1,X2)) :- newblack((X1, X2)), aux2((Y1,Y2)), |X2-Y2| == 2. 
%blackcond((X1,X2)) :- newblack((X1, X2)), aux2((Y1,Y2)), |X1-Y1| == 2. 

%IDEA, GUARDAR LOS ADYACENTES A UN NEGRO, VER QUE CUMPLAN LA WHITCOND, LUEGO NO 
%PUEDE HABER UN NEGRO CON UN SEG DESDE ESE Q NO CUMPLA LA WHITECOND EN EL OTRO
%Lo que pasa es q una vez se cumple, entonces ya queda como valido

blackcond ((X1,Y1)) :- circle((X1,Y1)), edge((X1,Y1), C), edge(C, (X2,Y2)), |Y1-Y2| == 2, X1==X2, Y1!=Y2, edge((X1,Y1), B), edge(B, (X3,Y3)), |X1-X3| == 2, Y1==Y3, X1!=X3.
%blackcond ((X1,Y1)) :- circle((X1,Y1)), edge((X1,Y1), C), edge(C, (X2,Y2)), |X1-X2| == 2, Y1==Y2, X1!=X2.



wcond ((X1,Y1)) :- circle((X1,Y1)), edge((X1,Y1), C), edge(C, (X2,Y2)),
    X1==X2, Y1!=Y2, edge((X1,Y1), B), edge(B, (X3,Y3)), 
    |Y2-Y3| >= 4, X1==X3, Y1!=Y3.

wcond ((X1,Y1)) :- circle((X1,Y1)), edge((X1,Y1), C), edge(C, (X2,Y2)),
    Y1==Y2, X1!=X2, edge((X1,Y1), B), edge(B, (X3,Y3)), 
     |X2-X3| >= 4, Y1==Y3, X1!=X3.

%No puede haber un negro que no tenga dos rectas seguidas salientes
:- black(X), not blackcond((X/n,X\n)).
%No puede haber un blanco que tenga dos rectas seguidas salientes
:- white(X), wcond((X/n,X\n)).



%Simplificar salida
edgesimple(P,Q) :- edge(P,Q), P < Q.
%Crear segmentos pedidos en el enunciado
seg(N1*n+N2,M1*n+M2) :- edgesimple((N1,N2),(M1,M2)).

#show seg/2.