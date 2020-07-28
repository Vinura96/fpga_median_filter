----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2020 11:58:03 AM
-- Design Name: 
-- Module Name: mux_for_rams_tb - Behavioral
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

entity mux_for_rams_tb is
--  Port ( );
end mux_for_rams_tb;

architecture Behavioral of mux_for_rams_tb is

component mux_for_rams is
    Port ( padding_en_in : in STD_LOGIC;
           convolve_en_in : in STD_LOGIC;
           ioi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_pu_in : in STD_LOGIC_VECTOR (9 downto 0);
           ioi_addra_convu_in : in STD_LOGIC_VECTOR (9 downto 0);
           padi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_pu_in : in STD_LOGIC_VECTOR (9 downto 0);
           padi_addra_convu_in : in STD_LOGIC_VECTOR (9 downto 0);
           ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out : out STD_LOGIC_VECTOR (9 downto 0);
           padi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_out : out STD_LOGIC_VECTOR (9 downto 0));
end component;

signal padding_en_in : STD_LOGIC;
signal convolve_en_in : STD_LOGIC;
signal ioi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_pu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_addra_convu_in : STD_LOGIC_VECTOR (9 downto 0);
signal padi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padi_addra_pu_in : STD_LOGIC_VECTOR (9 downto 0);
signal padi_addra_convu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_out : STD_LOGIC_VECTOR (9 downto 0);
signal padi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal padi_addra_out : STD_LOGIC_VECTOR (9 downto 0);

begin

uut1 : mux_for_rams
    port map (padding_en_in => padding_en_in,
              convolve_en_in => convolve_en_in,
              ioi_wea_pu_in => ioi_wea_pu_in,
              ioi_wea_convu_in => ioi_wea_convu_in,
              ioi_addra_pu_in => ioi_addra_pu_in,
              ioi_addra_convu_in => ioi_addra_convu_in,
              padi_wea_pu_in => padi_wea_pu_in,
              padi_wea_convu_in => padi_wea_convu_in,
              padi_addra_pu_in => padi_addra_pu_in,
              padi_addra_convu_in => padi_addra_convu_in,
              ioi_wea_out => ioi_wea_out,
              ioi_addra_out => ioi_addra_out,
              padi_wea_out => padi_wea_out,
              padi_addra_out => padi_addra_out);

stimuli : process
    begin
        padding_en_in <= '0';
        convolve_en_in <= '0';
        ioi_wea_pu_in <= "0";
        ioi_wea_convu_in <= "0";
        ioi_addra_pu_in <= "0000100000";
        ioi_addra_convu_in <= "0010000001";
        padi_wea_pu_in <= "0";
        padi_wea_convu_in <= "0";
        padi_addra_pu_in <= "0000100001";
        padi_addra_convu_in <= "0100010000";
        wait for 10ns;
        padding_en_in <= '1';
        wait for 20ns;
        padding_en_in <= '0';
        convolve_en_in <= '1';
        wait for 40ns;
        padding_en_in <= '0';
        convolve_en_in <= '0';
        wait for 20ns;
        padding_en_in <= '1';
        convolve_en_in <= '1';
        wait;
    end process;
end Behavioral;
