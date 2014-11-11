function [negLogLike, td, exploitation, probs, mRec] = indirectActorIndv(exploration, reward, choice, numChoice, learningRate)
%indirectActorIndv  Negative log likelihood of the indirect actor model on the
%   basis of behavioral data from a participants. 
%
%   NLL = indirectActorIndv(exploration, reward, choice, numChoice, learningRate, initM, decayParameter, decayCenter)
%   returns negative log likelihood NLL given behavioral data and parameters.
%
%   Behavioral data: reward, choice, numChoice
%       reward : the array of received rewards of a participant
%       choice : the array of choices of a participant
%       numChoice : the number of choices in the experiment
%
%   Parameters : exploration, learningRate
%       exploration : exploration parameter of Softmax method
%       learningRate : learning rate of the indirect actor
%       
%   [NLL, T] = indirectActorIndv(...)
%   returns the array of TD(temporal difference) T.
%
%   [NLL, T, Ex] = indirectActorIndv(...)
%   returns the array of exploitations Ex.
%       exploitation is 1 when a participant exploits,
%       exploitation is 0 when a participant explores,
%       and exploitation is -1 when a participant does not make a choice
%
%   [NLL, T, Ex, Ps] = indirectActorIndv(...)
%   returns the matrix of probabilities of alternatives.
%       In the matrix, row represents trial and column is the number of choices.
%
%   [NLL, T, Ex, Ps, mR] = indirectActorIndv(...)
%   returns the matrix of acton values of alternatives.
%       In the matrix, row represents trial and column is the number of choices.
%
%   Jee Hoon, Yoo in University of Bristol, September 2008

trials  = length(choice);
% the number of trials

m       = zeros(1, numChoice);
% action values

probs   = zeros(trials, numChoice);
% probability of each choice in trials
mRec    = zeros(trials, numChoice);
% action values for recoding

td              = zeros(trials, 1);
% temporal difference

exploitation    = zeros(trials, 1);
% whether a participant exploits

%%%%% update procedure %%%%%
probs(1, :) = 1/numChoice;
% probabilities in first trial is initialized to have equal values.

if (exploration < 0 || learningRate < 0)
    negLogLike = 10000;
    if (exploration < 0)
        negLogLike = negLogLike - exploration;
    end
    if (learningRate < 0)
        negLogLike = negLogLike - learningRate;
    end
else
for i = 1:(trials-1)
    if (choice(i) == 0)
        exploitation(i) = -1;
        % exploitation is set to -1 when a participant does not decide.
    else
        [maxValue maxIndex] = max(m);
        if (choice(i) == maxIndex)
            exploitation(i) = 1;
        end
        % only when a participant chooses the score box of the highest
        % action value, exploitation is 1.
        
        td(i)               = reward(i) - m(choice(i));
        m(choice(i))        = m(choice(i)) + learningRate * td(i);
        % only chosen box's action value is updated.
    end
    
    probs(i+1,:) = softmax(m, exploration);
    % probabilities are evaluated by Softmax method 
    % with exploration parameter.
    
    mRec(i+1,:) = m;
    % for recoding action values.
end

if (choice(trials) == 0)
    exploitation(trials) = -1;
else
    [maxValue maxIndex] = max(m);
    if (choice(trials) == maxIndex)
        exploitation(trials) = 1;
    end
    
    td(trials)                      = reward(trials) - m(choice(trials));
    mRec(trials, choice(trials))    = mRec(trials, choice(trials)) + learningRate * td(trials);
end
% the last updating procedure for exploitation and td.

%%%%% evaluation procedure %%%%%
negLogLike = 0;
for i = 1:trials
    if (choice(i) ~= 0)
        negLogLike = negLogLike - log(probs(i, choice(i)));
    end
    % only when a participant makes a choice,
    % negative log likelihood is evaluated.
end

end