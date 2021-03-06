close all;
clear all;
%%
%================================
% Bruit blanc
%================================
M = 2048;
Y1 = randn(1, M); %bruit blanc

moy = 5;
var = 4;
Y2 = sqrt(var)*randn(1, M) + moy; % on voit avec le spectrogramme qu'on n'a pas un bruit blanc, ce qui est d� � la moyenne

Fech = 1000;
Tf = 256; %taille d'une fen�tre
Toverlap = 0.5*Tf; %recouvrement de deux fen�tres successives
Nfft = 1024; %nombre de points utilis�s pour la tf dans une fen�tre
subplot(2,2,1)
plot((1:M)*(1/Fech), Y1)
subplot(2,2,2)
plot((1:M)*(1/Fech), Y2)
subplot(2,2,3)
spectrogram(Y1, Tf, Toverlap, Nfft, Fech, 'yaxis')
subplot(2,2,4)
spectrogram(Y2, Tf, Toverlap, Nfft, Fech, 'yaxis')

%%
%================================
% Analyse r�gularit�
%================================

%%M = 2048;
Y1 = Y1 - mean(Y1);
Y2 = Y2 - mean(Y2);

Yint1 = cumsum(Y1);
Yint2 = cumsum(Y2);

subplot(1,2,1)
plot(Yint1)
subplot(1,2,2)
plot(Yint2)

N = 101;
L = floor(M/N);

for l = 1:L
    x(l, :) = polyfit((N*(l-1) + 1 : N*l),Yint1(N*(l-1) + 1 : N*l),1); % On travaille sur des intervalles allant de N*(l-1) + 1 � N*l, et on cherche les valeurs de YInt1 sur ces intervalles (n = 1 pour degr� polynome)
end

nbSeg = size(x);

close all;
plot(Yint1)
hold on
for l = 1:nbSeg(1)
    plot((N*(l-1) + 1 : N*l), x(l,1)*(N*(l-1) + 1 : N*l) + x(l,2), 'Color', 'r', 'LineWidth', 2)
    hold on
    line([N*l N*l], [min(Yint1) - 5, max(Yint1) + 5], 'Color', 'g', 'LineStyle', '--')
    hold on
end

FN = 0;
for l = 1:L
    for n = 1:N
        FN = FN + (Yint1((l-1)*N + n) - x(l,1)*((l-1)*N + n) + x(l,2))^2;
    end
end
FN = FN / (L*N);
FN = sqrt(FN);

%%
%================================
% Calcul de alpha
%================================

close all;

ListeN = [11 13 17 21 27 35 47 59 77 101];
taille = size(ListeN, 2); % On prend la deuxi�me dimension, cad le nb de colonnes

for i = 1:taille
    N = ListeN(i);
    L = floor(M/N);

    for l = 1:L
        x(l, :) = polyfit((N*(l-1) + 1 : N*l),Yint1(N*(l-1) + 1 : N*l),1); % On travaille sur des intervalles allant de N*(l-1) + 1 � N*l, et on cherche les valeurs de YInt1 sur ces intervalles (n = 1 pour degr� polynome)
    end

    FN(i) = 0;
    for l = 1:L
        for n = 1:N
            FN(i) = FN(i) + (Yint1((l-1)*N + n) - x(l,1)*((l-1)*N + n) - x(l,2))^2;
        end
    end
    FN(i) = FN(i) / (L*N);
    FN(i) = sqrt(FN(i));
end

scatter(log10(ListeN), log10(FN)) % On affiche 
regLin = polyfit(log10(ListeN),log10(FN),1);
alpha = regLin(1);

%%
%===================================
% Calcul E et V de alpha pour 50 BB
%===================================
clear all;
close all;
M = 2048;
for i=1:50
    Y1 = randn(1, M); %bruit blanc
    Y1 = Y1 - mean(Y1);
    Yint1 = cumsum(Y1);
    alpha(i) = DFA(Yint1, M);
end
alphaMean = mean(alpha);
alphaVar = var(alpha);

%%
%===================================
% DMA
%===================================

clear all;
close all;

M = 2048;
Y = randn(1, M);
Y = Y - mean(Y);
Yint = cumsum(Y);

ListeN = [11 13 17 21 27 35 47 59 77 101];
for i=1:1
    N = ListeN(i);
    a = zeros(1,N+1);
    b = zeros(1,N+1);
    a(2) = -N;
    a(1) = N;
    b(N+1) = -1;
    b(1) = 1;
    delta = (N-1)/2;
    
    YintF = filter(b,a,Yint);
    YintFDecale = YintF(delta:M); % On applique le d�calage
    YintDecale = Yint(1:M-delta); % On enl�ve les derniers termes qui sont en exc�dent
    figure
    plot(YintDecale)
    hold on
    plot(YintFDecale, 'Color', 'r');
end

% zplane(b, a)  % V�rification graphique p�les et z�ros
% freqz(b,a,2^20)

%%
%%
%===================================
% Calcul E et V de alpha pour 50 BB
%===================================

M = 2048;
for i=1:500
    Y1 = randn(1, M); %bruit blanc
    Y1 = Y1 - mean(Y1);
    Yint1 = cumsum(Y1);
    alpha(i) = DMA(Yint1, M);
end
alphaMean = mean(alpha);
alphaVar = var(alpha);