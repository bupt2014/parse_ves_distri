global earthR nmile2km stateSize
earthR = 6371;
nmile2km =  1.852;
stateSize = 40;
sateHeight = 700;
% 读取数据和数据的初步处理
dir_distri = './distri_data.txt';
distri_data = csvread(dir_distri);

dis_bigger = find(distri_data(:,2) > 0);
dis_less = find(distri_data(:,2) < 0);
distri_data(dis_bigger, 2) = -1 * distri_data(dis_bigger, 2);
distri_data(dis_less, 2) = -1 * distri_data(dis_less, 2);

%计算爬取数据的每个方框的左上角和右下角的经纬度
sqLoc = zeros(size(distri_data, 1), 4); % 1 2 列为左上角的经度和纬度 3 4 列为右下角的经度和纬度
sqLoc(:, [2 4]) = distri_data(:, 2) * ones(1, 2);
sqLoc(:, 2) = sqLoc(:, 2) - 4;
sqLoc(:, [1 3]) = distri_data(:, 1) * ones(1, 2);
sqLoc(:, 3) = sqLoc(:, 3) + 8;

%通过卫星位置，确定小区
% start_lon = -180;
% start_lat = -90;
vesDistriModel = zeros(78, 78);
% for lon = -180 : 20 : 180
%     for lat = -50 : 20 : 50
        lon = 121;
        lat = -31;
        rectRecord = zeros(size(sqLoc, 1), 1);
        num_state = F_calSateAreaSize(sateHeight);
        stateLatAll = F_calAreasLat(num_state, lat);
        stateLonAll = F_calAreasLon(stateLatAll, lon);
        stateLat = F_incircleAreas(stateLatAll);
        stateLon = F_incircleAreas(stateLonAll);
        for sqIdx = 1 : 1 : size(sqLoc, 1)
			areaLoc = ...
				~(sqLoc(sqIdx,3)<stateLon(:,:,2) | sqLoc(sqIdx,1)>stateLon(:,:,3) | ...
				sqLoc(sqIdx,4)<stateLat(:,:,1) | sqLoc(sqIdx,2)>stateLat(:,:,3) | ...
				isnan(stateLon(:,:,3)) | isnan(stateLat(:,:,3)));
            if ~isempty(find(areaLoc > 0))
                rectRecord(sqIdx, 1) = 1;
            end
% 			areasInSq = sum(areaLoc(:));
% 			vesDistriModel(areaLoc) = curVesNum(sqIdx)/areasInSq;
% 			vesDistriModel(areaLoc) = round(vesDistriModel(areaLoc) + rand(areasInSq, 1));
        end
        total_row = find(rectRecord > 0);
        figure(1);
        for i = 1 : 1 : size(total_row, 1)
            rectangle('Position', [distri_data(total_row(i), 1), distri_data(total_row(i), 2), 8, 4]);
%             annotation('rectangle', [distri_data(total_row(i), 1), distri_data(total_row(i), 2), 8, 4],...
%                 'string', distri_data(total_row(i), 3));
            text(distri_data(total_row(i), 1), distri_data(total_row(i), 2) + 2, [num2str(distri_data(total_row(i), 3)), ' ']);
            hold on;
        end
        str_title = ['lat_', sprintf('%d', lat), '_lon_', sprintf('%d', lon)];
        title(str_title);
%         ylim([min(min(stateLatAll,2)) max(max(stateLatAll,3))]);
%         xlim([min(min(stateLonAll, 2)) max(max(stateLonAll, 3))]);
        dir_save_jpg = ['.\picture\', str_title, '.jpg'];
        saveas(gcf, dir_save_jpg);
        close(figure(1));
%     end
% end