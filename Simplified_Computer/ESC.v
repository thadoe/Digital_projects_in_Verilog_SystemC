`timescale 1ns / 1ps

module ESC( 
    input wire clk,
    input wire rst,
    output wire [7:0] pc_out,
    output wire [15:0] A_out,
    output wire [15:0] mdr_out
    );
    
    // Internal registers 
    reg [15:0] inst_reg;
    wire [15:0] MDR;    // concurrent assignment 
    reg [15:0] A;
    reg [7:0] PC;
    reg [7:0] MAR;
    reg  mem_write;
    
    // Driving the output signals 
    assign {pc_out, A_out, mdr_out}  = {PC, A, MDR};
    
    // State machine parameters and registers 
    reg [3:0] current_state;
    parameter RST_PC = 4'h0,
              FETCH = 4'h1,
              DECODE = 4'h2,
              EXEC_LD = 4'h3,
              EXEC_AD = 4'h4,
              EXEC_ST = 4'h5,
              EXEC_ST1 = 4'h6,
              EXEC_ST2 = 4'h7,
              EXEC_JUMP = 4'h8,
              AD = 8'h0,
              ST = 8'h1,
              LD = 8'h2,
              JUMP = 8'h3;
              
    // memory instantiation
    RAM ESC_memory (
            .clk(clk),
            .addr (MAR),
            .din (A),
            .write (mem_write),
            .dout (MDR)
    );
    
    // State Machine 
    always @ (posedge clk or posedge rst)   begin 
        if (rst) begin 
            current_state <= RST_PC;
        end else begin
            case(current_state)
                RST_PC: begin                       // Reset CPU and internal regs 
                    current_state <= FETCH;
                    PC <= 0;
                    MAR <= 0;
                    A <= 0;
                    mem_write <= 0;    
                end 
                FETCH: begin
                    current_state <= DECODE;
                    inst_reg <= MDR;                // first word (instruction) from memory 
                    PC <= PC + 1;
                    mem_write <= 0;
                end
                DECODE: begin
                    MAR <= inst_reg [7:0];
                    case (inst_reg [15:8])          // branch according to 3 bit opcodes from instruction
                        AD: current_state <= EXEC_AD;
                        ST: current_state <= EXEC_ST;
                        LD: current_state <= EXEC_LD;
                        JUMP: current_state <= EXEC_JUMP;
                        default: current_state <= FETCH;
                    endcase 
                end
                EXEC_LD: begin
                    current_state <= FETCH;
                    A <= MDR;
                    MAR <= PC;                  // update MAR 
                end  
                EXEC_AD: begin 
                    current_state <= FETCH;
                    A <= A + MDR;
                    MAR <= PC;                  // update MAR 
                end
                EXEC_ST: begin 
                    current_state <= EXEC_ST1;   // wirte to memory
                    mem_write <= 1;
                end 
                EXEC_ST1: begin
                    current_state <= EXEC_ST2;  // reset write flag 
                    mem_write <= 0;
                end
                EXEC_ST2: begin                 //update MAR 
                    current_state <= FETCH;
                    MAR <= PC;
                end
                EXEC_JUMP: begin 
                    current_state <= FETCH;
                    MAR <= inst_reg[7:0];       // jump to address in instruction 
                    PC <= inst_reg [7:0];
                end
                default: begin                    // if instruction is invalid go next instruction
                    MAR <= PC;
                    current_state <= FETCH;
                end
            endcase
        end
    end
endmodule
