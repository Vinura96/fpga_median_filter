----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 02:57:37 PM
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
    Generic (addr_length_g : Integer := 10;
             data_size_g : Integer := 8);
             
    Port ( padding_en_in : in STD_LOGIC;
           convolve_en_in : in STD_LOGIC;
           comm_en_in : in STD_LOGIC;
           ioi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_comm_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_pu_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_addra_convu_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_addra_comm_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_dina_convu_in : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           ioi_dina_comm_in : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           padi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_pu_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           padi_addra_convu_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_dina_out : out STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           padi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_out : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0));
end component;

signal padding_en_in : STD_LOGIC;
signal convolve_en_in : STD_LOGIC;
signal comm_en_in : STD_LOGIC;
signal ioi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_wea_comm_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_pu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_addra_convu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_addra_comm_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_dina_convu_in : STD_LOGIC_VECTOR (7 downto 0);
signal ioi_dina_comm_in : STD_LOGIC_VECTOR (7 downto 0);
signal padi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padi_addra_pu_in : STD_LOGIC_VECTOR (9 downto 0);
signal padi_addra_convu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_out : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_dina_out : STD_LOGIC_VECTOR (7 downto 0);
signal padi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal padi_addra_out : STD_LOGIC_VECTOR (9 downto 0);

begin

uut1 : mux_for_rams
    port map (padding_en_in => padding_en_in,
              convolve_en_in => convolve_en_in,
              comm_en_in => comm_en_in,
              ioi_wea_pu_in => ioi_wea_pu_in,
              ioi_wea_convu_in => ioi_wea_convu_in,
              ioi_wea_comm_in => ioi_wea_comm_in,
              ioi_addra_pu_in => ioi_addra_pu_in,
              ioi_addra_convu_in => ioi_addra_convu_in,
              ioi_addra_comm_in => ioi_addra_comm_in,
              ioi_dina_convu_in => ioi_dina_convu_in,
              ioi_dina_comm_in => ioi_dina_comm_in,
              padi_wea_pu_in => padi_wea_pu_in,
              padi_wea_convu_in => padi_wea_convu_in,
              padi_addra_pu_in => padi_addra_pu_in,
              padi_addra_convu_in => padi_addra_convu_in,
              ioi_wea_out => ioi_wea_out,
              ioi_addra_out => ioi_addra_out,
              ioi_dina_out => ioi_dina_out,
              padi_wea_out => padi_wea_out,
              padi_addra_out => padi_addra_out);

stimuli : process
    begin
        padding_en_in <= '0';
        convolve_en_in <= '0';
        comm_en_in <= '0';
        ioi_wea_pu_in <= "1";
        ioi_wea_convu_in <= "0";
        ioi_wea_comm_in <= "1";
        ioi_addra_pu_in <= "0000000010";
        ioi_addra_convu_in <= "0000000110";
        ioi_addra_comm_in <= "0000000011";
        ioi_dina_convu_in <= "11101010";
        ioi_dina_comm_in <= "10110011";
        padi_wea_pu_in <= "0";
        padi_wea_convu_in <= "1";
        padi_addra_pu_in <= "0000000010";
        padi_addra_convu_in <= "0000000111";
        wait for 10ns;
        padding_en_in <= '1';
        wait for 10ns;
        assert (ioi_addra_out = "0000000001" and ioi_wea_out = "1" and ioi_dina_out = "00000000" and padi_wea_out = "0" and padi_addra_out = "0000000001")
            report "Multiplexing Logic Error(pu enabled)"
            severity WARNING;
        wait for 30ns;
        padding_en_in <= '0';
        convolve_en_in <= '1';
        comm_en_in <= '0';
        wait for 10ns;
        assert (ioi_addra_out = "0000000010" and ioi_wea_out = "0" and ioi_dina_out = "10101010" and padi_wea_out = "1" and padi_addra_out = "0000000010")
            report "Multiplexing Logic Error(convu enabled)"
            severity WARNING;
        wait for 30ns;
        padding_en_in <= '0';
        convolve_en_in <= '0';
        comm_en_in <= '1';
        wait for 10ns;
        assert (ioi_addra_out = "0000000011" and ioi_wea_out = "1" and ioi_dina_out = "10111011" and padi_wea_out = "0" and padi_addra_out = "0000000000")
            report "Multiplexing Logic Error(comm enabled)"
            severity WARNING;
        wait for 30ns;
        padding_en_in <= '0';
        convolve_en_in <= '0';
        comm_en_in <= '0';
        wait for 10ns;
        assert (ioi_addra_out = "0000000000" and ioi_wea_out = "0" and ioi_dina_out = "00000000" and padi_wea_out = "0" and padi_addra_out = "0000000000")
            report "Multiplexing Logic Error(unintentional inputs)"
            severity WARNING;
        wait for 30ns;
        padding_en_in <= '1';
        convolve_en_in <= '1';
        comm_en_in <= '1';
        wait for 10ns;
        assert (ioi_addra_out = "0000000000" and ioi_wea_out = "0" and ioi_dina_out = "00000000" and padi_wea_out = "0" and padi_addra_out = "0000000000")
            report "Multiplexing Logic Error(unintentional inputs)"
            severity WARNING;
        wait;
    end process;
end Behavioral;
