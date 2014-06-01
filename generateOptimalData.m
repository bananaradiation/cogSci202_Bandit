function [ data_A, data_R ] = generateOptimalData(alpha, beta)

games = 50;
T = 8;
arms = 2;

data_A = zeros(1,games,T);
data_R = zeros(1,games,T);

for g = 1 : games
    [decisions,rewards, mu1, mu2] = optimalModel_new(T,arms,alpha,beta);
    data_A(1,g,:) = decisions;
    data_R(1,g,:) = rewards;
end

filename = strcat('optimalData_',num2str(alpha),'_',num2str(beta),'.mat');
save(filename,'data_A','data_R','alpha','beta');

end

