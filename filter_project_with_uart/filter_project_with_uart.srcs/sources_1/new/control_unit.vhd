----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 11:42:54 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
--  Port ( );
    Port ( clk                     : in STD_LOGIC;
           rst_n                   : in STD_LOGIC;
           padding_done_in         : in STD_LOGIC;--signal from padding unit to indicate padding process completion.
           convolve_done_in        : in STD_LOGIC;--signal from convolution unit to indicate convolve process completion.
           comm_done_in            : in STD_LOGIC;--signal from uart communication unit to indicate communication process completion.
           start_op_in             : in STD_LOGIC;--signal to start the image filtering process.
           finished_op_out         : out STD_LOGIC := '0';--signal that indicates completion of image filtering process.
           enable_mux_padding_out  : out STD_LOGIC := '0';--signal ram input mux to enable signal from padding unit to reach memory elements.
           enable_mux_convolve_out : out STD_LOGIC := '0';--signal ram input mux to enable signal from convolution unit to reach memory elements.
           enable_mux_comm_out     : out STD_LOGIC := '0';--signal ram input mux to enable signal from uart communication unit to reach memory elements.
           start_padding_out       : out STD_LOGIC := '0';--signal to start the padding unit oprtation.
           start_convolve_out      : out STD_LOGIC := '0';--signal to start the convolution unit oprtation.
           start_comm_out          : out STD_LOGIC := '0';--signal to start the uart communication unit oprtation.
           select_comm_op_out      : out STD_LOGIC := '0';--signal to select communication operation.(Send/Receive)
           convolve_led_out        : out STD_LOGIC := '0';--signal progress of the convolution unit
           padding_led_out         : out STD_LOGIC := '0';--signal progress of the padding unit
           receiving_led_out       : out STD_LOGIC := '0';--signal progress of the receiving operation of UART Communication unit
           sending_led_out         : out STD_LOGIC := '0');--signal progress of the sending operation of UART Communication unit
end control_unit;

architecture Behavioral of control_unit is
-- 6 main states in the fsm.
-- 1. Idle - fsm waits in Idle state until the start_op_in signal gets high to
-- start the image filtering process by starting uart communication unit
-- to do data receive.
-- 2. Data_Receive - fsm waits in Data_Receive state until the operation
-- complete signal from the uart communication unit. Then it moves to
-- Padding state by enabling padding operation.
-- 3. Padding - fsm waits in the Padding state when the paddding
-- unit is operating.
-- 4. Convolving - fsm waits in the Convolving state when the
-- convolution unit is operating.
-- 5. Data_Sending - After the Convolution state, fsm goes to Data_Sending state
-- by enabling uart communication  unit to send data and when in Data_Sending
-- state, it waits till the operation finished signal.
-- 6. Finished - After the Data_Sending state, fsm goes to Finished state
-- with the convolve done signal and when in finished state, fsm signal finished_op_out
-- for one clock cycle and goes to Idle state.

type state is (Idle, Data_Receive, Padding, Convolving, Data_Sending, Finished);
signal op_state : state;

