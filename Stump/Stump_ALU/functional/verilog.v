// Stump ALU
// Implement your Stump ALU here
//
// Created by Paul W Nutter, Feb 2015
//
// ** Update this header **
//

`include "Stump/Stump_definitions.v"


// 'include' definitions of function codes etc.
// e.g. can use "`ADD" instead of "'h0" to aid readability
// Substitute your own definitions if you prefer by
// modifying Stump_definitions.v

/*----------------------------------------------------------------------------*/

module Stump_ALU (input  wire [15:0] operand_A,		// First operand
                                 input  wire [15:0] operand_B,		// Second operand
		                          input  wire [ 2:0] func,		// Function specifier
		                          input  wire        c_in,		// Carry input
		                          input  wire        csh,  		// Carry from shifter
		                          output wire  [15:0] result,		// ALU output
		                          output reg  [ 3:0] flags_out);	// Flags {N, Z, V, C}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */
reg [16:0] internaResult;
reg [15:0] carry;
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Verilog code                                                               */
assign result = internaResult[15:0];  

always @(*) begin
	case (func)
		`ADD:begin internaResult = operand_A + operand_B; //ADD
				carry = operand_A[14:0] + operand_B[14:0];
				flags_out[3] = result[15];
				flags_out[2] = result == 16'h0000;
				flags_out[1] = ~((internaResult[16] & carry[15]) | (~internaResult[16] & ~carry[15]));
				flags_out[0] = internaResult[16];
		end
		`ADC:begin internaResult = operand_A + operand_B + c_in; //ADC
				carry = operand_A[14:0] + operand_B[14:0] + c_in;
				flags_out[3] = result[15];
				flags_out[2] = result == 16'h0000;
				flags_out[1] = ~((internaResult[16] & carry[15]) | (~internaResult[16] & ~carry[15]));
				flags_out[0] = internaResult[16];
		end
		`SUB:begin internaResult = operand_A + ~operand_B + 1; //SUB
				carry = operand_A[14:0] + ~operand_B[14:0] + 1;
				flags_out[3] = result[15];
				flags_out[2] = result == 16'h0000;
				flags_out[1] = ~((internaResult[16] & carry[15]) | (~internaResult[16] & ~carry[15]));
				flags_out[0] = internaResult[16];
		end
		`SBC:begin internaResult = operand_A + ~operand_B + !c_in; //SBC
				carry = operand_A[14:0] + ~operand_B[14:0]+ !c_in;
				flags_out[3] = result[15];
				flags_out[2] = result == 16'h0000;
				flags_out[1] = ~((internaResult[16] & carry[15]) | (~internaResult[16] & ~carry[15]));
				flags_out[0] = internaResult[16];
		end
		`AND:begin internaResult[15:0] = operand_A & operand_B; //AND
				flags_out[3] = result[15];
				flags_out[2] = result == 16'h0000;
				flags_out[1] = 0;
				flags_out[0] = csh;
		end
		`OR:begin internaResult[15:0] = operand_A | operand_B; //OR
				flags_out[3] = result[15];
				flags_out[2] = result == 16'h0000;
				flags_out[1] = 0;
				flags_out[0] = csh;
		end
		`LDST:begin internaResult[15:0] = operand_A + operand_B; //LD/ST
				flags_out = 4'bxxxx;
		end
		`BCC:begin internaResult[15:0] = operand_A + operand_B; //BCC
				flags_out = 4'bxxxx;
		end
		default:begin internaResult[15:0] = 16'hxxxx;
				flags_out = 4'bxxxx;
		end
	endcase
end
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/*----------------------------------------------------------------------------*/

endmodule

/*============================================================================*/

