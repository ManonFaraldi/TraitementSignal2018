clear all
close all

%% Chargement dataEEG.mat

load('dataEEG.mat')

%% Calcul alphas électrode 1
i_e = 1;
for i_s = 1:5
    for i_p = 1:2
        Amp = cell2mat(dataEEG(i_p, i_e, i_s));
        Amp = Amp - mean(Amp);
        Ampint = cumsum(Amp);
        Ampint = Ampint';
        
%         Fech = 1000;
%         Tf = 32; %taille d'une fenêtre
%         Toverlap = 0.5*Tf; %recouvrement de deux fenêtres successives
%         Nfft = 64; %nombre de points utilisés pour la tf dans une fenêtre
%         figure((i_s - 1)*2 + i_p )
%         subplot(2,1,1)
%         plot((1:1001)*(1/Fech), Amp)
%         subplot(2,1,2)
%         spectrogram(Amp, Tf, Toverlap, Nfft, Fech, 'yaxis')
        
        alphaE1(i_s, i_p) = DFA(Ampint, size(Ampint, 2));
    end
end

%% Calcul alphas électrode 2
i_e = 2;
for i_s = 1:5
    for i_p = 1:2
        Amp = cell2mat(dataEEG(i_p, i_e, i_s));
        Amp = Amp - mean(Amp);
        Ampint = cumsum(Amp);
        Ampint = Ampint';
        alphaE2(i_s, i_p) = DFA(Ampint, size(Ampint, 2));
    end
end



%% Calcul moyennes de Alpha selon électrode et phase
for i=1:2
    alphaMean(1,i) = mean(alphaE1(1:5, i));
    alphaMean(2,i) = mean(alphaE2(1:5, i));
end

%% Tracé figures
figure(1)
scatter(1:5, alphaE1(1:5,1), 'r')
hold on
scatter(1:5, alphaE1(1:5,2), '+', 'k')
plot([0 6], [alphaMean(1,1) alphaMean(1,1)], 'LineStyle', '--', 'Color', 'r')
plot([0 6], [alphaMean(1,2) alphaMean(1,2)], 'LineStyle', '-.', 'Color', 'k')
axis([0 6 0 1.5])
xlabel('sujet')
ylabel('Alpha')
title('Electrode 1')
legend({'phase 1','phase 2','moy phase 1','moy phase 2'},'Location','southeast')

figure(2)
scatter(1:5, alphaE2(1:5,1), 'r')
hold on
scatter(1:5, alphaE2(1:5,2), '+', 'k')
plot([0 6], [alphaMean(2,1) alphaMean(2,1)], 'LineStyle', '--', 'Color', 'r')
plot([0 6], [alphaMean(2,2) alphaMean(2,2)], 'LineStyle', '-.', 'Color', 'k')
axis([0 6 0 1.5])
xlabel('sujet')
ylabel('Alpha')
title('Electrode 2')
legend({'phase 1','phase 2','moy phase 1','moy phase 2'},'Location','southeast')

%% Détermination des faux (positifs et négatifs

% Faux positif --> pour les phases 1 : on détecte une charge mentale élevé
% alors qu'elle est faible

% Faux négatif --> Pour les phases 2 : On détecte faible CM alors qu'elle
% est forte

% Electrode 1
% Phase 1
note(1,1) = 0;
for i_s = 1:5
    if(abs(alphaE1(i_s, 1) - alphaMean(1,1)) < abs(alphaE1(i_s, 1) - alphaMean(1,2)))
        note(1,1) = note(1,1) + 1;
    end
end

% Phase 2
note(1,2) = 0;
for i_s = 1:5
    if(abs(alphaE1(i_s, 2) - alphaMean(1,2)) < abs(alphaE1(i_s, 2) - alphaMean(1,1)))
        note(1,2) = note(1,2) + 1;
    end
end

% Electrode 2
% Phase 1
note(2,1) = 0;
for i_s = 1:5
    if(abs(alphaE2(i_s, 1) - alphaMean(2,1)) < abs(alphaE2(i_s, 1) - alphaMean(2,2)))
        note(2,1) = note(2,1) + 1;
    end
end

% Phase 2
note(2,2) = 0;
for i_s = 1:5
    if(abs(alphaE2(i_s, 2) - alphaMean(2,2)) < abs(alphaE2(i_s, 2) - alphaMean(2,1)))
        note(2,2) = note(2,2) + 1;
    end
end

%%