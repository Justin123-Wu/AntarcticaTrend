function [LT] = calTrendDecompSeasonal(x)
% x:   m x 1 vector, the input data
% LT:  m x 1 vector, the long term trend
%
%todo: may add more parameters when calling trenddecomp()

[LT, st, R] = trenddecomp( x );

end

