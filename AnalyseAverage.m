function AntArray = AnalyseAverage(FileName, FrameName)

% Create UI figure for the application
FigUi = uifigure('Name', 'AntForceZoomAnalysis by Vincent MANSARD', 'Position', [340 60 350 800]);
FigUi.Icon = 'icon/ant.png';
FigUi.DeleteFcn = @ExitDetectAnt;

% Button to indicate process completion
EndBtn = uibutton(FigUi, ...
    'Position', [50 70 250 30], ...
    'Text', 'DONE', ...
    'ButtonPushedFcn', @(btn, event) CheckEnd(btn));

% Button to save results
DrawResultBtn = uibutton(FigUi, ...
    'Position', [50 145 250 30], ...
    'Text', 'Save Result', ...
    'ButtonPushedFcn', @SaveResult);

% Panel for plot settings
PlotPnl = uipanel(FigUi, 'Position', [10 320 330 280]);
ArrowScaleLbl = uilabel(PlotPnl, 'Position', [10 120 80 20], 'Text', 'Arrow Size', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
ArrowScaleBox = uieditfield(PlotPnl, "numeric", 'Position', [90 120 50 20], 'Value', 1, 'ValueChangedFcn', @UpdateCalculateForce);
ForceConversionLbl = uilabel(PlotPnl, 'Position', [150 120 120 20], 'Text', 'F conversion(uN/pix)', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
ForceConversionBox = uieditfield(PlotPnl, "numeric", 'Position', [275 120 50 20], 'Value', 5.5, 'ValueChangedFcn', @PlotResult);
ForceLegendLbl = uilabel(PlotPnl, 'Position', [10 90 160 20], 'Text', 'Force on the Legend (uN)', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
ForceLegendBox = uieditfield(PlotPnl, "numeric", 'Position', [170 90 50 20], 'Value', 1, 'ValueChangedFcn', @UpdateCalculateForce);

CutOffLbl = uilabel(PlotPnl, 'Position', [10 35 105 20], 'Text', 'Force CutOff (pix)', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
CutOffBox = uieditfield(PlotPnl, "numeric", 'Position', [130 35 30 20], 'Value', 0.2, 'ValueChangedFcn', @UpdateCalculateForce);
AvgForceLbl = uilabel(PlotPnl, 'Position', [160 35 105 20], 'Text', 'Avg Force', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
AvgForceBox = uieditfield(PlotPnl, "numeric", 'Position', [265 35 30 20], 'Value', 0, 'ValueChangedFcn', @UpdateCalculateForce);

% Panel for histogram settings
HistogrammePnl = uipanel(FigUi, 'Position', [10 200 330 100]);
ForceLimLbl = uilabel(HistogrammePnl, 'Position', [10 10 100 20], 'Text', 'Force Limit', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
ForceLimBox = uieditfield(HistogrammePnl, "numeric", 'Position', [110 10 50 20], 'Value', 0.2, 'ValueChangedFcn', @UpdateCalculateForce);
NBinLbl = uilabel(HistogrammePnl, 'Position', [10 40 100 20], 'Text', 'Number of bin', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
NBinBox = uieditfield(HistogrammePnl, "numeric", 'Position', [110 45 50 20], 'Value', 20, 'ValueChangedFcn', @UpdateCalculateForce);
HistogrammeLbl = uilabel(HistogrammePnl, 'Position', [10 70 310 20], 'Text', 'Data for histogramme', ...
    'BackgroundColor', 'none', 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');

% Information label
InfoLbl = uilabel(FigUi, ...
    'Position', [10 670 330 120], ...
    'Text', '', ...
    'BackgroundColor', [0.7 0.7 0.7], 'FontWeight', 'Bold', 'HorizontalAlignment', 'Center');
InfoLbl.Text = sprintf('Save average force for each leg \n (option) you can choose a to average the force and \napply a cut-off before average \n(Histogramme of force direction)\n You choose the number of bins \nand you can exclude the small force \n which are less significant');

% Main figures for results
Fig1 = figure('Position', [700 60 600 600]);
Fig1.DeleteFcn = @ExitDetectAnt;

Fig2 = figure('Position', [1300 60 300 900]);
Fig2.DeleteFcn = @ExitDetectAnt;

% Variables initialization
TotalLegMvt = [];
AntArray = [];
ForceU = [];
ForceV = [];
ForceAmplitude = [];
ForceUAvg = [];
ForceVAvg = [];
ForceAmplitudeAvg = [];
Torque = [];
TorqueAvg = NaN;
Nimage = NaN;

% Initial actions
ReadData();
CalculateForce();
PlotResult();
PlotHistogramme();

    function CalculateForce()
        % Calculate forces and torques
        Nimage = size(AntArray, 1);
        ForceU = zeros(Nimage, 6);
        ForceV = zeros(Nimage, 6);
        ForceAmplitude = zeros(Nimage, 6);
        Torque = zeros(Nimage, 1);

        AvgForceBox.Value = max(round(AvgForceBox.Value), 0);
        ForceX = zeros(Nimage, 6);
        ForceY = ForceX;
        for jj = 1:6
            ForceX(:, jj) = TotalLegMvt(jj).Disp(:, 1);
            ForceY(:, jj) = TotalLegMvt(jj).Disp(:, 2);
            if (AvgForceBox.Value > 0)
                for ii = 1:Nimage
                    ForceX(ii, jj) = mean(TotalLegMvt(jj).Disp(max(ii - AvgForceBox.Value, 1):min(ii + AvgForceBox.Value, Nimage), 1));
                    ForceY(ii, jj) = mean(TotalLegMvt(jj).Disp(max(ii - AvgForceBox.Value, 1):min(ii + AvgForceBox.Value, Nimage), 2));
                end
            end
        end

        for ii = 1:Nimage
            u(1, 1) = AntArray(ii, 1, 1) - AntArray(ii, 2, 1);
            u(2, 1) = AntArray(ii, 1, 2) - AntArray(ii, 2, 2);
            u = u ./ norm(u);
            v = [u(2); -u(1)];

            for jj = 1:6
                F = [ForceX(ii, jj) ForceY(ii, jj)];
                if (norm(F) >= CutOffBox.Value)
                    ForceU(ii, jj) = F * u;
                    ForceV(ii, jj) = F * v;
                    ForceAmplitude(ii, jj) = norm(F);
                else
                    ForceU(ii, jj) = 0;
                    ForceV(ii, jj) = 0;
                    ForceAmplitude(ii, jj) = 0;
                end
            end
            % Calculate torque
            Xm = (AntArray(ii, 1, 1) + AntArray(ii, 2, 1)) / 2;
            Ym = (AntArray(ii, 1, 2) + AntArray(ii, 2, 2)) / 2;
            for jj = 1:6
                dX = Xm - AntArray(ii, 2 + jj, 1);
                dY = Ym - AntArray(ii, 2 + jj, 2);
                t = ForceX(ii, jj) * dY - ForceY(ii, jj) * dX;
                Torque(ii) = Torque(ii) + t;
            end
        end

        % Calculate average forces and torques
        ForceUAvg = mean(ForceU, 1);
        ForceVAvg = mean(ForceV, 1);
        ForceAmplitudeAvg = mean(ForceAmplitude, 1);
        TorqueAvg = mean(Torque, 1);
    end

    function PlotResult()
        % Plot the body and leg forces
        XYBody = [0 1; 0 0];
        XYLeg = [0.3 1.05; 0.35 0.55; 0.3 -0.1; -0.3 1.05; -0.35 0.55; -0.3 -0.1];
        figure(Fig1)

        PlotBody = plot([0], [0], 'k');
        PlotLeg = ploth([0], [0], 'k');
        PlotAnt(XYBody, XYLeg, PlotBody, PlotLeg);
        hold on
        quiver(XYLeg(:, 1), XYLeg(:, 2), -ForceUAvg' * ArrowScaleBox.Value, ForceVAvg' * ArrowScaleBox.Value, 'r', 'Autoscale', 'off');
        ForceLegend = ForceLegendBox.Value; % uN
        quiver(0.8, -0.9, ForceLegend / ForceConversionBox.Value * ArrowScaleBox.Value, 0, 'b', 'Autoscale', 'off')
        text(0.8 + ForceLegend / ForceConversionBox.Value * ArrowScaleBox.Value / 2, -0.8, sprintf('%0.1f\\muN', ForceLegend), 'HorizontalAlignment', 'Center');
        hold off
        Axes = gca;
        Axes.XLim = [-1.5 1.5];
        Axes.YLim = [-1 2];
        Axes.XTick = {};
        Axes.YTick = {};
        daspect([1 1 1]);
    end

    function PlotHistogramme()
        % Plot the histogram of force directions
        [ListAngle, HistoAngle] = CalculateHistogramme();
        figure(Fig2);
        Title = {'Head', '', ''};
        for ii = 1:3
            Histo1 = HistoAngle(ii, :) + HistoAngle(ii + 3, :);
            Histo2 = HistoAngle(ii, :);
            NData = sum(Histo1);
            Histo1 = Histo1 / NData ./ diff(ListAngle);
            Histo2 = Histo2 / NData ./ diff(ListAngle);
            subplot(3, 1, ii);
            polarhistogram('BinEdges', ListAngle, 'BinCounts', Histo1, 'FaceAlpha', 1)
            hold on
            polarhistogram('BinEdges', ListAngle, 'BinCounts', Histo2, 'FaceAlpha', 1)
            hold off
            Axe(ii) = gca;
            title(Title{ii});
        end
        RLimMax = max([Axe(:).RLim]);
        Legend = legend({'left', 'right'}, 'location', 'southeastoutside');

        for ii = 1:3
            Axe(ii).ThetaTickLabel = {''}';
            Axe(ii).RLim = [0 RLimMax];
            Axe(ii).RTickLabel = '';
        end
        Pos = Axe(2).Position;
        Pos2 = Axe(3).Position;
        Axe(3).Position = [Pos2(1) Pos2(2) Pos(3) Pos(4)];
        Pos = Legend.Position;
        Legend.Position = [0.5 0.02 Pos(3) Pos(4)];
    end

    function [ListAngle, HistoAngle] = CalculateHistogramme()
        % Calculate the histogram of force directions
        NBin = round(NBinBox.Value / 2);
        FLim = ForceLimBox.Value;
        ListAngle = 0:pi / (NBin):pi;
        ListAngle = unique([-ListAngle ListAngle]);

        HistoAngle = zeros(6, length(ListAngle) - 1);
        for ii = 1:Nimage
            for jj = 1:6
                if (ForceAmplitude(ii, jj) >= FLim)
                    Angle = angle(1i * ForceU(ii, jj) + ForceV(ii, jj));
                    FI = find(Angle > ListAngle);
                    HistoAngle(jj, FI(end)) = HistoAngle(jj, FI(end)) + 1;
                end
            end
        end
    end

    function UpdateCalculateForce(varargin)
        % Update calculations and plots
        CalculateForce();
        PlotResult();
        PlotHistogramme();
    end

    function SaveResult(varargin)
        % Save results to file
        res.param.CutOff = CutOffBox.Value;
        res.param.AvgForce = AvgForceBox.Value;
        res.param.Nimage = Nimage;
        res.ForceU = ForceU;
        res.ForceV = ForceV;
        res.ForceAmplitude = ForceAmplitude;
        res.Torque = Torque;
        res.avg.ForceU = ForceUAvg;
        res.avg.ForceV = ForceVAvg;
        res.avg.ForceAmplitude = ForceAmplitudeAvg;
        res.avg.Torque = TorqueAvg;

        [~, ~] = mkdir(fullfile(FileName, 'step3'));
        vm_save_image(fullfile(FileName, 'step3', ['ForceAvg_' FrameName]), [1 1] * 10, Fig1, 0);
        vm_save_image(fullfile(FileName, 'step3', ['Histogramme_Force_Direction' FrameName]), [0.5 1] * 10, Fig2, 0);
        save(fullfile(FileName, 'step3', ['ForceAvg_' FrameName '.mat']), 'res')
    end

    function ReadData()
        % Load data from file
        FileName2 = fullfile(FileName, 'step2', ['TotalMvt_' FrameName '.mat']);
        load(FileName2, 'TotalLegMvt');

        FileName2 = fullfile(FileName, 'step2', ['ant_' FrameName '.mat']);
        load(FileName2, 'AntArray');
    end

    function CheckEnd(varargin)
        % End the process
        ExitDetectAnt();
    end

    function ExitDetectAnt(varargin)
        % Close all figures and exit
        delete(Fig1);
        delete(Fig2);
        delete(FigUi);
    end
end
