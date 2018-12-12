function [alpha] = DMA(Yint, M)

    ListeN = [11 13 17 21 27 35 47 59 77 101];
    for i=1:10
        N = ListeN(i);
        a = zeros(1,N+1);
        b = zeros(1,N+1);
        a(2) = -N;
        a(1) = N;
        b(N+1) = -1;
        b(1) = 1;
        delta = (N-1)/2;

        YintF = filter(b,a,Yint);
        YintFDecale = YintF(delta:M); % On applique le décalage
        YintDecale = Yint(1:M-delta); % On enlève les derniers termes qui sont en excédent
        
        FN(i) = 0;
        for n = 1:(M - delta)
            FN(i) = FN(i) + (YintDecale(n) - YintFDecale(n))^2;
        end
        FN(i) = FN(i)/(M-delta);
        FN(i) = sqrt(FN(i));
    end
    
    regLin = polyfit(log10(ListeN),log10(FN),1);
    alpha = regLin(1);
end