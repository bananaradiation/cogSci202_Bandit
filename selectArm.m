% samples from the reward distribution of the arm and returns the reward
function reward = selectArm(mu)
    reward = binornd(1,mu);
end
