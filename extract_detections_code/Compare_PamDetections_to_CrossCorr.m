

%% WHISTLES
clear, close all

% LOAD Annotated data
load('/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Ground_truth_fromJenn/Lasker_AC109/Lasker_AC109_Extracted_AnnotatedWhistles.mat');

% LOAD Cross-correlogram data
load('/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Code/Tracking_Towed_Array/LocalizationTest/LaskerAC109_Results/Lasker_AC109_Results.mat','scalar_whistles')
load('/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Code/Tracking_Towed_Array/LocalizationTest/LaskerAC109_Raw_CrossCorrelogram/Lasker_AC109_whistles_rawCrossCorrelogram_ALL.mat',...
    'Rxy_envelope_ALL','lags','t_serialdate')
Rxy_envelope_scaled=Rxy_envelope_ALL.*scalar_whistles;


% PLOT All tracks and selected:
figure,
% ALL TDOAS
subplot(211)
imagesc(t_serialdate,lags,Rxy_envelope_scaled);
datetick('x','keeplimits');
colormap(flipud(gray(256)));
ylim([-parameters.d/parameters.c,parameters.d/parameters.c]);
xlabel('Local Time (HH:MM:SS)'); ylabel('TDOA (s)');
caxis([0,10]);
colorbar;

hold on, plot(datenum(All_data_w.time_UTC),-1.*All_data_w.tdoa,'m.')
legend('All Pamguard extracted TDOAs')
xlim([t_serialdate(1),t_serialdate(end)])
title('All TDOAs (whistles) - Pamguard');
set(gca,'FontSize',14);

% ANNOTATED TDOAS
subplot(212)
imagesc(t_serialdate,lags,Rxy_envelope_scaled);
datetick('x','keeplimits');
colormap(flipud(gray(256)));
ylim([-parameters.d/parameters.c,parameters.d/parameters.c]);
xlabel('Local Time (HH:MM:SS)'); ylabel('TDOA (s)');
caxis([0,10]);
colorbar;

colors = 'rgbcmyk';
hold on, gscatter(datenum(Annotated_data_w.time_UTC),-1.*Annotated_data_w.tdoa, Annotated_data_w.annotatedID,colors,'ods<p>',6);
xlim([t_serialdate(1),t_serialdate(end)])
title('Annotated TDOAs (whistles)- Pamguard');
set(gca,'FontSize',14);

%% CLICKS
clear, close all

% LOAD Annotated data
load('/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Ground_truth_fromJenn/Lasker_AC109/Lasker_AC109_Extracted_AnnotatedClicks.mat');

% LOAD Cross-correlogram data
load('/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Code/Tracking_Towed_Array/LocalizationTest/LaskerAC109_Results/Lasker_AC109_Results.mat','scalar_clicks')
load('/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Code/Tracking_Towed_Array/LocalizationTest/LaskerAC109_Raw_CrossCorrelogram/Lasker_AC109_clicks_rawCrossCorrelogram_ALL.mat',...
    'Rxy_envelope_ALL','lags','t_serialdate')
Rxy_envelope_scaled=Rxy_envelope_ALL.*scalar_clicks;


% PLOT All tracks and selected:
figure,
% ALL TDOAS
subplot(211)
imagesc(t_serialdate,lags,Rxy_envelope_scaled);
datetick('x','keeplimits');
colormap(flipud(gray(256)));
ylim([-parameters.d/parameters.c,parameters.d/parameters.c]);
xlabel('Local Time (HH:MM:SS)'); ylabel('TDOA (s)');
caxis([0,10]);
colorbar;

hold on, plot(datenum(All_data_c.time_UTC),-1.*All_data_c.tdoa,'m.')
legend('All Pamguard extracted TDOAs')
xlim([t_serialdate(1),t_serialdate(end)])
title('All TDOAs (clicks) - Pamguard');
set(gca,'FontSize',14);

% ANNOTATED TDOAS
subplot(212)
imagesc(t_serialdate,lags,Rxy_envelope_scaled);
datetick('x','keeplimits');
colormap(flipud(gray(256)));
ylim([-parameters.d/parameters.c,parameters.d/parameters.c]);
xlabel('Local Time (HH:MM:SS)'); ylabel('TDOA (s)');
caxis([0,10]);
colorbar;

colors = 'rgbcmyk';
hold on, gscatter(datenum(Annotated_data_c.time_UTC),-1.*Annotated_data_c.tdoa, Annotated_data_c.annotatedID,colors,'ods<p>',6);
xlim([t_serialdate(1),t_serialdate(end)])
title('Annotated TDOAs (clicks)- Pamguard');
set(gca,'FontSize',14);