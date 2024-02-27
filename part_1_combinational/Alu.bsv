typedef enum {
	Add,
	ShiftL,
	And,
	Not
} InstructionType deriving (Eq,FShow, Bits);

function Bit#(32) alu (InstructionType ins, Bit#(32) v1, Bit#(32) v2);
	Bit#(32) result;
	case (ins) 
		Add: result = v1 + v2;
		ShiftL: result = v1 << v2;
		And: result = v1 & v2;
		Not: result = ~v1;
	endcase

	return result;
endfunction

