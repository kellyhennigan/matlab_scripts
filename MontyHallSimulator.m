function outcomes = MontyHallSimulator(nTimes, userMode, strategy)

% % INPUT:
% nTimes - number of trials
% user mode - 0 means simulate, 1 means allow user input
% strategy - if userMode is 0 (for simulation), strategy=0 means stay and
%            strategy=1 means switch strategy


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
doors = 1:3;

outcomes = nan(nTimes,1); % 1 means win, 0 means lost

for i=1:nTimes
    
car = randperm(3,1); % door the car is behind

if userMode==1 % get user input
    
    fprintf('\n\nThere''s a car behind door 1,2, or 3. \n\nIf you pick the right one, you win the car!\n\n');
    
    choice = input('Which do you pick?   ');
    
    fprintf(['\nYou chose Door #' num2str(choice) '\n']);
    
    openDoor = find(~ismember(doors,[car,choice]));
    openDoor = randperm(numel(openDoor),1); % host chooses a door to open that has a donkey behind it
    
    switchOption = find(~ismember(doors,[choice,openDoor]));
    
    fprintf(['\nDoor #' num2str(openDoor(1)) ' is opened to reveal a donkey (not a car).\n\n'])
    
    switchOrStay = input(['Want to switch to Door #' num2str(switchOption) '? (y or n)'],'s');
    
    if strcmpi(switchOrStay,'y')
        choice = switchOption;
    end
    
    if choice==car
        fprintf('\n\n Congrats, YOU WIN!!')
    else
        fprintf('\n\n Sorry, no car for you! :(')
    end
    
    
else  % simulate mode
    
    choice = randperm(3,1);
    openDoor = find(~ismember(doors,[car,choice]));
    openDoor = openDoor(randperm(numel(openDoor),1)); % host chooses a door to open that has a donkey behind it
    
    switchOption = find(~ismember(doors,[choice,openDoor]));
    
    if strategy==1 % switching strategy?
        choice = switchOption;
    end
    
end

outcomes(i) = choice==car;

end