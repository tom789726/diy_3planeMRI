close all; clear all; clc
% DICOM info:
% Total = 166 slice (0001 - 0166)
% Format = 256x256 int16
% SliceThickness = 1
info_slice1 = dicominfo('C:\Users\Tom\Documents\MATLAB\data\mri\IM-0001-0001.dcm');
siz = [
    info_slice1.Width 
    info_slice1.Height 
    info_slice1.ImagesInAcquisition
    ];
% siz = Dimension of image set = [256 256 166] (3x1)

% % 
% Path Setting
path_header = 'C:\Users\Tom\Documents\MATLAB\data\mri\IM-0001-';
slice_num = siz(3); % siz(3) == 166
slist = zeros(slice_num,1); % sorting list for dicom


for i = 1:slice_num
    if (i<=9)
        path_img(i,:) = strcat(path_header,'000',num2str(i),'.dcm');
    end
    if (i>=10 && i<=99)
        path_img(i,:) = strcat(path_header,'00',num2str(i),'.dcm');
    end
    if (i>=100 && i<=999)
        path_img(i,:) = strcat(path_header,'0',num2str(i),'.dcm');
    end    
    
% Dicom Read
    path = path_img(i,:);
    img(:,:,i) = dicomread(path);
%  本身應該要用SliceLocation去排例番整齊，不過呢set data已經排好就唔使啦
%  More General Approach: (待補)
%  slist(i,1) = getfield(dicominfo(path),'SliceLocation'); 

end % for loop end


% % 
% Dicom display (Sagittal Plane)
figure
imshow(img(:,:,100),[]);
title('MRI image (100th stack,Sagittal Plane)');

% Transverse Plane
for i = 1:siz(1)
    img_tr(:,:,i) = squeeze(img(i,:,:));
%     imshow(img_tr(:,:,i),[]);
%     pause(0.1);
end

% 試下用手做squeeze效果
for m = 1:166 
    % 重點係img(:,200,m)呢一項，
    % 意思係抽每一張(Total 166張)256x256 mri image的第200 column所有內容物
    % i.e. 每張影像抽256x1，位置為原圖的第200行，然後由新影像的第1 column開始向右推進，疊到第166層為止
    % 原影像的深度/厚度變成新影像的橫向/column方向，直向/Row方向不變
    IMG_1(:,m) = img(:,200,m); 
    IMG_2(m,:) = img(:,200,m);
    % IMG_2 係將row方向的內容物塞去column方向，然後向下疊166層
    % 因此新影像大小應為166x256,且效果應該要同原影像旋轉90度再squeeze一樣
    IMG_3(:,m) = img(200,:,m);
    IMG_4(m,:) = img(200,:,m);
end

figure
subplot(2,2,1);
imshow(IMG_1,[]);
title('IMG\_1, 256x166');
subplot(2,2,2);
imshow(IMG_2,[]);
title('IMG\_2,156x256');
subplot(2,2,3);
imshow(IMG_3,[]);
title('IMG\_3,256x166');
subplot(2,2,4);
imshow(IMG_4,[]);
title('IMG\_4,166x256');
% subplot(3,2,5);
% imshow(img(:,:,100),[]);
% title('Original Image(100th stack), 256x256');
% subplot(3,2,6);
% for m = 1:166
%     imshow(img_tr(:,:,m),[]);
%     compare_mat = (img_tr(:,:,m) ~= IMG_3); % if (img_tr) equals (IMG_3), elements = all 0
%     result = sum(compare_mat,'all'); % so if sum of elements of (compare_mat) == 0, they are equal
%     xlabel(num2str(result)); % show result on x-axis
%     title(strcat(num2str(m),'th image (By squeeze),256x166'));    
%     pause(0.2);
% end



% IMG = imresize(IMG,[256 256]);

% Coronal Plane
% figure
% for i = 1:siz(3)
%     img_c(:,:,i) = squeeze(img(:,:,i));
%     imshow(img_c(:,:,i),[]);
%     pause(0.2);
% end % for loop end

