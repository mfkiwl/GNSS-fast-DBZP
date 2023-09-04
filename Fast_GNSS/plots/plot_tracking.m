%%
 % Project Title: GNSS-R SDR
 % Author       : John Bagshaw
 % Contact      : jotshaw@yorku.ca
 % Supervisor   : Prof.Sunil Bisnath
 % Institution  : York University, Canada.
%%

function plot_tracking(channelList, trackResults, settings)
%This function plots the tracking results for the given channel list.
%
%plotTracking(channelList, trackResults, settings)
%
%   Inputs:
%       channelList     - list of channels to be plotted.
%       trackResults    - tracking results from the tracking function.
%       settings        - receiver settings.


% Protection - if the list contains incorrect channel numbers
channelList = intersect(channelList, 1:settings.numberOfChannels);

%=== For all listed channels ==============================================
for channelNr = channelList

%% Select (or create) and clear the figure ================================
    % The number 200 is added just for more convenient handling of the open
    % figure windows, when many figures are closed and reopened.
    % Figures drawn or opened by the user, will not be "overwritten" by
    % this function.

    figure(channelNr +200);
    clf(channelNr +200);
    set(channelNr +200, 'Name', ['Channel ', num2str(channelNr), ...
                                 ' (PRN ', ...
                                 num2str(trackResults(channelNr).PRN), ...
                                 ') results']);

%% Draw axes ==============================================================
        % Row 1
        handles(1, 1) = subplot(3, 3, 1);
        handles(1, 2) = subplot(3, 3, [2 3]);
        % Row 2
        handles(2, 1) = subplot(3, 3, 4);
        handles(2, 2) = subplot(3, 3, [5 6]);
        % Row 3
        handles(3, 1) = subplot(3, 3, 7);
        handles(3, 2) = subplot(3, 3, 8);
        handles(3, 3) = subplot(3, 3, 9);

%% Plot all figures =======================================================

        timeAxisInSeconds = (1:settings.msToProcess)/1000;

        %----- Discrete-Time Scatter Plot ---------------------------------
        plot(handles(1, 1), trackResults(channelNr).I_P,...
                            trackResults(channelNr).Q_P, ...
                            '.');

        grid  (handles(1, 1));
        axis  (handles(1, 1), 'equal');
        title (handles(1, 1), 'Discrete-Time Scatter Plot');
        xlabel(handles(1, 1), 'I prompt');
        ylabel(handles(1, 1), 'Q prompt');

        %----- Nav bits ---------------------------------------------------
        plot  (handles(1, 2), timeAxisInSeconds, ...
                              trackResults(channelNr).I_P);

        grid  (handles(1, 2));
        title (handles(1, 2), 'Bits of the navigation message');
        xlabel(handles(1, 2), 'Time (s)');
        axis  (handles(1, 2), 'tight');

        %----- PLL discriminator unfiltered--------------------------------
        plot  (handles(2, 1), timeAxisInSeconds, ...
                              trackResults(channelNr).pllDiscr, 'r');      

        grid  (handles(2, 1));
        axis  (handles(2, 1), 'tight');
        xlabel(handles(2, 1), 'Time (s)');
        ylabel(handles(2, 1), 'Amplitude');
        title (handles(2, 1), 'Raw PLL discriminator');

        %----- Correlation ------------------------------------------------
        plot(handles(2, 2), timeAxisInSeconds, ...
                            [sqrt(trackResults(channelNr).I_E.^2 + ...
                                  trackResults(channelNr).Q_E.^2)', ...
                             sqrt(trackResults(channelNr).I_P.^2 + ...
                                  trackResults(channelNr).Q_P.^2)', ...
                             sqrt(trackResults(channelNr).I_L.^2 + ...
                                  trackResults(channelNr).Q_L.^2)'], ...
                            '-*');

        grid  (handles(2, 2));
        title (handles(2, 2), 'Correlation results');
        xlabel(handles(2, 2), 'Time (s)');
        axis  (handles(2, 2), 'tight');
        
        hLegend = legend(handles(2, 2), '$\sqrt{I_{E}^2 + Q_{E}^2}$', ...
                                        '$\sqrt{I_{P}^2 + Q_{P}^2}$', ...
                                        '$\sqrt{I_{L}^2 + Q_{L}^2}$');
                          
        %set interpreter from tex to latex. This will draw \sqrt correctly
        set(hLegend, 'Interpreter', 'Latex');

        %----- PLL discriminator filtered----------------------------------
        plot  (handles(3, 1), timeAxisInSeconds, ...
                              trackResults(channelNr).pllDiscrFilt, 'b');      

        grid  (handles(3, 1));
        axis  (handles(3, 1), 'tight');
        xlabel(handles(3, 1), 'Time (s)');
        ylabel(handles(3, 1), 'Amplitude');
        title (handles(3, 1), 'Filtered PLL discriminator');

        %----- DLL discriminator unfiltered--------------------------------
        plot  (handles(3, 2), timeAxisInSeconds, ...
                              trackResults(channelNr).dllDiscr, 'r');      

        grid  (handles(3, 2));
        axis  (handles(3, 2), 'tight');
        xlabel(handles(3, 2), 'Time (s)');
        ylabel(handles(3, 2), 'Amplitude');
        title (handles(3, 2), 'Raw DLL discriminator');

        %----- DLL discriminator filtered----------------------------------
        plot  (handles(3, 3), timeAxisInSeconds, ...
                              trackResults(channelNr).dllDiscrFilt, 'b');      

        grid  (handles(3, 3));
        axis  (handles(3, 3), 'tight');
        xlabel(handles(3, 3), 'Time (s)');
        ylabel(handles(3, 3), 'Amplitude');
        title (handles(3, 3), 'Filtered DLL discriminator');

end % for channelNr = channelList