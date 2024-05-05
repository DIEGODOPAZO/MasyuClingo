#const n = 2.
cord(0..n*n-1, 0..n*n-1 ).


%Unir todos los segmentos con todos, solo unir los que esten pegados entre si
%4 { seg(N,M) } 4 :- cord(N,M), |N-M|=1, N!=M, |N-M|=n.
{ seg(N,M) } :- cord(N,M).

%No puede haber un segmento que una consigo mismo
:- seg(N,M), N=M.
%No puede haber un segmento que una con algo que no sea izq, der, arriba o abajo
:- seg(N,M), |N-M|!=1, |M-N|!=n.
%No puedem unirse elementos de numero seguido pero en distinta linea
:- seg(N,M), |N-M|=1, N/n != M/n.
%Ir de A a B es lo mismo que de B a A
:- seg(N,M), seg(N',M'), N=M', M=N'.
% seg(3,4) seg(4,3)
% a lo mejor esta mal porque no se sabe cual es la direccion
%:- seg(N,M), seg(N',M'), N!=N', M!=M', N+M=N'+M'.
%lo mismo probando que el N < M para seguir un orden para luego poder conectar
:- seg(N,M), seg(N',M'), N!=N', M!=M', N+M=N'+M', N<M.

%Hacer que este conectado
%reach(M) :- seg(_,M).
%reach(Z)

#show seg/2.