% In the input dataset, each row is a sample and each column a feature.

% X = X_DE.X_DE.';
X = X_DE';
% size = size(X_DE.X_DE,2);
sizee = size(X_DE,2);
% Time domain features
Xmean = mean(X)';
Xsum  = sum(X)';
Xstd  = std(X)';
Xvar  = Xstd.^2;
Xrms  = sqrt(sum(X.^2)/sizee).';
Xmax  = max(X)';
Xmin  = min(X)';
Xkv   = (sum(((X-mean(X))./std(X)).^4)./sizee).';
Xppv  = (max(X) - min(X)).';
Xif   = (max(abs(X))./(sum(abs(X))./sizee)).';
Xsf   = (max(abs(X))./((sum(X.^2)./sizee).^2)).';
Xsra  = ((sum(sqrt(abs(X)))./sizee).^2).';
Xsv   = (sum(((X-mean(X))./std(X)).^3)./sizee).';
Xcf   = (max(abs(X))./((sum(X.^2)./sizee).^(1/2))).';
Xmf   = (max(abs(X))./Xsra').';
Xkf   = (Xkv./(Xrms.^4));
  

% Frequency domain features
X_fre= fft(X);
Xfc  = (sum(X_fre)/sizee).';
Xrmsf= sqrt(sum(X_fre.^2)/sizee).';
Xrvf = ((sum(X_fre - Xfc')./sizee).^(1/2))';
% Calulation of maxPower of the signals
X_fre = X_fre';
Xpwr = [];
for row = 1:size(X_fre,1)
   [p,f,pwr] = pspectrum(X_fre(row,:)','persistence');
   Xpwr = vertcat(Xpwr,max(pwr));
end

% Time frequency domain features. Wavelet pakets was used
X = X';
Z = [];
time_fre = [];
for row=1:size(X,1)
    T = wpdec(X(row,:),4,'db4');
    Z = [];
    for i = 0:15
        temp = wpcoef(T,[4 i]);
        temp = sum(temp.^2,2);
        Z = [Z,temp];
    end
    Z = Z./sum(Z,2);
    time_fre = vertcat(time_fre,Z);
end


feat = [];
feat = [feat,Xmean,Xsum,Xstd,Xvar,Xmax,Xmin,Xrms,Xkv,Xppv,Xif,Xsf,Xsra,Xsv,Xcf,Xmf,Xkf,Xfc,Xrmsf,Xrvf,Xpwr,time_fre];
save('X_DEfeatures.mat','feat');
 