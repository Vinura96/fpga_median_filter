----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 11:39:30 PM
-- Design Name: 
-- Module Name: mux_for_rams - Behavioral
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

entity mux_for_rams is
--  Port
    Generic (addr_length_g : Integer := 10; --size of the memory address(10bits)
             data_size_g   : Integer := 8); --size of the pixel data (8bits)
             
    Port ( --signal to enable inputs from padding unit.
           padding_en_in       : in STD_LOGIC;
           --signal to enable inputs from convolution unit.
           convolve_en_in      : in STD_LOGIC;
           --signal to enable inputs from uart communication unit.
           comm_en_in          : in STD_LOGIC;
           --write enable from padding unit to i/o ram.
           ioi_wea_pu_in       : in STD_LOGIC_VECTOR (0 downto 0);
           --write enable from convolution unit to i/o ram.
           ioi_wea_convu_in    : in STD_LOGIC_VECTOR (0 downto 0);
           --write enable from uart communication unit to i/o ram.
           ioi_wea_comm_in     : in STD_LOGIC_VECTOR (0 downto 0);
           --data address from padding unit to i/o ram.
           ioi_addra_pu_in     : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           --data address from convolution unit to i/o ram.
           ioi_addra_convu_in  : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           --data address from uart communication unit to i/o ram.
           ioi_addra_comm_in   : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           --data from convolution unit to i/o ram.
           ioi_dina_convu_in   : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           --data from uart communication unit to i/o ram.
           ioi_dina_comm_in    : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           --write enable from padding unit to padded ram port a.
           padi_wea_pu_in      : in STD_LOGIC_VECTOR (0 downto 0);
           --write enable from convolution unit to padded ram port a.
           padi_wea_convu_in   : in STD_LOGIC_VECTOR (0 downto 0);
           --data address from padding unit to padded ram port a.
           padi_addra_pu_in    : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           --data address from convolution unit to padded ram port a.
           padi_addra_convu_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           --write enable signal from mux to i/o ram.
           ioi_wea_out         : out STD_LOGIC_VECTOR (0 downto 0);
           --data address from mux to i/o ram.
           ioi_addra_out       : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           --data from mux to i/o ram.
           ioi_dina_out        : out STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           --write enable signal from mux to padded ram.
           padi_wea_out        : out STD_LOGIC_VECTOR (0 downto 0);
           --data address from mux to padded ram.
           padi_addra_out      : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0));
end mux_for_rams;

architecture Behavioral of mux_for_rams is

begin
    multiplex : process (padding_en_in, convolve_en_in, comm_en_in, ioi_wea_pu_in,
    ioi_wea_convu_in, ioi_wea_comm_in, ioi_addra_pu_in, ioi_addra_convu_in,
    ioi_addra_comm_in, ioi_dina_convu_in, ioi_dina_comm_in, padi_wea_pu_in,
    padi_wea_convu_in, padi_addra_pu_in, padi_addra_convu_in)
        begin
            if (padding_en_in = '1' and convolve_en_in = '0' and comm_en_in = '0') then
                -- if enable data from padding unit
                ioi_wea_out    <= ioi_wea_pu_in;
                ioi_addra_out  <= ioi_addra_pu_in;
                ioi_dina_out   <= std_logic_vector(to_unsigned(0, data_size_g));
                padi_wea_out   <= padi_wea_pu_in;
                padi_addra_out <= padi_addra_pu_in;
            elsif (padding_en_in = '0' and convolve_en_in = '1' and comm_en_in = '0') then
                -- if enable data from convolution unit
                ioi_wea_out    <= ioi_wea_convu_in;
                ioi_addra_out  <= ioi_addra_convu_in;
                ioi_dina_out   <= ioi_dina_convu_in;
                padi_wea_out   <= padi_wea_convu_in;
                padi_addra_out <= padi_addra_convu_in;
            elsif (padding_en_in = '0' and convolve_en_in = '0' and comm_en_in = '1') then
                -- if enable data from uart communication unit
                ioi_wea_out    <= ioi_wea_comm_in;
                ioi_addra_out  <= ioi_addra_comm_in;
                ioi_dina_out   <= ioi_dina_comm_in;
                padi_wea_out   <= "0";
                padi_addra_out <= std_logic_vector(to_unsigned(0, addr_length_g));
            else
                --when unintentional inputs
                ioi_wea_out    <= "0";
                ioi_addra_out  <= std_logic_vector(to_unsigned(0, addr_length_g));
                ioi_dina_out   <= std_logic_vector(to_unsigned(0, data_size_g));
                padi_wea_out   <= "0";
                padi_addra_out <= std_logic_vector(to_unsigned(0, addr_length_g));
            end if;
        end process multiplex;
end Behavioral;
