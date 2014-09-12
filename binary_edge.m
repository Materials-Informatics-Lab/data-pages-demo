function edge = binary_edge( image )
% An approximate algorithm for finding edges in binary images.
%
% The algorithm shifts the images one voxel in each direction.
% It compares the difference betwee the original image and the shifted image.
% Nonzero values indicate edge values

DIMS = ndims(image);

shifts = vertcat( eye(DIMS), ...
               -1*eye(DIMS));

edge = zeros( size( image ) );
for ii = 1 : size( shifts, 1 )
    edge(:) = edge + ...
        abs( image - circshift( image, shifts( ii, : ) ) );
end
      
