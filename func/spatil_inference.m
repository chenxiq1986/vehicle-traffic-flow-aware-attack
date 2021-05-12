function esti_index = spatil_inference(approx_index, index)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [TRANS_EST, EMIS_EST] = hmmestimate(approx_index, index); 
    esti_index = hmmviterbi(approx_index, TRANS_EST, EMIS_EST); 
end

