function edge = binary_edge( image )

DIMS = ndims(image);

shifts = vertcat( eye(DIMS), ...
               -1*eye(DIMS));

edge = zeros( size( image ) );
for ii = 1 : size( shifts, 1 )
    edge(:) = edge + ...
        abs( image - circshift( image, shifts( ii, : ) ) );
end
      