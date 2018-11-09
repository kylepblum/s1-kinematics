%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script makes plots from results given by analyzeTRT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% Main line figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure 1 - Task and classic analysis methods
    % 1a - Monkey using manipulandum (in illustrator)

    % 1b - example movements in two workspaces (with neural firing dots?)
    % First, get example trials
    [~,td_pm_ex] = getTDidx(trial_data,'spaceNum',1,'result','R','rand',1);
    [~,td_dl_ex] = getTDidx(trial_data,'spaceNum',2,'result','R','rand',1);
    % trim to just go from target start to end
    td_ex = trimTD([td_pm_ex td_dl_ex],{'idx_ctHoldTime',0},{'idx_endTime',0});
    % plot the example trials
    figure('defaultaxesfontsize',18)
    plotTRTTrials(td_ex);
    % plot neural firing?
    unit_idx = 1;
    plotSpikesOnHandle(td_ex,struct('unit_idx',unit_idx,'spikespec','b.','spikesize',10));
    % plot of same muscle movement given different Jacobians?

    % Switch to classical PDs?
    % 1c - example directional rasters and tuning curves?

%% Figure 2 - Analysis block diagrams
    % 2a - Block diagram of three different models

    % 2b - Breaking up the data into training and testing sets

    % 2c - Example neural predictions for each model

%% Set up plotting variables
    datadir = '/home/raeed/Wiki/Projects/limblab/multiworkspace/data/Results/Encoding';
    % filename = {'Han_20171101_TRT_encodingResults_run20180809.mat','Chips_20170915_TRT_encodingResults_run20180809.mat','Lando_20170802_encodingResults_run20180809.mat'};
    filename = {'Han_20171101_TRT_encodingResults_allModels_run20180912.mat','Chips_20170915_TRT_encodingResults_allModels_run20180912.mat','Lando_20170802_RWTW_encodingResults_allModels_run20180912.mat'};
    % filename = {'Han_20171101_TRT_encodingResults_markersVopensim_run20180904.mat','Chips_20170915_TRT_encodingResults_markersVopensim_run20180904.mat','Lando_20170802_RWTW_encodingResults_markersVopensim_run20180904.mat'};
    % filename = {'Han_20171101_TRT_encodingResults_9MuscPCs_run20180924.mat','Chips_20170915_TRT_encodingResults_9MuscPCs_run20180924.mat','Lando_20170802_RWTW_encodingResults_9MuscPCs_run20180924.mat'};
    % filename = {'Butter_TRT_20180522_GoodMotionTracking_encodingResults_5MuscPCs_run20181019.mat'};
    % filename = {'Butter_20180522_TRT_encodingResults_run20180906.mat'};
    num_monks = length(filename);
    err = cell(num_monks,1);
    hyp = cell(num_monks,1);
    p_val = cell(num_monks,1);

    % colors for pm, dl conditions
    cond_colors = [0.6,0.5,0.7;...
        1,0,0];

    monkey_colors = [186, 20, 130;...
        32, 140, 142;...
        21, 119, 132]/255;

