function [alpha] = DFA(Yint1, M)
    close all;

    ListeN = [11 13 17 21 27 35 47 59 77 101];
    taille = size(ListeN, 2); % On prend la deuxième dimension, cad le nb de colonnes

    for i = 1:taille
        N = ListeN(i);
        L = floor(M/N);

        for l = 1:L
            x(l, :) = polyfit((N*(l-1) + 1 : N*l),Yint1(N*(l-1) + 1 : N*l),1); % On travaille sur des intervalles allant de N*(l-1) + 1 à N*l, et on cherche les valeurs de YInt1 sur ces intervalles (n = 1 pour degré polynome)
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

    regLin = polyfit(log10(ListeN),log10(FN),1);
    alpha = regLin(1);
end