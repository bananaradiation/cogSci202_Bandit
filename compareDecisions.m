% compares 2 column vectors representing decisions and returns a percentage of matches
function percentMatch = compareDecisions(decVector1, decVector2)
    sum(decVector1 == decVector2) / size(decVector1,1);
end