begin
    fsm : process (clk, rst_n)
        begin
            --active low reset. Resets all progress back to Idle state.
            if ( rst_n = '0' ) then
                op_state <= Idle;
                finished_op_out <= '0';
                start_padding_out <= '0';
                start_convolve_out <= '0';
                start_comm_out <= '0';
                select_comm_op_out <= '0';
                receiving_led_out <= '0';
                convolve_led_out  <= '0';
                padding_led_out  <= '0';
                sending_led_out <= '0';
            elsif ( clk'event and clk = '1' ) then
                case op_state is
                    when Idle =>
                        --waits till the start signal.
                        finished_op_out <= '0';
                        start_padding_out <= '0';
                        start_convolve_out <= '0';
                        start_comm_out <= '0';
                        select_comm_op_out <= '0';
                        enable_mux_padding_out <= '0';
                        enable_mux_convolve_out <= '0';
                        enable_mux_comm_out <= '0';
                        receiving_led_out <= '0';
                        convolve_led_out  <= '0';
                        padding_led_out  <= '0';
                        sending_led_out <= '0';
                        if ( start_op_in = '1' ) then
                            --with start signal, move to Data_Receive state,
                            --signal uart communication unit to start data
                            --receiving and signal mux to enable communication
                            --between uart communication unit and memory elements.
                            op_state <= Data_Receive;
                            start_comm_out <= '1';
                            select_comm_op_out <= '1';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolve_out <= '0';
                            enable_mux_comm_out <= '1';
                            receiving_led_out <= '0';
                            convolve_led_out  <= '0';
                            padding_led_out  <= '0';
                            sending_led_out <= '0';
                        end if;
                    when Data_Receive =>
                        start_comm_out <= '0';
                        select_comm_op_out <= '0';
                        receiving_led_out <= '1';
                        convolve_led_out  <= '0';
                        padding_led_out  <= '0';
                        sending_led_out <= '0';  
                        if (comm_done_in = '1') then
                            --with comm_done signal, move to Padding state,
                            --signal padding unit to start and signal mux to
                            --enable communication between padding unit and
                            --memory elements.
                            op_state <= Padding;
                            start_padding_out <= '1';
                            enable_mux_padding_out <= '1';
                            enable_mux_convolve_out <= '0';
                            enable_mux_comm_out <= '0';
                            receiving_led_out <= '1';
                            convolve_led_out  <= '0';
                            padding_led_out  <= '0';
                            sending_led_out <= '0';                                                           
                        end if;
                    when Padding =>
                        start_padding_out <= '0';
                        receiving_led_out <= '1';
                        convolve_led_out  <= '0';
                        padding_led_out  <= '1';
                        sending_led_out <= '0';
                        if ( padding_done_in = '1' ) then
                            --with padding done signal, move to convlution 
                            --state, signal convolution unit to start and
                            --signal mux to enable communication between
                            --convolution unit and memory elements.
                            op_state <= Convolving;
                            start_convolve_out <= '1';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolve_out <= '1';
                            enable_mux_comm_out <= '0';
                            receiving_led_out <= '1';
                            convolve_led_out  <= '0';
                            padding_led_out  <= '1';
                            sending_led_out <= '0';  
                        end if;
                    when Convolving =>
                        receiving_led_out <= '1';
                        convolve_led_out  <= '1';
                        padding_led_out  <= '1';
                        sending_led_out <= '0';
                        if ( convolve_done_in = '1' ) then
                            --with convolution done signal, move to Data_Sending 
                            --state. Signal uart communication unit to start data
                            --sending and signal mux to enable communication
                            --between uart communication unit and memory elements.
                            start_convolve_out <= '0';
                            op_state <= Data_Sending;
                            start_comm_out <= '1';
                            select_comm_op_out <= '0';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolve_out <= '0';
                            enable_mux_comm_out <= '1';
                            receiving_led_out <= '1';
                            convolve_led_out  <= '1';
                            padding_led_out  <= '1';
                            sending_led_out <= '0';                             
                        end if;
                    when Data_Sending =>
                        start_comm_out <= '0';
                        select_comm_op_out <= '0';
                        receiving_led_out <= '1';
                        convolve_led_out  <= '1';
                        padding_led_out  <= '1';
                        sending_led_out <= '1';
                        if (comm_done_in = '1') then
                            --With comm_done signal, move to Finished state.
                            op_state <= Finished;
                            enable_mux_padding_out <= '0';
                            enable_mux_convolve_out <= '0';
                            enable_mux_comm_out <= '0';
                            receiving_led_out <= '1';
                            convolve_led_out  <= '1';
                            padding_led_out  <= '1';
                            sending_led_out <= '1';
                        end if;
                    when Finished =>
                        --in finished state, signal the operation finish
                        --and move to Idel state.
                        finished_op_out <= '1';
                        receiving_led_out <= '1';
                        convolve_led_out  <= '1';
                        padding_led_out  <= '1';
                        sending_led_out <= '1';
                        op_state <= Idle;
                    when others =>
                        op_state <= Idle;
                end case;
            end if;
        end process fsm;
end Behavioral;
