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
%  �������ӭn��SliceLocation�h�ƨҵf����A���L�Oset data�w�g�Ʀn�N���ϰ�
%  More General Approach: (�ݸ�)
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

% �դU�Τⰵsqueeze�ĪG
for m = 1:166 
    % ���I�Yimg(:,200,m)�O�@���A
    % �N��Y��C�@�i(Total 166�i)256x256 mri image����200 column�Ҧ����e��
    % i.e. �C�i�v����256x1�A��m����Ϫ���200��A�M��ѷs�v������1 column�}�l�V�k���i�A�|���166�h����
    % ��v�����`��/�p���ܦ��s�v������V/column��V�A���V/Row��V����
    IMG_1(:,m) = img(:,200,m); 
    IMG_2(m,:) = img(:,200,m);
    % IMG_2 �Y�Nrow��V�����e����hcolumn��V�A�M��V�U�|166�h
    % �]���s�v���j�p����166x256,�B�ĪG���ӭn�P��v������90�צAsqueeze�@��
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

