function plotExampleFR(trial_data,params)
    % plotexamplefr plots some number of trials for a given neuron,
    % with the actual firing rate, along with modeled firing rates

    neuron_idx = 0;
    models = {'ext','ego','musc','handelbow'};
    trial_idx = 1:length(trial_data);
    do_smoothing = false; % whether to smooth actual spikes
    do_random_pred = false; % whether to do dice roll on model predictions
    assignParams(who,params)

    model_colors = getModelColors(models);

    %% Example predictions
    if do_smoothing
        trial_data = smoothSignals(trial_data,struct('signals','S1_spikes','kernel_SD',0.1));
    end

    trial_endtime = 0;
    for trialnum = 1:length(trial_idx)
        temp_spikes = get_vars(trial_data(trial_idx(trialnum)),{'S1_spikes',neuron_idx});
        bin_size = trial_data(trial_idx(trialnum)).bin_size;
        trial_starttime = trial_endtime;
        trial_endtime = trial_starttime + length(temp_spikes)*bin_size;
        plot(trial_starttime:bin_size:(trial_endtime-bin_size),...
            temp_spikes','color',ones(1,3)*0.5,'linewidth',2)
        hold on

        for modelnum = 1:length(models)
            temp_pred = bin_size * get_vars(trial_data(trial_idx(trialnum)),{sprintf('glm_%s_model',models{modelnum}),neuron_idx});
            if do_random_pred
                temp_pred = poissrnd(temp_pred);
            end
            plot(trial_starttime:bin_size:trial_endtime-bin_size,...
                temp_pred','color',model_colors(modelnum,:),'linewidth',2)

            % ax1 = subplot(2,1,1);
            % plot(temp_vel(:,1),'b','linewidth',2)
            % hold on
            % plot(temp_vel(:,2),'g','linewidth',2)
            % set(gca,'box','off','tickdir','out')
            % 
            % ax2 = subplot(2,1,2);
        end
        ylims = get(gca,'ylim');
        plot([trial_starttime trial_starttime],ylims,'--k','linewidth',2)
        plot([trial_endtime trial_endtime],ylims,'--k','linewidth',2)
    end
    set(gca,'box','off','tickdir','out')
end
