----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 03:18:58 PM
-- Design Name: 
-- Module Name: padding_tb - Behavioral
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

entity padding_tb is
--  Port ( );
end padding_tb;

architecture Behavioral of padding_tb is

component padding is
    Generic (addr_len         : Integer := 10;
             data_size           : Integer := 8;
             input_image_len  : Integer := 25;
             output_image_len : Integer := 27);
             
    Port ( clk            : in STD_LOGIC;
           reset          : in STD_LOGIC;
           start       : in STD_LOGIC;
           finished   : out STD_LOGIC;
           ioi_wea_out    : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           ioi_addra_out  : out STD_LOGIC_VECTOR(addr_len -1 DOWNTO 0);
           ioi_douta_in   : in STD_LOGIC_VECTOR(data_size -1 DOWNTO 0);
           padi_wea_out   : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           padi_addra_out : out STD_LOGIC_VECTOR(addr_len -1 DOWNTO 0);
           padi_dina_out  : out STD_LOGIC_VECTOR(data_size -1 DOWNTO 0);
           padi_web_out   : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           padi_addrb_out : out STD_LOGIC_VECTOR(addr_len -1 DOWNTO 0);
           padi_dinb_out  : out STD_LOGIC_VECTOR(data_size -1 DOWNTO 0));
end component;

component input_output_ram is
    Port ( clka  : IN STD_LOGIC;
           wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
           dina  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component pad_conv_ram is
  port (clka  : IN STD_LOGIC;
        wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkb  : IN STD_LOGIC;
        web   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

signal clk : STD_LOGIC := '0';
signal rst_n : STD_LOGIC;
signal start_p : STD_LOGIC;
signal finished : STD_LOGIC;
signal ioi_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal ioi_addra : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal ioi_dina_dont_care : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ioi_douta : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal padi_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal padi_addra : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal padi_dina : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal padi_douta : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal padi_web : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal padi_addrb : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal padi_dinb : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal padi_doutb : STD_LOGIC_VECTOR(7 DOWNTO 0);

constant clock_period: time := 1 ns;
signal stop_the_clock: boolean := false;

begin

uut_1 : padding
    port map (clk => clk,
              reset => rst_n,
              start =>  start_p,
              finished => finished,
              ioi_wea_out => ioi_wea,
              ioi_addra_out => ioi_addra,
              ioi_douta_in => ioi_douta,
              padi_wea_out => padi_wea,
              padi_addra_out => padi_addra,
              padi_dina_out => padi_dina,
              padi_web_out => padi_web,
              padi_addrb_out => padi_addrb,
              padi_dinb_out => padi_dinb
              );

uut_2 : input_output_ram
    port map (clka => clk,
              wea => ioi_wea,
              addra => ioi_addra,
              dina => ioi_dina_dont_care,
              douta => ioi_douta);

uut_3 : pad_conv_ram
  port map (clka => clk,
            wea => padi_wea,
            addra => padi_addra,
            dina => padi_dina,
            douta => padi_douta,
            clkb => clk,
            web => padi_web,
            addrb => padi_addrb,
            dinb => padi_dinb,
            doutb => padi_doutb);

stimulus: process
  begin
    rst_n <= '1';
    start_p <= '0';
    wait for 2ns;
    start_p <= '1';
    wait for 10ns;
    start_p <= '0';
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end Behavioral;
