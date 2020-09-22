----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 04:28:31 PM
-- Design Name: 
-- Module Name: control_unit_tb - Behavioral
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

entity control_unit_tb is
--  Port ( );
end control_unit_tb;

architecture Behavioral of control_unit_tb is

component control_unit is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           padding_done_in : in STD_LOGIC;
           convolve_done_in : in STD_LOGIC;
           comm_done_in : in STD_LOGIC;
           start_op_in : in STD_LOGIC;
           finished_op_out : out STD_LOGIC;
           enable_mux_padding_out : out STD_LOGIC := '0';
           enable_mux_convolve_out : out STD_LOGIC := '0';
           enable_mux_comm_out : out STD_LOGIC := '0';
           start_padding_out : out STD_LOGIC := '0';
           start_convolve_out : out STD_LOGIC := '0';
           start_comm_out : out STD_LOGIC := '0';
           select_comm_op_out : out STD_LOGIC := '0';
           convolve_led_out : out STD_LOGIC := '0';
           padding_led_out : out STD_LOGIC := '0';
           receiving_led_out : out STD_LOGIC := '0';
           sending_led_out : out STD_LOGIC := '0');
end component;

signal clk : STD_LOGIC := '0';
signal rst_n : STD_LOGIC;
signal padding_done_in : STD_LOGIC;
signal convolve_done_in : STD_LOGIC;
signal comm_done_in : STD_LOGIC;
signal start_op_in : STD_LOGIC;
signal finished_op_out : STD_LOGIC;
signal enable_mux_padding_out : STD_LOGIC;
signal enable_mux_convolve_out : STD_LOGIC;
signal enable_mux_comm_out : STD_LOGIC;
signal start_padding_out : STD_LOGIC;
signal start_convolve_out : STD_LOGIC;
signal start_comm_out : STD_LOGIC;
signal select_comm_op_out : STD_LOGIC;
signal convolve_led_out : STD_LOGIC;
signal padding_led_out : STD_LOGIC;
signal receiving_led_out : STD_LOGIC;
signal sending_led_out : STD_LOGIC;


begin

uut1 : control_unit
    port map(clk => clk,
             rst_n => rst_n,
             padding_done_in => padding_done_in,
             convolve_done_in => convolve_done_in,
             comm_done_in => comm_done_in,
             start_op_in => start_op_in,
             finished_op_out => finished_op_out,
             enable_mux_padding_out => enable_mux_padding_out,
             enable_mux_convolve_out => enable_mux_convolve_out,
             enable_mux_comm_out => enable_mux_comm_out,
             start_padding_out => start_padding_out,
             start_convolve_out => start_convolve_out,
             start_comm_out => start_comm_out,
             select_comm_op_out => select_comm_op_out,
             receiving_led_out => receiving_led_out,
             convolve_led_out => convolve_led_out,
             padding_led_out => padding_led_out,
             sending_led_out => sending_led_out);


clk <= not clk after 5ns;

stimuli : process
    begin
        rst_n <= '1';
        padding_done_in <= '0';
        convolve_done_in <= '0';
        comm_done_in <= '0';
        start_op_in <= '0';
        wait for 5ns;
        rst_n <= '0';
        wait for 20ns;
        rst_n <= '1';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolve_out <= '0' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolve_out <= '0' and
        enable_mux_comm_out <= '0')
            report "Control output error (Idle output)"
            severity WARNING;
        start_op_in <= '1';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolve_out <= '0' and
        start_comm_out <= '1' and select_comm_op_out <= '1' and
        enable_mux_padding_out <= '0' and enable_mux_convolve_out <= '0' and
        enable_mux_comm_out <= '1')
            report "Control output error (Idle output with start signal)"
            severity WARNING;
        start_op_in <= '0';
        wait for 50ns;
        comm_done_in <= '1';
        wait for 10ns;
        comm_done_in <= '0';
        wait for 10ns;
        assert (start_padding_out <= '1' and start_convolve_out <= '0' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '1' and enable_mux_convolve_out <= '0' and
        enable_mux_comm_out <= '0')
            report "Control output error (Data_Receive output with comm_done signal)"
            severity WARNING;
        wait for 40ns;
        padding_done_in <= '1';
        wait for 10ns;
        padding_done_in <= '0';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolve_out <= '1' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolve_out <= '1' and
        enable_mux_comm_out <= '0')
            report "Control output error (Padding output with padding done signal)"
            severity WARNING;
        wait for 40ns;
        convolve_done_in <= '1';
        wait for 20ns;
        assert (start_padding_out <= '0' and start_convolve_out <= '0' and
        start_comm_out <= '1' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolve_out <= '0' and
        enable_mux_comm_out <= '1')
            report "Control output error (Convolving output with convolve_done signal)"
            severity WARNING;
        wait for 40ns;
        comm_done_in <= '1';
        wait for 10ns;
        comm_done_in <= '0';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolve_out <= '0' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolve_out <= '0' and
        enable_mux_comm_out <= '0')
            report "Control output error (Data_Sending output with comm_done signal)"
            severity WARNING;
        wait;
    end process;
end Behavioral;