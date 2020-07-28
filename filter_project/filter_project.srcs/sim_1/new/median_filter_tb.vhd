----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2020 01:55:34 PM
-- Design Name: 
-- Module Name: median_filter_tb - Behavioral
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
use std.textio.all;
use IEEE.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity median_filter_tb is
--  Port ( );
end median_filter_tb;

architecture Behavioral of median_filter_tb is

component median_filter is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           start_in : in STD_LOGIC;
           --wea_to_ioi : inout STD_LOGIC_VECTOR(0 DOWNTO 0);
           --dina_to_ioi : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
           --addra_to_ioi : inout STD_LOGIC_VECTOR (9 DOWNTO 0);
           finished_out : out STD_LOGIC );
end component;

signal clk : STD_LOGIC := '0';
signal rst_n :STD_LOGIC;
signal start_in : STD_LOGIC;
signal finished_out : STD_LOGIC;

begin
uut1 : median_filter
    port map(clk => clk,
            rst_n => rst_n,
            start_in => start_in,
            finished_out => finished_out);

clk <= not clk after 5ns;

stimuli : process
    begin
        rst_n <= '1';
        start_in <= '0';
        wait for 5ns;
        start_in <= '1';
        wait for 10ns;
        start_in <= '0';
        wait;
    end process;
    


end Behavioral;
