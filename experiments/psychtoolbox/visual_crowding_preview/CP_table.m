side = [-1 1];
SET = [0 1];
preview = [0 1];
quesionType = [0 1];
crowding = [1 2 3];
connection = [0 1 2 3];

expTable = [];
i_trial = 1;

for i_side = 1:length(side)
    for i_SET = 1:length(SET)
        for i_preview = 1:length(preview)
            for i_questionType = 1:length(quesionType)
                for i_crowding = 1:length(crowding)
                    for i_connection = 1:length(connection)
                    expTable(i_trial,:) = [side(i_side),SET(i_SET), preview(i_preview), quesionType(i_questionType), crowding(i_crowding), connection(i_connection)];
                    i_trial = i_trial+1;
                    end
                end
            end
        end
    end
end

expLabels = {'side','SET', 'preview','questionType', 'crowding', 'connection'};
expTable = expTable(randperm(size(expTable,1)), :); % randomize
expTable = array2table(expTable, 'VariableNames',expLabels);