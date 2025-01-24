% change working directory (cd) into the location of the script every time 
% the script is called
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

config;

preprocess_data;
% import the folder containing the input data from the analysis to the
% path (i.e. input_data_folder, see config)
addpath(append( fileparts(mfilename('fullpath')), '/./'));
addpath(append( fileparts(mfilename('fullpath')), append('/', ...
        input_data_folder, '/')));

import_data;
initialize;


for iter=1:number_of_iterations
    disp(iter);
    fitting;
    calculate_ea;
    if iter > (1-frac_refine)*number_of_iterations && iter ~= number_of_iterations
        equate_ea_and_refine_tauzero;
    else
    end
end

find_equal_ea_for_plotting;
plotting;

clean_tmp_files;