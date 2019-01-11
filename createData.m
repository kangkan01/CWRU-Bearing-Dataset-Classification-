files=dir('*.mat');
nfiles = length(files);
y = [];
X_DE = [];
X_FE = [];
for i=1:nfiles
    temDE = 0;
    temFE = 0;
    currentfilename = files(i).name;
    dat = load(currentfilename);
    fields = fieldnames(dat);
    for j=1:length(fields)
        name=fields{j};
        if contains(name,'DE_time')
             temDE = 1;
        elseif contains(name,'FE_time')
             temFE = 1;
        end
    end
    if ~(temFE == 1 & temDE == 1)
        display(currentfilename)
    end
end
% Since the times of all the smaples differ, we take the times number of the lowest of all samples
mini = 1000000;
for i=1:nfiles
    currentfilename = files(i).name;
    dat = load(currentfilename);
    fields = fieldnames(dat);
    for j=1:length(fields)
      name=fields{j};
      if contains(name,'DE_time')
          mini = min(mini,size(dat.(name),1));
      elseif contains(name,'FE_time')
          mini = min(mini,size(dat.(name),1));
      end
   end
end
    
for i=1:nfiles
   currentfilename = files(i).name;
   % Getting name for the y label
   temp = extractBefore(extractAfter(currentfilename,"."),".mat");
   %regexp(temp,'[a-z]\w+','match');
   str = extractBefore(currentfilename,"EF") + "EF" + temp;
   y = vertcat(y,str);
   % Making saperate datasets out of DE and FE times.
   dat = load(currentfilename);
   fields = fieldnames(dat);
   for j=1:length(fields)
      name=fields{j};
      if contains(name,'DE_time')
          X_DE = vertcat(X_DE,(dat.(name)(1:mini,1))');
      elseif contains(name,'FE_time')
          X_FE = vertcat(X_FE,(dat.(name)(1:mini,1))');
      end
   end
end

save("X_DE.mat","X_DE");
save("X_FE.mat","X_FE");
save("y.mat","y");