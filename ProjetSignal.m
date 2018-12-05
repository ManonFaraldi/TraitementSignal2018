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
Y2 = sqrt(var)*randn(1, M) + moy; % on voit avec le spectrogramme qu'on n'a pas un bruit blanc, ce qui est dû à la moyenne

Fech = 1000;
Tf = 256; %taille d'une fenêtre
Toverlap = 0.5*Tf; %recouvrement de deux fenêtres successives
Nfft = 1024; %nombre de points utilisés pour la tf dans une fenêtre
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
% Analyse régularité
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
    x(l, :) = polyfit((N*(l-1) + 1 : N*l),Yint1(N*(l-1) + 1 : N*l),1); % On travaille sur des intervalles allant de N*(l-1) + 1 à N*l, et on cherche les valeurs de YInt1 sur ces intervalles (n = 1 pour degré polynome)
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