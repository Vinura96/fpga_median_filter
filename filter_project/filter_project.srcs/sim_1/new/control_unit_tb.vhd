----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2020 12:03:31 PM
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
           start_op_in : in STD_LOGIC;
           finished_op_out : out STD_LOGIC;
           enable_mux_padding_out : out STD_LOGIC;
           enable_mux_convolve_out : out STD_LOGIC;
           start_padding_out : out STD_LOGIC;
           start_convolve_out : out STD_LOGIC);
end component;

signal clk : STD_LOGIC := '0';
signal rst_n : STD_LOGIC;
signal padding_done_in : STD_LOGIC;
signal convolve_done_in : STD_LOGIC;
signal start_op_in : STD_LOGIC;
signal finished_op_out : STD_LOGIC;
signal enable_mux_padding_out : STD_LOGIC;
signal enable_mux_convolve_out : STD_LOGIC;
signal start_padding_out : STD_LOGIC;
signal start_convolve_out : STD_LOGIC;


begin

uut1 : control_unit
    port map(clk => clk,
             rst_n => rst_n,
             padding_done_in => padding_done_in,
             convolve_done_in => convolve_done_in,
             start_op_in => start_op_in,
             finished_op_out => finished_op_out,
             enable_mux_padding_out => enable_mux_padding_out,
             enable_mux_convolve_out => enable_mux_convolve_out,
             start_padding_out => start_padding_out,
             start_convolve_out => start_convolve_out);


clk <= not clk after 5ns;

stimuli : process
    begin
        rst_n <= '1';
        padding_done_in <= '0';
        convolve_done_in <= '0';
        start_op_in <= '0';
        wait for 10ns;
        start_op_in <= '1';
        wait for 10ns;
        start_op_in <= '0';
        wait for 10ns;
        padding_done_in <= '1';
        wait for 10ns;
        padding_done_in <= '0';
        wait for 10ns;
        convolve_done_in <= '1';
        wait;
    end process;
end Behavioral;
