% check out node 9 of R NAcc group

close all
clear all

cd ~/ShockAwe/data/fgMeasures/
coords = dlmread('fgNaccR_node9_coords')
coords = round(coords);

subjects = getSASubjects('dti');
% indx = logical(1:22)
% indx(16)=0;
% subjects = subjects(indx);

for i = 1:length(subjects)
subject = subjects{i};

expPaths = getSAPaths(subjects{i});
cd(expPaths.subj);
%  cd dti96trilin/bin
%  t1 = readFileNifti('b0_t1dim.nii.gz');
t1 = readFileNifti('t1.nii.gz');
t1.data = double(t1.data);
imgCoords = mrAnatXformCoords(t1.qto_ijk,coords(i,:));
all_imgCoords(i,:) = imgCoords;
% t1.data(imgCoords(1),imgCoords(2),imgCoords(3)) = nan;
% %
% 
% sl{1} = rot90(squeeze(t1.data(imgCoords(1),:,:)));  % sagittal slice
% sl{2} = rot90(squeeze(t1.data(:,imgCoords(2),:))); % coronal
% sl{3} = rot90(squeeze(t1.data(:,:,imgCoords(3)))); % axial
% 
% figure
% for j = 1:3
%     subplot(1,3,j)
%     imagesc(sl{j})
%     colormap(gray)
%     hold on
%     [r,c]=find(isnan(sl{j}));
%     plot(r,c,'.','MarkerSize',15,'color','m')
%     axis equal, axis tight
%     hold off
% end
% title(subject)

end