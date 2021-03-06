%% Set up meta info
if ispc
    homefolder = 'C:\Users\rhc307';
else
    homefolder = '/home/raeed';
end

datadir = fullfile(homefolder,'data','project-data','limblab','s1-kinematics','td-library');
file_info = dir(fullfile(datadir,'*TRT*'));
filenames = horzcat({file_info.name})';

num_musc_pcs = 5;
lenVAF = zeros(length(filenames),1);
velVAF = zeros(length(filenames),1);

%% Loop through files
for filenum = 1:length(filenames)
    %% Load data
    td = load(fullfile(datadir,[filenames{filenum}]));

    % rename trial_data for ease
    td = td.trial_data;

    % first process marker data
    % find times when markers are NaN and replace with zeros temporarily
    for trialnum = 1:length(td)
        markernans = isnan(td(trialnum).markers);
        td(trialnum).markers(markernans) = 0;
        td(trialnum) = smoothSignals(td(trialnum),struct('signals','markers'));
        td(trialnum).markers(markernans) = NaN;
        clear markernans
    end

    % get marker velocity
    td = getDifferential(td,struct('signals','markers','alias','marker_vel'));

    % prep trial data by getting only rewards and trimming to only movements
    % split into trials
    td = splitTD(...
        td,...
        struct(...
            'split_idx_name','idx_startTime',...
            'linked_fields',{{...
                'trialID',...
                'result',...
                'spaceNum',...
                'bumpDir',...
                }},...
            'start_name','idx_startTime',...
            'end_name','idx_endTime'));
    [~,td] = getTDidx(td,'result','R');
    td = reorderTDfields(td);

    % for active movements
    % remove trials without a target start (for whatever reason)
    td(isnan(cat(1,td.idx_targetStartTime))) = [];
    td = trimTD(td,{'idx_targetStartTime',0},{'idx_endTime',0});

    % remove trials where markers aren't present
    bad_trial = false(length(td),1);
    for trialnum = 1:length(td)
        if any(any(isnan(td(trialnum).markers)))
            bad_trial(trialnum) = true;
        end
    end
    td(bad_trial) = [];
    fprintf('Removed %d trials because of missing markers\n',sum(bad_trial))
    
    % remove trials where muscles aren't present
    bad_trial = false(length(td),1);
    for trialnum = 1:length(td)
        if any(any(isnan(td(trialnum).muscle_len) | isnan(td(trialnum).muscle_vel)))
            bad_trial(trialnum) = true;
        end
    end
    td(bad_trial) = [];
    fprintf('Removed %d trials because of missing muscles\n',sum(bad_trial))

    % for bumps
    % td = td(~isnan(cat(1,td.idx_bumpTime)));
    % td = trimTD(td,{'idx_bumpTime',0},{'idx_bumpTime',15});

    % bin data at 50ms
    td = binTD(td,0.05/td(1).bin_size);

    % get PM and DL
    [~,td_pm] = getTDidx(td,'spaceNum',1);
    [~,td_dl] = getTDidx(td,'spaceNum',2);
    minsize = min(length(td_pm),length(td_dl));
    td_pm = td_pm(1:minsize);
    td_dl = td_dl(1:minsize);

    % recombine for later...
    td = [td_pm td_dl];

    % get values
    PCAparams = struct('signals','muscle_len', 'do_plot',false);
    [~,len_params] = dimReduce(td,PCAparams);
    PCAparams_vel = struct('signals','muscle_vel', 'do_plot',false);
    [~,vel_params] = dimReduce(td,PCAparams_vel);

    lenVAF_full = cumsum(len_params.eigen/sum(len_params.eigen));
    velVAF_full = cumsum(vel_params.eigen/sum(vel_params.eigen));

    lenVAF(filenum) = lenVAF_full(num_musc_pcs);
    velVAF(filenum) = velVAF_full(num_musc_pcs);
end

