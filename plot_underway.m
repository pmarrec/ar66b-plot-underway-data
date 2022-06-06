clearvars, clc, close all

%Get the underway daily ARYYMMDD_0000.csv files form the ship's server
rep = '\\10.100.100.30\data_on_memory\underway\proc\';

%Concatenate the csv files from a start date to a end date
START=220420; END=220427;
%Set the interval = 1 day from start to end
INT=START:1:END;

%Create a cell structure to store the csv files for each day
c = cell(1,length(INT));
%For each day, open the csv files and store them in different cells
for n=1:length(INT)
    tablename=strcat(rep,'AR',num2str(INT(n)),'_0000.csv');
    c{n}=readtable(tablename);
end
%Concatenate the csv files together in the table structure
table1=vertcat(c{:});

%DateTime conversion from the weird format in the csv files into Matlab
%numeric DateTime values
DATETIME_str=table1.DATE_GMT;
DATETIME=nan(length(DATETIME_str),1);
for n1=1:length(DATETIME_str)
    C1 = strsplit(DATETIME_str{n1},'/');
    nYEAR=str2double(C1{1,1});
    nMONTH=str2double(C1{1,2});
    nDAY=str2double(C1{1,3});
    DATE=datenum(nYEAR,nMONTH,nDAY,0,0,0);
    C2 = strsplit(char(table1.TIME_GMT(n1)),':');
    nHOUR=str2double(C2{1,1});
    nMIN=str2double(C2{1,2});
    TIME=datenum(0,0,0,nHOUR,nMIN,0);
    DATETIME(n1,1)=DATE+TIME;
end

%Get the Lat/Lon/SST/SSS/FLuo underway values from the table
Latitude=table1.Dec_LAT;
Longitude=table1.Dec_LON;
SST=table1.SBE48T;
SSS=table1.SBE45S;
FLUO=table1.FLR;

%Find all the values with Lat<41.33 : Latitude north of Martha's Vineyard
%where the underway data are questionable or were not recorded
a1=find(Latitude<41.33);

%Set the Latitude limits and the Latitude ticks
LATmin=39.5;
LATmax=41.5;
XTick=[39.5 39.7733 39.94 40.1367 40.3633 40.5 ...
    40.6967 40.8633 41.03 41.1967 41.5];
XTickLabel={'39.50','L11','L10','L8','L6','40.50'...
    'L4','L3','L2','L1','41.50'};

%Figure 1 = 3 subplots of Fluo, SST and SSS vs. Latitude (entire study area)
%plot Chla vs. Latitude
fig1=figure(1);
subplot(3,1,1)
plot(Latitude(a1),FLUO(a1),'-','Color','g','LineWidth',2);
xlim([LATmin LATmax])
xticks(XTick)
xticklabels(XTickLabel)
ylim([0 10])
ylabel('Fluorescence (mV)')
ax1=gca;
ax1.XDir='reverse';ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
box on
title('AR66 Fluorescence UW','fontsize',18)
%plot SST vs. Latitude
subplot(3,1,2)
plot(Latitude(a1),SST(a1),'-','Color','b','LineWidth',2);
xlim([LATmin LATmax])
xticks(XTick)
xticklabels(XTickLabel)
ylim([6 18])
ylabel('Temperature (^oC)')
ax1=gca;
ax1.XDir='reverse';ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
box on
title('AR66 Temperature UW','fontsize',18)
%plot SSS vs. Latitude
subplot(3,1,3)
plot(Latitude(a1),SSS(a1),'-','Color','r','LineWidth',2);
xlim([LATmin LATmax])
xticks(XTick)
xticklabels(XTickLabel)
ylim([30 36])
ylabel('Salinity')
xlabel('Latitude (^oN)')
ax1=gca;
ax1.XDir='reverse';ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
box on
title('AR66 Salinity UW','fontsize',18)
hold off
print(fig1,'-dpng','AR66_underway_SST_SSS_Fluo_vs_Lat','-r300')

%Figure 2 = 3 subplots of Fluo, SST and SSS vs. Time
%plot Chla vs. Time
fig2=figure(2);
subplot(3,1,1)
p1=plot(DATETIME(a1),FLUO(a1),'-','Color','g','LineWidth',2);
START=floor(DATETIME(a1(1)));
END=ceil(DATETIME(a1(end)));
xlim([START END])
XTickDate=[START:1:END];
XTickDateLabels=datestr(START:1:END,'mm/dd/yyyy');
xticks(XTickDate)
xticklabels(XTickDateLabels)
ylim([0 10])
ylabel('Fluorescence (mV)')
ax1=gca;
ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
box on
title('AR66 Fluorescence UW','fontsize',18)
%plot SST vs. Time
subplot(3,1,2)
p2=plot(DATETIME(a1),SST(a1),'-','Color','b','LineWidth',2);
START=floor(DATETIME(a1(1)));
END=ceil(DATETIME(a1(end)));
xlim([START END])
XTickDate=[START:1:END];
XTickDateLabels=datestr(START:1:END,'mm/dd/yyyy');
xticks(XTickDate)
xticklabels(XTickDateLabels)
ylim([6 18])
ylabel('Temperature (^oC)')
xlabel('')
ax1=gca;
ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
box on
title('AR66 Temperature UW','fontsize',18)
%plot SSS vs. Latitude
subplot(3,1,3)
p3=plot(DATETIME(a1),SSS(a1),'-','Color','r','LineWidth',2);
START=floor(DATETIME(a1(1)));
END=ceil(DATETIME(a1(end)));
xlim([START END])
XTickDate=[START:1:END];
XTickDateLabels=datestr(START:1:END,'mm/dd/yyyy');
xticks(XTickDate)
xticklabels(XTickDateLabels)
ylim([30 36])
ylabel('Salinity')
ax1=gca;
ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
box on
title('AR66 Salinity UW','fontsize',18)
hold off
print(fig3,'-dpng','AR66_underway_SST_SSS_Fluo_vs_Time','-r300')





