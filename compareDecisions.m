% compares 2 column vectors representing decisions and returns a percentage of matches
function percentMatch = compareDecisions(decVector1, decVector2)
    if (size(decVector1,2) ~= 1 || size(decVector2,2) ~= 1 || size(decVector1,1) ~= size(decVector2,1))
        error('Invalid input to compareDecisions() : must be column vectors of same dimensions');
    end
    percentMatch = sum(decVector1 == decVector2) / size(decVector1,1);
end