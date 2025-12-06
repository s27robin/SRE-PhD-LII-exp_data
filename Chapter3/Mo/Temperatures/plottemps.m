% clear 

load('Mo_Ar_temp.mat')
load('Mo_CO2_temp.mat')
load('Mo_Ne_temp.mat')
load('Mo_N2_temp.mat')
load('Mo_He_temp.mat')

%Delete ouliers
Mo_Ne_temp.MeanTemps{1, 1}(:,5) = [];
Mo_Ne_temp.STD{1, 1}(:,5) = [];
Mo_Ne_temp.Fluences{1, 1}(:,5) = [];

Mo_N2_F5_T = Mo_N2_temp.MeanTemps{1, 1}(:,end);
Mo_N2_F5_S = Mo_N2_temp.STD{1, 1}(:,end);
Mo_N2_temp.MeanTemps{1, 1}(:,end) = [];
Mo_N2_temp.STD{1, 1}(:,end) = [];
Mo_N2_temp.Fluences{1, 1}(:,end) = [];

Time = (0:(4e-10):((4e-10)*(size(Mo_Ar_temp.STD{1},1)-1)))'*1e9;
color = ["red","blue","magenta","green","black"];
shape = ["r-s","b-o","m-d","g-<","k-^"];
All = {Mo_Ar_temp,Mo_CO2_temp,Mo_Ne_temp,Mo_N2_temp,Mo_He_temp};

figure
for i = 1:5
    Data = All{i};
    [Peaks, err, Flus] = peak_err(Data);
    errorbar(Flus,Peaks,err,shape(i),'MarkerSize',10,...
  'MarkerFaceColor',color(i),'LineWidth',1.5)
hold on
end
hold off
legend('Ar','CO2','Ne','N2','He')

All{1, 4}.MeanTemps{1, 1} (:,5) = Mo_N2_F5_T;
All{1, 4}.STD{1, 1} (:,5) = Mo_N2_F5_S;

figure
Flu = 5;
for i = 1:5
    Data = All{i};
    [Temps, std] = Temprof(Data, Flu);
    plot(Time,Temps)
    hold on
hold on
end
hold off
legend('Ar','CO2','Ne','N2','He')


%max temps
function [Peaks, err, Flus] = peak_err(Data)
Peaks = Data.MeanTemps{1}(1,:);
err = ones(length(Peaks),1);
for i = 1:length(err)
    err(i) = Data.STD{1}(1,i);
end 
Flus = cell2mat(Data.Fluences);
end

%Temp profile 
function [Temps, std] = Temprof(Data, Flu)
Temps =Data.MeanTemps{1}(:,Flu);
std = Data.STD{1}(:,Flu);
end



%Plot Means 
% figure
% for ii = 1:size(Mean_temps,2)
%     plot(Time(1:size(Mean_temps(Ind_std(ii):end,ii),1)),Mean_temps(Ind_std(ii):end,ii))
%     hold on
% end