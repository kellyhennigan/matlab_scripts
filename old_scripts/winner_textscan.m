subjArr={'J-1','J-2','J-4','J-5'};

for subjcnt=1:length(subjArr);

inputFile = ['/Users/grace/Desktop/winners_curse/Auctions/events/sbad/round/203-' subjArr{subjcnt} '.txt'];

fid = fopen(inputFile);
A = textscan(fid, '%n %n %n %n %n %n %n %n %n %n %n');

B = nan(40,1);
E = nan(40,1);

for i=1:length(A{11})
    if A{11}(i) == 0
        B(i)= A{10}(i);
    elseif A{11}(i)==1
        E(i)= A{10}(i);
        
    end
end

C=isnan(B);
D=B(C==0); %D = timing onset
outfile=['/Users/grace/Desktop/winners_curse/timing_grace/' subjArr{subjcnt} '_lose.txt'];
dlmwrite(outfile,D)


F=isnan(E);
G=E(F==0); %D = timing onset
outfile1=['/Users/grace/Desktop/winners_curse/timing_grace/' subjArr{subjcnt} '_win.txt'];
dlmwrite(outfile1,G)






end