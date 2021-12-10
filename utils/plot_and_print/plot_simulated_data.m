function plot_simulated_data(U,u,P)
% plots the 3D points in X together with the cameras given in P. Can also
% be added s.t. the image points in x are plotted (together with images).
% x is a struct with x{i} being a 3xn matrix with the n image points in
% image i.

U = pflat(U);

figure(); clf;
% plot the 3D points
plot3(U(1,:),U(2,:),U(3,:),'.','MarkerSize',10);
hold on;

if ~isempty(P)
    % plot the cameras
    % c = zeros(4,length(P));
    c = zeros(3,length(P));
    v = zeros(3,length(P));
    for i = 1:length(P)
        c(:,i) = -(P{i}(1:3,1:3))'*(P{i}(1:3,4));
        %     c(:,i) = null(P{i});
        v(:,i) = P{i}(3,1:3);
    end
    % c = c./repmat(c(4,:),[4,1]);
    %c = pflat(c); ?
%     quiver3(c(1,:),c(2,:),c(3,:),v(1,:),v(2,:),v(3,:),0.5,['r','-'],'LineWidth',0.5,'MaxHeadSize',0.5); % to scale arrows to half length
    quiver3(c(1,:),c(2,:),c(3,:),v(1,:),v(2,:),v(3,:),['r','-'],'LineWidth',0.5,'MaxHeadSize',0.5);
    % add plotting of position of P and directon with arrow (see computer vision)
    text(c(1,:),c(2,:),c(3,:),split(num2str((1:length(P)))));
end
axis equal
xlabel('x'); ylabel('y'); zlabel('z');

if ~isempty(u)
    for i = 1:length(u)
        figure(); clf;
        xtmp = pflat(u{i});
        plot(xtmp(1,:),xtmp(2,:),'*');
        title(['Image points in image ' num2str(i)]);
    end
end

