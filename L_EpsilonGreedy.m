function [L] = L_EpsilonGreedy(data_A, data_R, alpha, beta, epsilon, T, n)

% 
% data is the data matrix from the mat, which is 10 by 50 by 8 or 16
%
% data_A is the action data and data_R is the reward data
%
% alpha is a vector
%
% beta is a vector
%
% T is the trial numbers (8 or 16)
%
% n is the number of the subject 
%
% This function is to generate the likelihood given the data
% The search space should go through alpha, beta, and epsilon
% which are given in this simple function
%
% The L will be a matrix n by 50, n is the subject, 50 is the 50 games

L = zeros(n,50);
n
for i = 1:n;

  seq_A = squeeze(data_A(i,:,:))'
  seq_R = squeeze(data_R(i,:,:))'

  for games = 1:size(seq_A,1);
   
   % Initialize the mu, s, f, and LL

    mu_1 = alpha(1)/(alpha(1)+beta(1));
    mu_2 = alpha(2)/(alpha(2)+beta(2));
    s_1 = 0;
    s_2 = 0;
    f_1 = 0;
    f_2 = 0;
    LL = 1;

  if seq_A(games,1) == 1

  LL = (mu_1^(seq_R(games,1)))*((1-mu_1)^(1-seq_R(games,1)));
  s_1 = s_1 + 1*seq_R(games,1);
  f_1 = f_1 + 1*(abs(1-seq_R(games,1)));

  else

  LL = (mu_2^(seq_R(games,1)))*((1-mu_2)^(1-seq_R(games,1)));
  s_2 = s_2 + 1*seq_R(games,1);
  f_2 = f_2 + 1*(abs(1-seq_R(games,1)));

  end;

  mu_1 = (alpha(1) + s_1)/(1 + alpha(1) + beta(1));
  mu_2 = (alpha(2) + s_2)/(1 + alpha(2) + beta(2));

  for trial = 2:T

  % Four components for the likelihood function of each trial 
  % List out the rules

     stay = abs(seq_A(games, trial - 1) - seq_A(games, trial));
     a = (epsilon^(1-stay))*((1-epsilon)^stay); 
 
     if seq_A(games,trial) == 0

     r = (mu_1^(seq_R(games,trial)))*((1-mu_1)^(1-seq_R(games,trial)));
     s_1 = s_1 + 1*seq_R(games,trial);
     f_1 = f_1 + 1*(abs(1-seq_R(games,trial)));  

     else

     r = (mu_2^(seq_R(games,trial)))*((1-mu_2)^(1-seq_R(games,trial)));
     s_2 = s_2 + 1*seq_R(games,trial);
     f_2 = f_2 + 1*(abs(1-seq_R(games,trial)));
     end;


     LL = LL*a*r; 

     mu_1 = (alpha(1) + s_1)/(s_1 + f_1 + alpha(1) + beta(1));
     mu_2 = (alpha(2) + s_2)/(s_2 + f_2  + alpha(2) + beta(2));

     end;

  L(i,games) = LL;

  end;

end


 
