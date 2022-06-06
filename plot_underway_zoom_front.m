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

%Set the Latitude limits and the Latitude ticks of the southern part of the
%transect
LATmin=39.7;
LATmax=40.4;
XTick=[39.7 39.7733 39.8  39.9 39.94 40 40.0983...
     40.2 40.2267 40.3 40.3633 40.4];
XTickLabel={'39.70','L11','39.80','39.90','L10','40.00','L9',...
    '40.20','L7','40.30','L6','40.40'};

%Define the numerical value of the start of the end of the colorbar
DATEstart=datenum(2022,04,20);
DATEend=datenum(2022,04,28);

%Figure 1 = 2 subplots of SST and SSS vs. Latitude
%plot SST vs. Latitude
fig1=figure(1);
subplot(2,1,1)
scatter(Latitude(a1),SST(a1),30,DATETIME(a1),'filled','MarkerEdgeColor','none');
hold on
xlim([LATmin LATmax])
xticks(XTick)
xticklabels(XTickLabel)
ylim([6 18])
ylabel('Temperature (^oC)')
ax1=gca;
ax1.XDir='reverse';ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
caxis([DATEstart DATEend]);%Colorbar limits
cmap=parula(8);%Choice of the colormap with 8 colors, 1 for each day
colormap(cmap)
colorbar('location','EastOutside','FontSize',20);
labels = {'04/20','04/21','04/22','04/23','04/24','04/25','04/26','04/27','04/28'}; 
colorbar('Ticks',[DATEstart:1:DATEend],'TickLabels',labels);
box on
title('AR66 Temperature UW','fontsize',18)
%plot SSS vs. Latitude
subplot(2,1,2)
scatter(Latitude(a1),SSS(a1),30,DATETIME(a1),'filled','MarkerEdgeColor','none');
xlim([LATmin LATmax])
xticks(XTick)
xticklabels(XTickLabel)
ylim([32 36])
ylabel('Salinity')
xlabel('Latitude (^oN)')
ax1=gca;
ax1.XDir='reverse';ax1.TickDir='both';ax1.XTickLabelRotation=45;
ax1.FontSize=15; ax1.FontName='Arial'; ax1.FontWeight='bold';
caxis([DATEstart DATEend]);%Colorbar limits
cmap=parula(8);%Choice of the colormap with 8 colors, 1 for each day
colormap(cmap)
colorbar('location','EastOutside','FontSize',20);
labels = {'04/20','04/21','04/22','04/23','04/24','04/25','04/26','04/27','04/28'}; 
colorbar('Ticks',[DATEstart:1:DATEend],'TickLabels',labels);
box on
title('AR66 Salinity UW','fontsize',18)
hold off
print(fig1,'-dpng','AR66_underway_SST_SSS_vs_Lat_zoom',-r300')
