import Vector::*;

typedef struct {
 Bool valid;
 Bit#(31) data;
 Bit#(4) index;
} ResultArbiter deriving (Eq, FShow);

function ResultArbiter select_from_2(ResultArbiter a, ResultArbiter b);
	if (a.valid)
		return a;
	else
		return b;
endfunction

function ResultArbiter arbitrate(Vector#(16, Bit#(1)) ready, Vector#(16, Bit#(31)) data);
	// return ResultArbiter{valid: False, data : 0, index: 0};

	// Step 0: Map 16 input to 16 arbiter result.
	Vector#(16, ResultArbiter) level0_selector;
	for (Integer i = 0; i < 16; i = i + 1) begin
		level0_selector[i].valid = ready[i] == 1;
		level0_selector[i].data = data[i];
		level0_selector[i].index = fromInteger(i);
	end

	// Step 1: Select 8 from 16.
	Vector#(8, ResultArbiter) level1_selector;
	for (Integer i = 0; i < 8; i = i + 1) begin
		level1_selector[i] = select_from_2(level0_selector[2*i], level0_selector[2*i+1]);
	end

	// Step 2: Select 4 from 8.
	Vector#(4, ResultArbiter) level2_selector;
	for (Integer i = 0; i < 4; i = i + 1) begin
		level2_selector[i] = select_from_2(level1_selector[2*i], level1_selector[2*i+1]);
	end

	// Step 3: Select 2 from 4.
	Vector#(2, ResultArbiter) level3_selector;
	for (Integer i = 0; i < 2; i = i + 1) begin
		level3_selector[i] = select_from_2(level1_selector[2*i], level1_selector[2*i+1]);
	end

	// Step 4: Select 1 from 2.
	return select_from_2(level3_selector[0], level3_selector[1]);

endfunction

