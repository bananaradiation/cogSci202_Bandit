function [FS] = enumStates(trials,arms)
    t = trials;
    % Number of pieces to divide that total into trials
    % q_t = (s_1,s_2,f_1,f_2)
    k = arms*2;
    % All possible placements of internal dividers.
    dividers = nchoosek(1:(t+k-1), k-1);
    ndividers = size(dividers, 1);
    % Add dividers at the beginning and end.
    b = cat(2, zeros(ndividers, 1), dividers, (t+k)*ones(ndividers, 1));
    % Find distances between dividers.
    FS = diff(b, 1, 2) - 1;
end

% http://stackoverflow.com/questions/21500539/combinations-totaling-to-sum