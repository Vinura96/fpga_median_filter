----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2020 10:28:22 AM
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
use std.textio.all;
use IEEE.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity padding_tb is
--  Port ( );
end padding_tb;

architecture Behavioral of padding_tb is
component padding
      Port ( clk : in STD_LOGIC;
             reset : in STD_LOGIC;
             start : in STD_LOGIC;
             data_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
             finished : out STD_LOGIC;
             input_write_en : out STD_LOGIC_VECTOR(0 DOWNTO 0);
             input_address : out STD_LOGIC_VECTOR(9 DOWNTO 0);
             output_address : out STD_LOGIC_VECTOR(9 DOWNTO 0);
             output_write_en : out STD_LOGIC_VECTOR(0 DOWNTO 0);
             data_out : out STD_LOGIC_VECTOR(7 DOWNTO 0));
  end component;
  
  component input_output_ram is
    Port ( clka : IN STD_LOGIC;
           wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
           dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  end component;
    
  component pad_col_ram is
    Port ( clka : IN STD_LOGIC;
           wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
           dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  end component;
    
  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal start: STD_LOGIC;
  signal finished: STD_LOGIC;
  signal write_en_ioram : STD_LOGIC_VECTOR (0 DOWNTO 0);
  signal addr_to_ioram : STD_LOGIC_VECTOR (9 DOWNTO 0);
  signal data_from_ioram : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal data_to_ioram : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal write_en_padram : STD_LOGIC_VECTOR (0 DOWNTO 0);
  signal addr_to_padram : STD_LOGIC_VECTOR (9 DOWNTO 0);
  signal data_to_padram : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal data_from_padram : STD_LOGIC_VECTOR (7 DOWNTO 0);

  constant clock_period: time := 2 ns;
  signal stop_the_clock: boolean := false;
  
begin
  uut: padding port map ( clk             => clk,
                          reset           => reset,
                          start           => start,
                          data_in         => data_from_ioram,
                          finished        => finished,
                          input_write_en  => write_en_ioram,
                          input_address   => addr_to_ioram,
                          output_address  => addr_to_padram,
                          output_write_en => write_en_padram,
                          data_out        => data_to_padram );
  input_output_ram_1 : input_output_ram
    port map (clka => clk,
              wea => write_en_ioram,
              addra => addr_to_ioram,
              dina => data_to_ioram,
              douta => data_from_ioram);

  padded_image_ram_2 : pad_col_ram
    port map (clka => clk,
              wea => write_en_padram,
              addra => addr_to_padram,
              dina => data_to_padram,
              douta => data_from_padram);
  stimulus: process
  begin
    reset <= '1';
    start <= '0';
    wait for 2ns;
    start <= '1';
    wait for 10ns;
    start <= '0';
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
  
  dump_to_text : process (clk)
    variable out_value : line;
    file padded_ram : text is out "convolved_ram.txt";
    begin
        if ( clk 'event and clk = '1' ) then
            if ( write_en_padram = "1" ) then
                write(out_value, to_integer(unsigned(addr_to_padram)), left, 3);
                write(out_value, string'(","));
                write(out_value, to_integer(unsigned(data_to_padram)), left, 3);
                writeline(padded_ram, out_value);
            end if;
            if ( finished = '1' ) then
                file_close(padded_ram);
            end if;
        end if;
  end process;

end Behavioral;
