----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2020 10:43:04 AM
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           --signal from padding unit to indicate padding process completion.
           padding_done_in : in STD_LOGIC;
           --signal from convolution unit to indicate convolve process completion.
           convolve_done_in : in STD_LOGIC;
           --signal to start the image filtering process.
           start_op_in : in STD_LOGIC;
           --signal that indicates completion of image filtering process.
           finished_op_out : out STD_LOGIC;
           --signal ram input mux to enable signal from padding unit to
           --reach memory elements.
           enable_mux_padding_out : out STD_LOGIC;
           --signal ram input mux to enable signal from convolution unit to
           --reach memory elements.
           enable_mux_convolve_out : out STD_LOGIC;
           --signal to start the padding unit oprtation.
           start_padding_out : out STD_LOGIC;
           --signal to start the convolution unit oprtation.
           start_convolve_out : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

type state is (Idle, Padding, Convolving, Finished);
signal op_state : state;

-- There are 4 states in the fsm.
-- 1. Idle - fsm waits in Idle state until the start_op_in signal gets high to
-- start the image filtering process by setting padding unit start.
-- 2. Padding - fsm waits in the Padding state when the paddding
-- unit is operating.
-- 3. Convolving - fsm waits in the Convolving state when the
-- convolution unit is operating.
-- 4. Finished - After the Convolving state, fsm goes to Finished state
-- with the convolve done signal and when in finished state, fsm signal finished_op_out
-- for one clock cycle and goes to Idle state.

begin
    fsm : process ( clk, rst_n, start_op_in, padding_done_in, convolve_done_in )
        begin
            --active low reset. Resets all progress back to Idle state.
            if ( rst_n = '0' ) then
                op_state <= Idle;
                finished_op_out <= '0';
                start_padding_out <= '0';
                start_convolve_out <= '0';
                enable_mux_padding_out <= '0';
                enable_mux_convolve_out <= '0';
            elsif ( clk'event and clk = '1' ) then
                case op_state is
                    when Idle =>
                        --waits till the start signal.
                        finished_op_out <= '0';
                        start_padding_out <= '0';
                        start_convolve_out <= '0';
                        enable_mux_padding_out <= '0';
                        enable_mux_convolve_out <= '0';
                        if ( start_op_in = '1' ) then
                            --with start signal, move to Padding state,
                            --signal padding unit to start and signal mux to
                            --enable communication between padding unit and
                            --memory elements.
                            op_state <= Padding;
                            start_padding_out <= '1';
                            enable_mux_padding_out <= '1';
                            enable_mux_convolve_out <= '0';
                        end if;
                    when Padding =>
                        start_padding_out <= '0';
                        if ( padding_done_in = '1' ) then
                            --with padding done signal, move to convlution 
                            --state, signal convolution unit to start and
                            --signal mux to enable communication between
                            --convolution unit and memory elements.
                            op_state <= Convolving;
                            start_convolve_out <= '1';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolve_out <= '1';
                        end if;
                    when Convolving =>
                        if ( convolve_done_in = '1' ) then
                            --with convolution done signal, move to Finished 
                            --state.
                            start_convolve_out <= '0';
                            op_state <= Finished;
                            enable_mux_padding_out <= '0';
                            enable_mux_convolve_out <= '0';
                        end if;
                    when Finished =>
                        --in finished state, signal the operation finish
                        --and move to Idel state.
                        finished_op_out <= '1';
                        op_state <= Idle;
                    when others =>
                        op_state <= Idle;
                end case;
            end if;
        end process fsm;
end Behavioral;