%% Loop over all monkeys for encoder figures and errors
    models_to_plot = {'ext','ego','handelbow','musc'};
    % model_aliases = {'joint','musc','markers','opensim_markers'};
    % model_aliases = {'opensim_ext','opensim_ego','musc','opensim_markers'};
    % model_aliases = {'musc','handelbow'};
    % model_aliases = {'musc','opensim_markers'};
    % num_model_plots = length(models_to_plot);
    % model_titles = getModelTitles(models_to_plot);
    % model_colors = getModelColors(models_to_plot);

    for monkeynum = 1:num_monks
        %% load data
            clear encoderResults
            load(fullfile(datadir,filename{monkeynum}))
    
        %% Plot PD shifts
            % % get shifts from weights
            % shift_tables = calculatePDShiftTables(encoderResults,[strcat('glm_',model_aliases,'_model') {'CN_FR'}]);
        
            % mean_shifts = cell(num_model_plots+1,1);
            % for modelnum = 1:num_model_plots+1
            %     mean_shifts{modelnum} = neuronAverage(shift_tables{modelnum},contains(shift_tables{modelnum}.Properties.VariableDescriptions,'meta'));
            % end

            % figure('defaultaxesfontsize',18)
            % for modelnum = 1:num_model_plots
            %     [~,real_shifts] = getNTidx(shift_tables{end},'signalID',encoderResults.tunedNeurons);
            %     [~,model_shifts] = getNTidx(shift_tables{modelnum},'signalID',encoderResults.tunedNeurons);
        
            %     subplot(1,num_model_plots,modelnum)
            %     plot([-180 180],[0 0],'-k','linewidth',2)
            %     hold on
            %     plot([0 0],[-180 180],'-k','linewidth',2)
            %     plot([-180 180],[-180 180],'--k','linewidth',2)
            %     axis equal
            %     set(gca,'box','off','tickdir','out','xtick',[-180 180],'ytick',[-180 180],'xlim',[-180 180],'ylim',[-180 180])
            %     scatter(180/pi*real_shifts.velPD,180/pi*model_shifts.velPD,50,model_colors(modelnum,:),'filled')
        
            %     % labels
            %     xlabel 'Actual PD Shift'
            %     ylabel 'Modeled PD Shift'
            %     title({sprintf('%s model PD shift vs Actual PD shift',model_titles{modelnum});filename{monkeynum}},'interpreter','none')
            % end
        
        %% Make histogram plots of PD changes
            % figure('defaultaxesfontsize',18)
            % subplot(num_model_plots+1,1,1)
            % h = histogram(gca,mean_shifts{end}.velPD*180/pi,'BinWidth',10,'DisplayStyle','stair');
            % set(h,'edgecolor','k')
            % set(gca,'box','off','tickdir','out','xlim',[-180 180],'xtick',[-180 0 180],'ylim',[0 20],'ytick',[0 20])
            % for modelnum = 1:num_model_plots
            %     subplot(num_model_plots+1,1,modelnum+1)
            %     h = histogram(gca,mean_shifts{modelnum}.velPD*180/pi,'BinWidth',10,'DisplayStyle','stair');
            %     set(h,'edgecolor',model_colors(modelnum,:))
            %     set(gca,'box','off','tickdir','out','xlim',[-180 180],'xtick',[-180 0 180],'ylim',[0 20],'ytick',[0 20])
            % end
            % xlabel 'Change in Preferred Direction'
            % title(filename(monkeynum),'interpreter','none')
        
        %% Calculate mean error on shifts
            % err{monkeynum} = calculateEncoderPDShiftErr(encoderResults);
            % % plot errors
            % figure('defaultaxesfontsize',18)
            % for modelnum = 1:num_model_plots
            %     scatter(err{:,modelnum},repmat(modelnum/10,size(err,1),1),50,model_colors(modelnum,:),'filled')
            %     hold on
            %     plot(mean(err{:,modelnum}),modelnum/10,'k.','linewidth',3,'markersize',40)
            % end
            % set(gca,'tickdir','out','box','off','ytick',(1:(num_model_plots))/10,'yticklabel',model_titles,'xtick',[0 1])
            % axis equal
            % axis ij
            % xlim([0 1])
            % ylim([0 num_model_plots+1/10])
            % xlabel('Cosine error of model')

            % modelcompare = {'ext','ego';...
            %     'ext','musc';...
            %     'ext','handelbow';...
            %     'ego','musc';...
            %     'ego','handelbow';
            %     'musc','handelbow'};
            % tails = {'both';'right';'right';'right';'right';'right'};
            % [hyp{monkeynum},p_val{monkeynum}] = stattestPDShiftErr(err{monkeynum},modelcompare,tails,encoderResults.params.num_repeats,encoderResults.params.num_folds);
        
        %% Plot pR2s against each other
            % % setup
            % modelcompare = nchoosek(model_aliases,2);
            % figure('defaultaxesfontsize',18)
            % for i = 1:6
            %     subplot(2,3,i)
            %     plotEncoderPR2(encoderResults,modelcompare{i,1},modelcompare{i,2})
            % end
            % subplot(2,3,2)
            % title(filename{monkeynum},'interpreter','none') % centered title

        %% Tuning curve covariances
            true_tuning_idx = contains(encoderResults.params.model_names,'S1');
            % models_to_plot = {'ext','ego','musc','markers'};
            tuning_corr = zeros(height(encoderResults.tuning_curves{1,1}),length(models_to_plot));

            % start with just plotting out scatter plot of predicted tuning curves
            figure('defaultaxesfontsize',18)
            plot([0 0],[0 60],'-k','linewidth',3)
            hold on
            plot([0 60],[0 0],'-k','linewidth',3)
            plot([0 60],[0 60],'--k','linewidth',2)
            set(gca,'box','off','tickdir','out')
            axis equal
            for neuron_idx = 1:height(encoderResults.tuning_curves{1,1})
                num_bins = encoderResults.params.num_tuning_bins;
                tuning_curve_mat = zeros(num_bins*2,length(models_to_plot)+1);
                for spacenum = 1:2
                    tuning_curve_mat(num_bins*(spacenum-1)+(1:num_bins),end) = encoderResults.tuning_curves{spacenum,true_tuning_idx}(neuron_idx,:).velCurve';
                    for modelnum = 1:length(models_to_plot)
                        tuning_idx = strcmp(encoderResults.params.model_aliases,models_to_plot{modelnum});
                        tuning_curve_mat(num_bins*(spacenum-1)+(1:num_bins),modelnum) = encoderResults.tuning_curves{spacenum,tuning_idx}(neuron_idx,:).velCurve';
                        scatter(tuning_curve_mat(:,end),tuning_curve_mat(:,modelnum),[],getModelColors(models_to_plot{modelnum}),'filled')
                    end
                end
                covar_mat = nancov(tuning_curve_mat);
                tuning_corr(neuron_idx,:) = covar_mat(end,1:end-1)/covar_mat(end,end);
                % tuning_corr(neuron_idx,:) = covar_mat(end,1:end-1);
            end
            % quick plot
            figure('defaultaxesfontsize',18)
            plot(tuning_corr','-ok','linewidth',2)
            set(gca,'box','off','tickdir','out','xlim',[0 size(tuning_corr,2)+1])
    end
    
%% Histogram of PD shift for all monkeys
    figure('defaultaxesfontsize',18)
    for monkeynum = 1:num_monks
        % load data
        load(fullfile(datadir,filename{monkeynum}))

        shift_tables = calculatePDShiftTables(encoderResults);
        mean_shifts = cell(num_models,1);
        for modelnum = 1:num_models
            mean_shifts{modelnum} = neuronAverage(shift_tables{modelnum},contains(shift_tables{modelnum}.Properties.VariableDescriptions,'meta'));
        end

        subplot(num_monks,1,monkeynum)
        h = histogram(gca,mean_shifts{end}.velPD*180/pi,'BinWidth',10,'DisplayStyle','stair');
        set(h,'edgecolor','k')
        set(gca,'box','off','tickdir','out','xlim',[-180 180],'xtick',[-180 0 180],'ylim',[0 20],'ytick',[0 20])
        title(filename(monkeynum),'interpreter','none')
    end
    xlabel 'Change in Preferred Direction'

%% PD shifts over all monkeys
    models_to_plot = {'ext','ego','handelbow','musc'};
    num_model_plots = length(models_to_plot);
    model_titles = getModelTitles(models_to_plot);
    model_colors = getModelColors(models_to_plot);
    monkey_shifts = cell(num_monks,num_model_plots);
    num_monks = 2;
    for monkeynum = 1:num_monks
        % load data
        load(fullfile(datadir,filename{monkeynum}))

        shift_tables = calculatePDShiftTables(encoderResults,[strcat('glm_',models_to_plot,'_model') 'S1_FR']);
        mean_shifts = cell(num_model_plots,1);
        for modelnum = 1:num_model_plots+1
            mean_shifts{modelnum} = neuronAverage(shift_tables{modelnum},contains(shift_tables{modelnum}.Properties.VariableDescriptions,'meta'));
            [~,monkey_shifts{monkeynum,modelnum}] = getNTidx(mean_shifts{modelnum},'signalID',encoderResults.tunedNeurons);
        end
    end

    allMonkeyShifts_real = vertcat(monkey_shifts{:,end});

    hists = figure('defaultaxesfontsize',18);
    subplot(1,num_model_plots+1,1)
    h = histogram(gca,allMonkeyShifts_real.velPD*180/pi,'BinWidth',10,'DisplayStyle','stair');
    set(h,'edgecolor','k')
    set(gca,'box','off','tickdir','out','xlim',[-180 180],'xtick',[-180 0 180],'ylim',[0 30],'ytick',[0 15 30],'view',[-90 90])

    scatters = figure('defaultaxesfontsize',18);
    for modelnum = 1:num_model_plots
        allMonkeyShifts_model = vertcat(monkey_shifts{:,modelnum});

        figure(scatters)
        subplot(1,num_model_plots,modelnum)
        % hsh = scatterhist(180/pi*allMonkeyShifts_model.velPD,180/pi*allMonkeyShifts_real.velPD,...
        %     'markersize',50,'group',allMonkeyShifts_real.monkey,'location','NorthWest',...
        %     'direction','out','plotgroup','off','color',monkey_colors,'marker','...',...
        %     'nbins',[15 15],'style','stairs');
        % hsh(3).Children.EdgeColor = [0 0 0];
        % hsh(2).Children.EdgeColor = model_colors(modelnum,:);
        scatter(180/pi*allMonkeyShifts_model.velPD,180/pi*allMonkeyShifts_real.velPD,50,model_colors(modelnum,:),'filled')
        hold on
        plot([-180 180],[0 0],'-k','linewidth',2)
        plot([0 0],[-180 180],'-k','linewidth',2)
        plot([-180 180],[-180 180],'--k','linewidth',2)
        axis equal
        set(gca,'box','off','tickdir','out','xtick',[-180 180],'ytick',[-180 180],'xlim',[-180 180],'ylim',[-180 180])
        % labels
        xlabel 'Modeled PD Shift'
        ylabel 'Actual PD Shift'
        title(sprintf('%s model PD shift vs Actual PD shift',model_titles{modelnum}),'interpreter','none')

        figure(hists)
        subplot(1,num_model_plots+1,modelnum+1)
        h = histogram(gca,allMonkeyShifts_model.velPD*180/pi,'BinWidth',10,'DisplayStyle','stair');
        set(h,'edgecolor',model_colors(modelnum,:))
        set(gca,'box','off','tickdir','out','xlim',[-180 180],'xtick',[-180 0 180],'ylim',[0 30],'ytick',[0 15 30],'view',[-90 90])
    end

%% Plot PD shift error on all monkeys
    num_monks = 3;
    correction = 1/100 + 1/4;
    % models_to_plot = {'ext','ego','joint','musc','handelbow'};
    models_to_plot = encoderResults.params.model_aliases;
    model_colors = getModelColors(models_to_plot);
    % models_to_plot = model_aliases;
    % x coordinate of individual monkey bars
    monk_x = (2:3:((num_monks-1)*3+2))/10;
    % template for within monkey bars separation
    template_x = linspace(-1,1,length(models_to_plot))/10;
    model_spacing = mode(diff(template_x));

    % make plot
    figure('defaultaxesfontsize',18)
    for monkeynum = 1:num_monks
        % load data
        load(fullfile(datadir,filename{monkeynum}))
        err{monkeynum} = calculateEncoderPDShiftErr(encoderResults,struct('model_aliases',{models_to_plot}));

        for modelnum = 1:length(models_to_plot)
            mean_err = mean(err{monkeynum}.(models_to_plot{modelnum}));
            var_err = var(err{monkeynum}.(models_to_plot{modelnum}));
            std_err_err = sqrt(correction*var_err);

            xval = monk_x(monkeynum) + template_x(modelnum);
            bar(xval,mean_err,model_spacing,'facecolor',model_colors(modelnum,:),'edgecolor','none')
            hold on
            plot([xval xval],[mean_err-std_err_err mean_err+std_err_err],'k','linewidth',3)
        end
        % xval = repmat(monk_x(monkeynum)+template_x,length(err{monkeynum}{:,:}),1);
        % scatter(xval(:),err{monkeynum}{:,:}(:),[],'k','filled')
        % plot(xval',err{monkeynum}{:,:}','-k','linewidth',1)
    end
    set(gca,'tickdir','out','box','off','xtick',monk_x,...
        'xticklabel',filename,'ytick',[0 0.5],'ticklabelinterpreter','none')
    % axis equal
    ylim([0 0.7])
    % xlim([0 1])
    ylabel('Error of model')

%% Plot pR2 of all monkeys
    num_monks = 3;
    % correction = 1/100 + 1/4;
    % models_to_plot = {'ego','ext','musc','markers'};
    models_to_plot = model_aliases;
    % x coordinate of individual monkey bars
    monk_x = (2:3:((num_monks-1)*3+2))/10;
    % template for within monkey bars separation
    template_x = linspace(-0.5,0.5,length(models_to_plot))/10;
    model_spacing = mode(diff(template_x));

    % make plot
    figure('defaultaxesfontsize',18)
    for monkeynum = 1:num_monks
        % load data
        load(fullfile(datadir,filename{monkeynum}))

        avgEval = neuronAverage(encoderResults.crossEval,contains(encoderResults.crossEval.Properties.VariableDescriptions,'meta'));

        % model_idx = find(contains(err{monkeynum}.Properties.VariableNames,models_to_plot));
        % mean_err = mean(err{monkeynum}{:,model_idx});
        % var_err = var(err{monkeynum}{:,model_idx});
        % std_err_err = sqrt(correction*var_err);

        avg_pR2 = zeros(height(avgEval),length(models_to_plot));
        for modelnum = 1:length(models_to_plot)
            xval = monk_x(monkeynum) + template_x(modelnum);
            mean_pR2 = mean(avgEval.(sprintf('glm_%s_model_eval',models_to_plot{modelnum})));
            avg_pR2(:,modelnum) = avgEval.(sprintf('glm_%s_model_eval',models_to_plot{modelnum}));
            bar(xval,mean_pR2,model_spacing,'facecolor',getModelColors(models_to_plot{modelnum}),'edgecolor','none')
            hold on
            % plot([xval xval],[mean_err(modelnum)-std_err_err(modelnum) mean_err(modelnum)+std_err_err(modelnum)],'k','linewidth',3)
        end
        xval = repmat(monk_x(monkeynum)+template_x,length(avg_pR2),1);
        scatter(xval(:),avg_pR2(:),[],'k','filled')
        plot(xval',avg_pR2','-k','linewidth',1)
    end
    set(gca,'tickdir','out','box','off','xtick',monk_x,...
        'xticklabel',filename,'ytick',[0 0.25 0.5],'ticklabelinterpreter','none')
    % axis equal
    ylim([0 0.6])
    % xlim([0 1])
    ylabel('Model pseudo-R^2')

%% Tuning curve shape comparison
    num_monks = 3;
    correction = 1/100 + 1/4;
    models_to_plot = {'ego','ext','joint','musc','handelbow'};
    % x coordinate of individual monkey bars
    monk_x = (2:3:((num_monks-1)*3+2))/10;
    % template for within monkey bars separation
    template_x = linspace(-0.5,0.5,length(models_to_plot))/10;
    model_spacing = mode(diff(template_x));

    num_boots = 1;


    % find correlations between modeled tuning curves and true tuning curve
    figure('defaultaxesfontsize',18)
    for monkeynum = 1:num_monks
        % load data
        load(fullfile(datadir,filename{monkeynum}))

        % setup...
        num_bins = encoderResults.params.num_tuning_bins;
        num_neurons = height(encoderResults.tuning_curves{1,1});

        true_tuning_idx = contains(encoderResults.params.model_names,'S1');
        % models_to_plot = {'ext','ego','musc','markers'};
        tuning_corr = zeros(height(encoderResults.tuning_curves{1,1}),length(models_to_plot));

        % arrange tuning curves for each neuron
        for neuron_idx = 1:num_neurons
            tuning_curve_mat = zeros(num_bins*2,length(models_to_plot)+1);
            for spacenum = 1:2
                tuning_curve_mat(num_bins*(spacenum-1)+(1:num_bins),end) = encoderResults.tuning_curves{spacenum,true_tuning_idx}(neuron_idx,:).velCurve';
                for modelnum = 1:length(models_to_plot)
                    tuning_idx = strcmp(encoderResults.params.model_aliases,models_to_plot{modelnum});
                    tuning_curve_mat(num_bins*(spacenum-1)+(1:num_bins),modelnum) = encoderResults.tuning_curves{spacenum,tuning_idx}(neuron_idx,:).velCurve';
                end
            end
            covar_mat = nancov(tuning_curve_mat);
            tuning_corr(neuron_idx,:) = covar_mat(end,1:end-1)./sqrt(diag(covar_mat(1:end-1,1:end-1))'*covar_mat(end,end));
            % tuning_corr(neuron_idx,:) = covar_mat(end,1:end-1);
        end

        % % bootstrap correlation values for actual tuning curves
        % boot_tuning_corr = zeros(num_neurons,num_boots);
        % boot_tic = tic;
        % for bootnum = 1:num_boots
        %     [~,boot_idx1] = datasample(encoderResults.td_tuning{1},length(encoderResults.td_tuning{1}));
        %     [~,boot_idx2] = datasample(encoderResults.td_tuning{1},length(encoderResults.td_tuning{1}));

        %     % arrange tuning curves for each neuron
        %     for neuron_idx = 1:height(encoderResults.tuning_curves{1,1})
        %         % split into two estimates of tuning curve for each workspace
        %         % then concatenate tuning curves of two workspaces for two overall tuning curve
        %         temp_curves = zeros(num_bins*2,2);
        %         for spacenum = 1:2
        %             tuning_params = struct('out_signals',{{'S1_FR',neuron_idx}},'out_signal_names',1,...
        %                 'num_bins',num_bins,'meta',struct('spaceNum',spacenum));
        %             temp_table1 = getTuningCurves(encoderResults.td_tuning{spacenum}(boot_idx1),tuning_params);
        %             temp_table2 = getTuningCurves(encoderResults.td_tuning{spacenum}(boot_idx2),tuning_params);
        %             temp_curves(num_bins*(spacenum-1)+(1:num_bins),1) = temp_table1.velCurve';
        %             temp_curves(num_bins*(spacenum-1)+(1:num_bins),2) = temp_table2.velCurve';
        %         end

        %         temp_covar = nancov(temp_curves);
        %         boot_tuning_corr(neuron_idx,bootnum) = temp_covar(1,2)/sqrt(prod(nanvar(temp_curves)));
        %     end
        %     % tuning_corr(neuron_idx,:) = covar_mat(end,1:end-1);
        %     fprintf('Bootstrap %d done at time %f\n',bootnum,toc(boot_tic))
        % end

        % make the plot
        mean_corr = mean(tuning_corr);
        for modelnum = 1:length(models_to_plot)
            xval = monk_x(monkeynum) + template_x(modelnum);
            bar(xval,mean_corr(modelnum),model_spacing,'facecolor',getModelColors(models_to_plot{modelnum}),'edgecolor','none')
            hold on
            % plot([xval xval],[mean_err(modelnum)-std_err_err(modelnum) mean_err(modelnum)+std_err_err(modelnum)],'k','linewidth',3)
        end
        xval = repmat(monk_x(monkeynum)+template_x,length(tuning_corr),1);
        scatter(xval(:),tuning_corr(:),[],'k','filled')
        plot(xval',tuning_corr','-k','linewidth',1)
    end
    set(gca,'tickdir','out','box','off','xtick',monk_x,...
        'xticklabel',filename,'ticklabelinterpreter','none')
    % axis equal
    % ylim([0 0.6])
    xlim([0 1])
    ylabel('Modeled tuning curve correlations')

%% Get example tuning curves for all models
    for monkeynum = 1%:num_monks
        clear encoderResults

        % load data
        load(fullfile(datadir,filename{monkeynum}))

        %% Plot out tuning curves
            % compare PM and DL tuning for each model
            for modelnum = 1:num_models
                figure('defaultaxesfontsize',18)
                % figure
                compareTuning(encoderResults.tuning_curves(:,modelnum),encoderResults.pdTables(:,modelnum),struct('which_units',find(encoderResults.isTuned),'cond_colors',cond_colors))
                % compareTuning(encoderResults.tuning_curves(:,modelnum),encoderResults.pdTables(:,modelnum),struct('which_units',find(encoderResults.isTuned),'cond_colors',cond_colors,'maxFR',1))
                title(encoderResults.params.model_names{modelnum},'interpreter','none')
            end
    end

%% Decoder stuff
    datadir = '/home/raeed/data/limblab/data-td/FullWS/Results/Decoding';
    filename = {'Han_20160325_RWhold_decodingResults_run20180813.mat','Chips_20151211_RW_decodingResults_run20181029.mat'};
    % datadir = '/home/raeed/data/limblab/data-td/ActPas/Results/Decoding';
    % filename = {'Han_20170203_COactpas_decodingResults_run20181029.mat','Chips_20170913_COactpas_decodingResults_run20181029.mat'};
    num_monks = length(filename);
    barwidth = 0.4;
    markerstyle = 'oo';
    barfig = figure('defaultaxesfontsize',18);
    % scatfig = figure('defaultaxesfontsize',18);
    monk_colors = linspecer(2);
    decoder_colors = [...
        158 33 106;...
        0 159 145]/255;
    for monkeynum = 1:num_monks
        %% load data
        load(fullfile(datadir,filename{monkeynum}))

        %% make decoder performance scatter plots
        x_offset = monkeynum-1;
        % first monkey
        figure(barfig)
        bar([1 3]*0.20+x_offset,mean(decoderResults.hand_decoder_vaf),barwidth,'facecolor',decoder_colors(1,:),'edgecolor','none')
        hold on
        bar([2 4]*0.20+x_offset,mean(decoderResults.neur_decoder_vaf),barwidth,'facecolor',decoder_colors(2,:),'edgecolor','none')
        plot([1 2]*0.20+x_offset,[decoderResults.hand_decoder_vaf(:,1) decoderResults.neur_decoder_vaf(:,1)]','-k','linewidth',1)
        plot([3 4]*0.20+x_offset,[decoderResults.hand_decoder_vaf(:,2) decoderResults.neur_decoder_vaf(:,2)]','-k','linewidth',1)
        plot([1 3 2 4]*0.20+x_offset, [decoderResults.hand_decoder_vaf decoderResults.neur_decoder_vaf]','.k','markersize',30)

        % figure(scatfig)
        % % subplot(1,2,1)
        % scatter(...
        %     decoderResults.hand_decoder_vaf(:,1),...
        %     decoderResults.neur_decoder_vaf(:,1),...
        %     75,...
        %     monk_colors(monkeynum,:),...
        %     markerstyle(monkeynum),...
        %     'filled')
        % hold on
        % plot([0 1],[0 1],'--k','linewidth',2)

        % % subplot(1,2,2)
        % scatter(...
        %     decoderResults.hand_decoder_vaf(:,2),...
        %     decoderResults.neur_decoder_vaf(:,2),...
        %     75,...
        %     monk_colors(monkeynum,:),...
        %     markerstyle(monkeynum),...
        %     'linewidth',2)
        % hold on
        % plot([0 1],[0 1],'--k','linewidth',2)
    end

    % make pretty
    figure(barfig)
    xtick = [(1:4)*0.20 1+(1:4)*0.20];
    xticklabel = repmat({'Hand-only pos','Hand+Neuron pos','Hand vel','Hand+Neuron vel'},1,2);
    set(gca,'box','off','tickdir','out','xtick',xtick,...
        'xticklabel',xticklabel,...
        'xlim',[0 num_monks],'ylim',[0 1])
    ylabel 'Fraction VAF'
    xlabel 'Model'
    title([{'Decoding performance'};filename'],'interpreter','none')

    % figure(scatfig)
    % % subplot(1,2,1)
    % % axis equal
    % % subplot(1,2,2)
    % axis equal
    % set(gca,'box', 'off', 'tickdir', 'out', 'xtick',[0 1],'ytick',[0 1])

    % plot predictions
    % load data
    monkeynum = 2;
    load(fullfile(datadir,filename{monkeynum}))
    figure('defaultaxesfontsize',18)
    last_trial_end = 0;
    elbow_idx = 28:30;
    num_trials = 7;
    for trialnum = 1:num_trials
        true_pos = 100*getSig(decoderResults.td_test(trialnum),{'markers',elbow_idx});
        true_vel = 100*getSig(decoderResults.td_test(trialnum),{'marker_vel',elbow_idx});
        hand_pred_pos = 100*getSig(decoderResults.td_test(trialnum),{'linmodel_hand_decoder',1:3});
        hand_pred_vel = 100*getSig(decoderResults.td_test(trialnum),{'linmodel_hand_decoder',4:6});
        neur_pred_pos = 100*getSig(decoderResults.td_test(trialnum),{'linmodel_neur_decoder',1:3});
        neur_pred_vel = 100*getSig(decoderResults.td_test(trialnum),{'linmodel_neur_decoder',4:6});
        binvec = (1:size(true_pos,1)) + last_trial_end;
        last_trial_end = binvec(end);
        timevec = binvec*decoderResults.td_test(1).bin_size;

        ax(1) = subplot(3,2,1);
        plot(timevec,true_pos(:,3),'-k','linewidth',2)
        hold on
        plot(timevec,hand_pred_pos(:,3),'-','linewidth',2,'color',decoder_colors(1,:))
        plot(timevec,neur_pred_pos(:,3),'-','linewidth',2,'color',decoder_colors(2,:))
        title('Elbow Position')
        ylabel('X-coordinate (cm)');
        ax(2) = subplot(3,2,2);
        plot(timevec,true_vel(:,3),'-k','linewidth',2)
        hold on
        plot(timevec,hand_pred_vel(:,3),'-','linewidth',2,'color',decoder_colors(1,:))
        plot(timevec,neur_pred_vel(:,3),'-','linewidth',2,'color',decoder_colors(2,:))
        title('Elbow Velocity')
        
        ax(3) = subplot(3,2,3);
        plot(timevec,true_pos(:,1),'-k','linewidth',2)
        hold on
        plot(timevec,hand_pred_pos(:,1),'-','linewidth',2,'color',decoder_colors(1,:))
        plot(timevec,neur_pred_pos(:,1),'-','linewidth',2,'color',decoder_colors(2,:))
        ylabel('Y-coordinate (cm)')
        ax(4) = subplot(3,2,4);
        plot(timevec,true_vel(:,1),'-k','linewidth',2)
        hold on
        plot(timevec,hand_pred_vel(:,1),'-','linewidth',2,'color',decoder_colors(1,:))
        plot(timevec,neur_pred_vel(:,1),'-','linewidth',2,'color',decoder_colors(2,:))

        ax(5) = subplot(3,2,5);
        plot(timevec,true_pos(:,2),'-k','linewidth',2)
        hold on
        plot(timevec,hand_pred_pos(:,2),'-','linewidth',2,'color',decoder_colors(1,:))
        plot(timevec,neur_pred_pos(:,2),'-','linewidth',2,'color',decoder_colors(2,:))
        ylabel('Z-coordinate (cm)')
        xlabel('Time (s)')
        ax(6) = subplot(3,2,6);
        plot(timevec,true_vel(:,2),'-k','linewidth',2)
        hold on
        plot(timevec,hand_pred_vel(:,2),'-','linewidth',2,'color',decoder_colors(1,:))
        plot(timevec,neur_pred_vel(:,2),'-','linewidth',2,'color',decoder_colors(2,:))
        xlabel('Time (s)')
    end
    linkaxes(ax,'x')

    trial_ends = cumsum(cat(1,decoderResults.td_test.idx_endTime))';
    goCues = cat(1,decoderResults.td_test.idx_goCueTime)' + [0 trial_ends(1:end-1)];
    trial_ends_time = trial_ends*decoderResults.td_test(1).bin_size;
    goCues_time = goCues*decoderResults.td_test(1).bin_size;
    for plotnum = 1:length(ax)
        subplot(3,2,plotnum)
        ylims = get(gca,'ylim')';
        targ_y = [0.9 0.1] * ylims;
        plot(repmat(trial_ends_time,2,1),repmat(ylims,1,numel(trial_ends_time)),'--k','linewidth',3)
        scatter(goCues_time(:)',repmat(targ_y,1,numel(goCues_time)),100,'r','s','filled')
        set(gca,'box','off','tickdir','out')
    end

%% Extra stuff/in progress...
    %% Plot handle positions
        figure('defaultaxesfontsize',18)
        pos_dl = cat(1,results.td_test{2}.pos);
        plot(pos_dl(:,1),pos_dl(:,2),'r')
        hold on
        pos_pm = cat(1,results.td_test{1}.pos);
        plot(pos_pm(:,1),pos_pm(:,2),'b')
        axis equal
        
        % clean up
        clearvars pos_*
