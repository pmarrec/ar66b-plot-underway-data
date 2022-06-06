clear all; close all; clc;

addpath('C:/Users/pierr/Documents/MATLAB/m_map/')
addpath('C:/Users/pierr/Documents/MATLAB/')

load('Bathy_zoom.mat')

%Get the underway csv files form the ship's server
rep = '\\10.100.100.30\data_on_memory\underway\proc\';

%Get the CTD data
tableCTD=readtable("ctd_surface_data.csv");
LatitudeCTD=tableCTD.Latitude;
LongitudeCTD=tableCTD.Longitude;
CastCTD=tableCTD.Cast;
DATETIMECTD=tableCTD.DateTime_UTC;
LAT_SMD=LatitudeCTD([1 3 6 8 15 19 20 22]);
LON_SMD=LongitudeCTD([1 3 6 8 15 19 20 22]);

%Concatenate the csv files from a start date to a end date
START=220420; END=220427;
INT=START:1:END;

c = cell(1,length(INT));

for n=1:length(INT)
    tablename=strcat(rep,'AR',num2str(INT(n)),'_0000.csv');
    c{n}=readtable(tablename);
end
table1=vertcat(c{:});


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


Latitude=table1.Dec_LAT;
Longitude=table1.Dec_LON;
SST=table1.SBE48T;
SSS=table1.SBE45S;
FLUO=table1.FLR;

a1=find(Latitude<41.33);
a2=find(Latitude<41.45);

%
% DateTimeCTD=datenum(CTD.date);
% LAT_CTD=CTD.latitude;
% LON_CTD=CTD.longitude;
% cast=CTD.cast;
%
% StationSMD=[1 2 5 11 15 18]';
% LAT_SMD=LAT_CTD(StationSMD);
% LON_SMD=LON_CTD(StationSMD);

% All
North = 42;
South = 39;
East = -69.5;
West = -72.5;

v=[-3000:1000:-1000 -200 -50 0]';
v1=[-5000 -200]';

blueCM=m_colmap('blue');
blueCM1=blueCM(10:end,:);

fig1=figure(1);
set(gca,'FontSize',15,'FontName','Arial');hold on %Set font type and size.
m_proj('Equidistant Cylindrical','lon',[West  East],'lat',[South North]);%set up our projection and bourndaries.
hold on;
m_contourf(LONG,LAT,ELEV,[-3000:100:-500 -500:50:-200 -200:10:0],'edgecolor','none')
colormap(blueCM1)
caxis([-3000 0])
c=[-3000 -2000 -1000 -200 -50 0];
cbar1 = colorbar('location','EastOutside','FontSize',20,'YTick',c,'YTickLabel',c);%position and fontsize of our colour bar.
set(get(cbar1 ,'ylabel'),'String', 'Depth (m)','Rotation',90,'FontSize',20);% font and name on our colourbar.
[c,h]=m_contour(LONG,LAT,ELEV,v,'color','k','LineWidth',0.75);
[c1,h1]=m_contour(LONG,LAT,ELEV,v1,'color','k','LineWidth',1.5);
m_plot(Longitude,Latitude,'LineWidth',2,'color','m');
m_plot(LongitudeCTD,LatitudeCTD,'o','MarkerFaceColor','n','MarkerSize',8,...
    'MarkerEdgeColor','k','LineWidth',2)
m_plot(LON_SMD,LAT_SMD,'s','MarkerFaceColor','w','MarkerSize',15,...
    'MarkerEdgeColor','k','LineWidth',3)
% m_plot(Longitude(end),Latitude(end),'p','Color','r','Markersize',18,...
%         'MarkerEdgeColor','r','MarkerFaceColor','y','LineWidth',2)
m_gshhs('h','patch',[.5 .5 .5],'edgecolor','k');%Set up our coastlines and continents.
m_grid('box','fancy','tickdir','in','fontsize',20);%Set up our fancy box.
Titre='AR66-Spring-2022';
title(Titre,'fontsize',20)
hold off;
% print(fig1,'-dpng',char(Titre),'-r300');

fig2=figure(2);
set(gca,'FontSize',15,'FontName','Arial');hold on %Set font type and size.
m_proj('Equidistant Cylindrical','lon',[West  East],'lat',[South North]);%set up our projection and bourndaries.
hold on;
[c,h]=m_contour(LONG,LAT,ELEV,v,'color','k','LineWidth',0.75);
[c1,h1]=m_contour(LONG,LAT,ELEV,v1,'color','k','LineWidth',1.5);
m_scatter(Longitude(a2),Latitude(a2),50,SST(a2),'fill');
cmap = cmocean('thermal');
colormap(cmap)
caxis([7 17])
cbar1 = colorbar('location','EastOutside','FontSize',20);%position and fontsize of our colour bar.
set(get(cbar1 ,'ylabel'),'String', 'Temperature (^oC)','Rotation',90,'FontSize',20);% font and name on our colourbar.
m_plot(LongitudeCTD,LatitudeCTD,'o','MarkerFaceColor','n','MarkerSize',8,...
    'MarkerEdgeColor','k','LineWidth',2)
