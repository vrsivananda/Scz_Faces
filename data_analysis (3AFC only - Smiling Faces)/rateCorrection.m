function rate = rateCorrection(rate, n)
   
    % If the rate is 1, then we correct it
    if (rate == 1)
        rate = 1 - (1/(n+1));
    elseif (rate == 0)
        rate = 1/(n+1);
    end
    
end