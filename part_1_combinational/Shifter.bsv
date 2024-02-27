import Vector::*;

typedef Bit#(16) Word;

function Vector#(16, Word) naiveShfl(Vector#(16, Word) in, Bit#(4) shftAmnt);
    Vector#(16, Word) resultVector = in; 
    for (Integer i = 0; i < 16; i = i + 1) begin
        Bit#(4) idx = fromInteger(i);
        resultVector[i] = in[shftAmnt+idx];
    end
    return resultVector;
endfunction


function Vector#(16, Word) barrelLeft(Vector#(16, Word) in, Bit#(4) shftAmnt);
    Vector#(5, Vector#(16, Word)) intermediatae_layers;

    intermediatae_layers[0] = in;

    for (Integer i = 1; i < 5; i = i + 1) begin
        Bit#(4) shift_amount = fromInteger(1) << fromInteger(i-1);
        intermediatae_layers[i] = shftAmnt[i-1] == 1 ? 
                                    naiveShfl(intermediatae_layers[i-1], shift_amount) : 
                                    intermediatae_layers[i-1];
    end


    return intermediatae_layers[4];


endfunction