m_plot(LON_SMD,LAT_SMD,'s','MarkerFaceColor','w','MarkerSize',15,...
    'MarkerEdgeColor','k','LineWidth',3)
m_plot(Longitude(end),Latitude(end),'p','Color','r','Markersize',18,...
        'MarkerEdgeColor','r','MarkerFaceColor','y','LineWidth',2)
m_gshhs('h','patch',[.5 .5 .5],'edgecolor','k');%Set up our coastlines and continents.
m_grid('box','fancy','tickdir','in','fontsize',20);%Set up our fancy box.
Titre='AR66-SST';
title(Titre,'fontsize',20)
hold off;
% print(fig1,'-dpng',char(Titre),'-r300');

%
fig3=figure(3);
set(gca,'FontSize',15,'FontName','Arial');hold on %Set font type and size.
m_proj('Equidistant Cylindrical','lon',[West  East],'lat',[South North]);%set up our projection and bourndaries.
hold on;
[c,h]=m_contour(LONG,LAT,ELEV,v,'color','k','LineWidth',0.75);
[c1,h1]=m_contour(LONG,LAT,ELEV,v1,'color','k','LineWidth',1.5);
m_scatter(Longitude(a2),Latitude(a2),50,SSS(a2),'fill');
cmap = cmocean('haline');
colormap(cmap)
caxis([31.5 36])
cbar1 = colorbar('location','EastOutside','FontSize',20);%position and fontsize of our colour bar.
set(get(cbar1 ,'ylabel'),'String', 'Salintiy','Rotation',90,'FontSize',20);% font and name on our colourbar.
m_plot(LongitudeCTD,LatitudeCTD,'o','MarkerFaceColor','n','MarkerSize',8,...
    'MarkerEdgeColor','k','LineWidth',2)
m_plot(LON_SMD,LAT_SMD,'s','MarkerFaceColor','w','MarkerSize',15,...
    'MarkerEdgeColor','k','LineWidth',3)
m_plot(Longitude(end),Latitude(end),'p','Color','r','Markersize',18,...
        'MarkerEdgeColor','r','MarkerFaceColor','y','LineWidth',2)
m_gshhs('h','patch',[.5 .5 .5],'edgecolor','k');%Set up our coastlines and continents.
m_grid('box','fancy','tickdir','in','fontsize',20);%Set up our fancy box.
Titre='AR66-SSS';
title(Titre,'fontsize',20)
hold off;
% print(fig1,'-dpng',char(Titre),'-r300');

fig4=figure(4);
set(gca,'FontSize',15,'FontName','Arial');hold on %Set font type and size.
m_proj('Equidistant Cylindrical','lon',[West  East],'lat',[South North]);%set up our projection and bourndaries.
hold on;
[c,h]=m_contour(LONG,LAT,ELEV,v,'color','k','LineWidth',0.75);
[c1,h1]=m_contour(LONG,LAT,ELEV,v1,'color','k','LineWidth',1.5);
m_scatter(Longitude(a1),Latitude(a1),50,FLUO(a1),'fill');
cmap = cmocean('algae');
colormap(cmap)
caxis([0 5])
% c=[0.1 0.2 0.5 1 2 4];
% caxis(log([c(1) c(length(c))]));
cbar1 = colorbar('location','EastOutside','FontSize',20);%position and fontsize of our colour bar.
% cbar1 = colorbar('location','EastOutside','FontSize',20,'YTick',log(c),'YTickLabel',c);%position and fontsize of our colour bar.
set(get(cbar1 ,'ylabel'),'String', 'Fluorescence (mV)','Rotation',90,'FontSize',20);% font and name on our colourbar.
% m_plot(LON_CTD,LAT_CTD,'o','MarkerFaceColor','n','MarkerSize',9,...
%     'MarkerEdgeColor','k','LineWidth',2)
% m_plot(LON_SMD,LAT_SMD,'s','MarkerFaceColor','w','MarkerSize',12,...
%     'MarkerEdgeColor','k','LineWidth',3)
m_gshhs('h','patch',[.5 .5 .5],'edgecolor','k');%Set up our coastlines and continents.
m_grid('box','fancy','tickdir','in','fontsize',20);%Set up our fancy box.
Titre='AR66-FLuo';
title(Titre,'fontsize',20)
hold off;
% print(fig1,'-dpng',char(Titre),'-r300');