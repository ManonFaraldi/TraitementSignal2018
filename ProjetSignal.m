close all;
clear all;
%%
%================================
% Bruit blanc
%================================
M =50001;
Y1 = randn(1, M); %bruit blanc

moy = 5;
var = 4;
Y2 = sqrt(var)*randn(1, M) + moy; % on voit avec le spectrogramme qu'on n'a pas un bruit blanc, ce qui est dû à la moyenne

Fech = 1000;
Tf = 256; %taille d'une fenêtre
Toverlap = 0.5*Tf; %recouvrement de deux fenêtres successives
Nfft = 1024; %nombre de points utilisés pour la tf dans une fenêtre
subplot(2,2,1)
plot((1:50001)*(1/Fech), Y1)
subplot(2,2,2)
plot((1:50001)*(1/Fech), Y2)
subplot(2,2,3)
spectrogram(Y1, Tf, Toverlap, Nfft, Fech, 'yaxis')
subplot(2,2,4)
spectrogram(Y2, Tf, Toverlap, Nfft, Fech, 'yaxis')

%%
%================================
% Analyse régularité
%================================

M = 2048;
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
    for n = 1:N
        
    end
end