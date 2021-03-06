function epistasis = es_segre_epistasis(f_ref,f_single,f_double)

% ES_SEGRE_EPISTASIS Segre's epistasis measure
%
% epistasis = es_segre_epistasis(f_ref,f_single,f_double)
%
% Input 
% f_ref    wildtype fitness (number)
% f_single single perturbation fitnesses (vector)
% f_double double perturbation fitnesses (matrix)
%
% Output
% epistasis (matrix)

epsilon = 10^-8;

w_single = f_single/f_ref;
w_double = f_double/f_ref;
w_single(abs(w_single)<10^-8)= 0;
w_double(abs(w_double)<10^-8)= 0;
is_aggravating = w_double <  w_single * w_single' - epsilon;
is_buffering   = w_double >  w_single * w_single' + epsilon;
is_neutral     = 1 - [is_aggravating + is_buffering];

w_ratio = w_double ./ [w_single * w_single'];
w_ratio(find(is_neutral)) = 1;
w_milder = max( repmat(w_single,1,length(w_single)), repmat(w_single,1,length(w_single))');

epistasis = is_aggravating .* (w_ratio - 1) + is_buffering .* ( [w_ratio - 1] ./ [1./w_milder - 1]);

epistasis = epistasis - diag(diag(epistasis));