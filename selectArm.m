% samples from the reward distribution of the arm and returns the reward
function reward = selectArm(mu)
    r = rand();
    if r < mu
        reward = 0;
    else
        reward = 1;
    end
end
