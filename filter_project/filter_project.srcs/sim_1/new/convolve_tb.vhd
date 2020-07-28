----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2020 11:25:49 PM
-- Design Name: 
-- Module Name: convolve_tb - Behavioral
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

entity convolve_tb is
--  Port ( );
end convolve_tb;

architecture Behavioral of convolve_tb is
component convolve is
    Generic (addr_bit_size : INTEGER := 9;   -- image has less than 1024 pixels.
             data_bit_size : INTEGER := 7);   -- value range of a pixel (0-255)
             
    Port ( data_a_in : in STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);       -- data from the padded image ram.
           data_a_out : out STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);     -- data to final output image ram.
           clk  : in STD_LOGIC;                                           -- clock
           read_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0);  -- address to padded image ram  
           write_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0); -- address to the final output image ram
           write_en_io_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);             -- write enable pin to the output ram 
           write_en_pad_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);             -- write enable pin to the padded image ram.
           pad_done_in : in STD_LOGIC;                                     -- padding is done.
           conv_done_out : out STD_LOGIC;                             -- concolution is done.
           reset_in :in STD_LOGIC );  
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
    
  signal clk: STD_LOGIC :='0';
  signal reset_in: STD_LOGIC;
  signal paddone_in: STD_LOGIC;
  signal convdone_out: STD_LOGIC;
  signal wea_to_ioi : STD_LOGIC_VECTOR (0 DOWNTO 0):= "0";
  signal addra_to_ioi : STD_LOGIC_VECTOR (9 DOWNTO 0);
  signal dina_to_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal wea_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0):= "0";
  signal addra_to_padi : STD_LOGIC_VECTOR (9 DOWNTO 0);
  signal temp_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal douta_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal douta_from_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
  

  constant clock_period: time := 2 ns;
  signal stop_the_clock: boolean;

begin
uut_2: convolve port map (  data_a_in         => douta_from_padi,
                          clk             => clk,
                          reset_in           => reset_in,
                          pad_done_in           => paddone_in,
                          conv_done_out        => convdone_out,
                          write_en_pad_out   => wea_to_padi,
                          read_addr_out   => addra_to_padi,
                          write_addr_out  => addra_to_ioi,
                          write_en_io_out => wea_to_ioi,
                          data_a_out        => dina_to_ioi );
  input_output_ram_2 : input_output_ram
    port map (clka => clk,
              wea => wea_to_ioi,
              addra => addra_to_ioi,
              dina => dina_to_ioi,
              douta => douta_from_ioi);

  padded_image_ram_2 : pad_col_ram
    port map (clka => clk,
              wea => wea_to_padi,
              addra => addra_to_padi,
              dina => "00000000",
              douta => douta_from_padi);
              
  clk <= not clk after 2ns;

stimuli : process
    begin
        paddone_in <= '0';
        wait for 2ns;
        paddone_in <= '1';
        wait;
    end process;
    
dump_to_text : process (clk)
    variable out_value : line;
    file padded_ram : text is out "convol_ram.txt";
    begin
        if ( clk 'event and clk = '1' ) then
            if ( wea_to_ioi = "1" ) then
                write(out_value, to_integer(unsigned(addra_to_ioi)), left, 3);
                write(out_value, string'(","));
                write(out_value, to_integer(unsigned(dina_to_ioi)), left, 3);
                writeline(padded_ram, out_value);
            end if;
            if ( convdone_out = '1' ) then
                file_close(padded_ram);
            end if;
        end if;
  end process;

end Behavioral;
