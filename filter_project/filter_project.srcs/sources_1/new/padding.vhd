----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2020 10:20:15 AM
-- Design Name: 
-- Module Name: padding - Behavioral
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

entity padding is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC; --start padding
           data_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);--data taken from input ram
           finished : out STD_LOGIC;  --padding finished
           input_write_en : out STD_LOGIC_VECTOR(0 DOWNTO 0);  --write enable port for input ram
           input_address : out STD_LOGIC_VECTOR(9 DOWNTO 0);  --address to input ram
           output_address : out STD_LOGIC_VECTOR(9 DOWNTO 0); --address to padded image ram
           output_write_en : out STD_LOGIC_VECTOR(0 DOWNTO 0); --write enable port for padded image ram
           data_out : out STD_LOGIC_VECTOR(7 DOWNTO 0)); --data to write in padded image ram
end padding;

architecture Behavioral of padding is

begin
process ( clk, reset )
    constant waiting_time : integer := 6;--latency for waiting to take data after setting the input address
    variable row : integer := 0; --current row
    variable row_v : integer := 0; --another current row variable
    variable column : integer := 0; --current column
    variable time_left : integer := waiting_time;--time left for reading next data or writing next data
    variable corner : integer := 1; --corner of the image
    variable started : STD_LOGIC := '0'; --padding started state
    variable input_address_base : unsigned (9 downto 0):= "0000000000";--base address of input/output ram.
    variable padded_address_base : unsigned (9 downto 0) := "0000000000";--base address of padding ram.
    variable input_value : STD_LOGIC_VECTOR (7 downto 0) := "00000000";--pixel value read from input/output ram.
    variable start_original_pixels : STD_LOGIC := '0';--start copying original image pixels.
    variable start_border_pixels : STD_LOGIC := '0';--start copying the border pixels for padding
    begin
        if ( reset = '0' ) then --active low resewt is used
            row := 0;
            row_v := 0;
            column := 0;
            time_left := waiting_time;
            corner := 1;
            started := '0';
            input_address_base := "0000000000";
            padded_address_base := "0000000000";
            input_value := "00000000";
            input_write_en <= "0";
        elsif ( clk 'event and clk = '1' ) then
            if ( start = '1' and started = '0' ) then
                --mark started state as 1 upone receiving start signal.
                started := '1';
                start_original_pixels := '1';
                input_write_en <= "0";
            elsif ( started = '1') then
                if ( start_original_pixels = '1') then
                    if ( row /= 25 ) then
                        if ( column /= 25 ) then
                            if ( time_left = waiting_time ) then
                                input_address <= STD_LOGIC_VECTOR(input_address_base + (row * 25) + column);
                                time_left := time_left - 1;
                            elsif ( time_left = 3) then
                                input_value := data_in;
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + ((row + 1) * 27) + column + 1);
                                data_out <= input_value;
                                output_write_en <= "1";
                                time_left := time_left - 1;
                            elsif ( time_left = 0) then
                                output_write_en <= "0";
                                column := column + 1;
                                time_left := waiting_time;
                            else
                                output_write_en <= "0";
                                time_left := time_left - 1;
                            end if;
                        else
                            column := 0;
                            row := row + 1;
                        end if;
                    else
                        start_original_pixels := '0';
                        start_border_pixels := '1';
                        column := 0;
                        row := 0;
                        time_left := waiting_time;
                    end if;
                elsif (start_border_pixels = '1') then
                    if ( row /= 25 ) then
                        if (time_left = waiting_time) then
                            input_address <= STD_LOGIC_VECTOR(input_address_base + (row * 25) + column);
                            time_left := time_left - 1;
                        elsif (time_left = 3) then
                            if (column = 0) then
                                input_value := data_in;
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + ((row + 1) * 27) + column);
                                data_out <= input_value;
                                output_write_en <= "1";
                                time_left := time_left - 1;
                                column := 24;
                            elsif (column = 24) then
                                input_value := data_in;
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + ((row + 1) * 27) + column + 2);
                                data_out <= input_value;
                                output_write_en <= "1";
                                time_left := time_left - 1;
                                column := 0;
                                row := row + 1;
                            end if;   
                        elsif (time_left = 0) then
                            time_left := waiting_time;
                        else
                            output_write_en <= "0";
                            time_left := time_left - 1;
                        end if;
                    elsif(column /= 25) then
                        if (time_left = waiting_time) then
                            input_address <= STD_LOGIC_VECTOR(input_address_base + (row_v * 25) + column);
                            time_left := time_left - 1;
                        elsif (time_left = 3) then
                            if (row_v = 0) then
                                input_value := data_in;
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + column + 1);
                                data_out <= input_value;
                                output_write_en <= "1";
                                time_left := time_left - 1;
                                row_v := 24;
                            elsif (row_v = 24) then
                                input_value := data_in;
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + ((row_v + 2) * 27) + column + 1);
                                data_out <= input_value;
                                output_write_en <= "1";
                                time_left := time_left - 1;
                                row_v := 0;
                                column := column + 1;
                            end if;   
                        elsif (time_left = 0) then
                            time_left := waiting_time;
                        else
                            output_write_en <= "0";
                            time_left := time_left - 1;
                        end if;
                    elsif (corner /=5) then
                        if (time_left = waiting_time) then
                            if (corner = 1) then
                                input_address <= STD_LOGIC_VECTOR(input_address_base);
                            elsif (corner = 2) then
                                input_address <= STD_LOGIC_VECTOR(input_address_base + 24);
                            elsif (corner = 3) then
                                input_address <= STD_LOGIC_VECTOR(input_address_base + 600);
                            elsif (corner = 4) then
                                input_address <= STD_LOGIC_VECTOR(input_address_base + 624);
                            end if;
                            time_left := time_left - 1;
                        elsif (time_left = 3) then
                            input_value := data_in;
                            if (corner = 1) then
                                output_address <= STD_LOGIC_VECTOR(padded_address_base);
                            elsif (corner = 2) then
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + 26);
                            elsif (corner = 3) then
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + 702);
                            elsif (corner = 4) then
                                output_address <= STD_LOGIC_VECTOR(padded_address_base + 728);
                            end if;  
                            data_out <= input_value;
                            output_write_en <= "1";
                            time_left := time_left - 1;
                            corner := corner + 1;
                        elsif (time_left = 0) then
                            time_left := waiting_time;
                        else
                            output_write_en <= "0";
                            time_left := time_left - 1;
                        end if;
                    else
                        start_border_pixels := '0';
                        finished <= '1';
                        started := '0';  
                        row := 0;
                        row_v := 0;
                        column := 0;  
                    end if;
                end if;
            end if;
        end if;
end process;

end Behavioral;
