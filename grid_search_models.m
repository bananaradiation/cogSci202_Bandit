function [best_alpha_beta, best_seq] = grid_search_models(data_A, data_R, T, model_flag, params)

% This function is to do the loop for grid searching
% It calls the Likelihood function
% It will give the best sequence that has highest likelihood
% data_A is the decision vectors
% data_R is the reward vectors
% T is the number of trials
% model_flag indicate which heuristic model we are using
%
% params is vector for the best parameters from the optimal model
%
% 1 WinStayLooseShift
%   params = gamma
%
% 2 Epsilon_Greedy
%   params = epsilon
%
% 3 
%

% Initialize the grid search

alpha = 1:4;
beta = 4:-1:1;
seq = [];

% List all possible sequences

for j = 1:T/2;

  C = nchoosek([1:8],j);
  S = zeros(nchoosek(8,j),8);
  
    for k = 1:length(C);

      S(k,C(k,:)) = 1; 

    end;

seq = [seq;S];

end;

seq = [seq;abs(seq-1);zeros(1,8);ones(1,8)];


% Begin to do search

for i = 1:4;


   for j = 1:size(seq,1);

   a_vec = seq(j,:);

   switch model_flag 

   case 1
   gamma = params;
   L(j,:,:) = L_WinStayLooseShift(a_vec, data_A, data_R, alpha(i), beta(i), gamma, T, 10);

   case 2
   epsilon = params;
   L(j,:,:) = L_EpsilonGreedy(a_vec, data_A, data_R, alpha(i), beta(i), epsilon, T, 10);   

   case 3
   epsilon0 = params;
   L(j,:,:) = L_EpsilonDecreasing(a_vec, data_A, data_R, alpha(i), beta(i), epsilon0, T, 10);

   case 4
   tau = params;
   L(j,:,:) = L_TauSwitch(a_vec, data_A, data_R, alpha(i), beta(i), tau, T, 10);

   end   

   end;

   [ml ms] = max(L);
   LL(i,:,:) = squeeze(ml);
   pos(i,:,:) = squeeze(ms);
   

end;

[ml ms] = max(LL);

best_seq = zeros(10,50,8);
best_alpha_beta = squeeze(ms);
max_L = squeeze(ml);


for i = 1:10;

  for j = 1:50;

  best_seq(i,j,:) = seq(pos(ms(1,i,j),i,j),:);

  end;


end;



