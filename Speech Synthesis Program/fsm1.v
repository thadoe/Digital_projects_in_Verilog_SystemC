// This is main FSM core that drive others blocks with timing. Refer to the schematic

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module fsm1 (
  output reg        busy,
  input  wire        period_expired,
  input  wire        data_arrived,
  input  wire        val_match,
  output reg        load_ptrs,
  output reg        increment,
  output reg        sample_capture,
  input  wire        clk
  );
  
  parameter [3:0]  Idle =                       4'b0000,
                   Timer_sync_for_load =        4'b0001,
                   Load =                       4'b0010,
                   Delay_ADDR =                 4'b0011,
                   Delay_ROM1 =                 4'b0100,
                   Delay_ROM2 =                 4'b0101,
                   Capture =                    4'b0110,
                   Timer_sync_for_increment =   4'b0111,
                   Increment =                  4'b1000;
                   
  reg [3:0] current_state = Idle,
            next_state;

// current state logic
    always @ (posedge clk)
        begin 
        current_state <= next_state;
        end 

// next state logic 
    always @*
        begin 
        case(current_state)
            Idle:  
                    if (data_arrived) next_state = Timer_sync_for_load; 
                    else  next_state = Idle; 
                   
                  
            Timer_sync_for_load:      // load operation needed to be synchronized with timer 
                    if (period_expired) next_state = Load;
                    else  next_state =  Timer_sync_for_load;

                    
            Load: next_state = Delay_ADDR; // Delay for ADDR block 
            
            Delay_ADDR: next_state = Delay_ROM1; // 2 cycles delay for latancy of 64Kx8 ROM (BRAM) 
            
            Delay_ROM1: next_state = Delay_ROM2;
            
            Delay_ROM2: next_state = Capture; 
            
            Capture:  
                        if (val_match) next_state = Idle; 
                        else  next_state =  Timer_sync_for_increment; 
                      
            
            Timer_sync_for_increment:          // increment operation needed to be synchronized with timer 
                         if (period_expired) next_state = Increment; 
                         else next_state = Timer_sync_for_increment; 
             
             Increment: next_state = Delay_ADDR; 
             
             default: next_state = Idle;
           endcase
           end

//fsm output logic   
    always @*
    begin
    
    case(current_state)
        Idle: begin
            busy=0;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
            end 
        
        Timer_sync_for_load: begin
            busy=1;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
            end
        
        
        Load: begin
            busy=1;
            sample_capture=0;
            load_ptrs=1;
            increment=0;
        end
        
        Delay_ADDR: begin
            busy=1;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
        end
        
        
        Delay_ROM1: begin
            busy=1;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
        end
        
        Delay_ROM2: begin
            busy=1;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
        end
        
        
        Capture: begin
            busy=1;
            sample_capture=1;
            load_ptrs=0;
            increment=0;
        end
        
        Timer_sync_for_increment: begin
            busy=1;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
        end
        
        Increment: begin
            busy=1;
            sample_capture=0;
            load_ptrs=0;
            increment=1;
        end
        
        default: begin
            busy=0;
            sample_capture=0;
            load_ptrs=0;
            increment=0;
        end
        
    endcase
    end                 
endmodule
