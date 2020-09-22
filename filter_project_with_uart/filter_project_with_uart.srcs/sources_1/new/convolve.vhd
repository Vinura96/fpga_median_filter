----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 11:36:13 PM
-- Design Name: 
-- Module Name: convolve - Behavioral
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

entity convolve is
Generic (    addr_bit_size : INTEGER := 9;   -- image has less than 1024 pixels.
             data_bit_size : INTEGER := 7);   -- value range of a pixel (0-255)
             
    Port ( data_a_in : in STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);       -- data in bus from the padded image ram.
           data_a_out : out STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);     -- data out bus to final output image ram.
           clk  : in STD_LOGIC;                                           -- clock
           read_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0);  -- address to padded image ram   
           write_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0); -- address to the final output image ram
           write_en_io_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);             -- write enable pin to the output ram . 
           write_en_pad_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);             -- write enable pin to the padded image ram.
           pad_done_in : in STD_LOGIC;                                     -- padding is done.
           conv_done_out : out STD_LOGIC:= '0';                             -- concolution is done.
           reset_in :in STD_LOGIC );
end convolve;

architecture Behavioral of convolve is

begin
 convolve : process ( clk, reset_in, data_a_in, pad_done_in )
     variable image_width      : INTEGER := 27;  --number of rows or columnspixel address where the convolved value is going to be placed.
     variable convol_addr   : INTEGER := 0;   --pixel address where convolved value is pasted
     variable edge_pixel_v   : INTEGER := image_width+1; -- pixel address in the padded image ram.
     variable cur_col_v      : INTEGER := 1;     --column number
     variable control    : INTEGER := 0; -- for controling the middle kernel values and last kernel of pixels
     variable temp        : unsigned (data_bit_size downto 0) := "00000000";--temp value used to hold input data values of padded ram
     variable temp1        : unsigned (data_bit_size downto 0) := "00000000"; --used when sorting pixel values
     variable median        : unsigned (data_bit_size downto 0) := "00000000"; --median value will be assigned
     variable p1        : unsigned (data_bit_size downto 0) := "00000000";--9 pixel values of a kernel is stored first for sorting
     variable p2        : unsigned (data_bit_size downto 0) := "00000000";
     variable p3        : unsigned (data_bit_size downto 0) := "00000000";
     variable p4        : unsigned (data_bit_size downto 0) := "00000000";
     variable p5        : unsigned (data_bit_size downto 0) := "00000000";
     variable p6        : unsigned (data_bit_size downto 0) := "00000000";
     variable p7        : unsigned (data_bit_size downto 0) := "00000000";
     variable p8        : unsigned (data_bit_size downto 0) := "00000000";
     variable p9        : unsigned (data_bit_size downto 0) := "00000000";
     variable cur_pix_kern :INTEGER :=0; --current iteration of a single kernal*window (0-9)
    begin
        if (reset_in = '0') then
            convol_addr := 0;
            edge_pixel_v := image_width+1;
            cur_col_v    := 1;
            control  := 0;
            temp      := "00000000";
            cur_pix_kern := 0;
            conv_done_out <= '0';
            write_en_pad_out <= "0";
        elsif ( clk 'event and clk = '1' ) then
            if pad_done_in = '1' then
                write_en_pad_out <= "0";
                if (control=0 or control=1) then
                    read_addr_out<=std_logic_vector(to_unsigned(control,read_addr_out'length)); -- assign the reading address of first two pixels
                    control:=control+1;
                    cur_pix_kern:=cur_pix_kern+1;
                elsif control=2 then  -- 2 nd pixel to last pixel of the image.
                    temp:= resize(unsigned(data_a_in),temp'length);--hold temporary the data in pixels read
                    case cur_pix_kern IS  -- for earch iteration of calculating the total, corresponding read_addr_out will be set using  edge_pixel_v, image_width &
                        --pixel values are assigned considering the two clock latency of reading data
                        when 0 =>
                            p7 := temp;--pixel 7 of a kernel                    
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v-(image_width+1),read_addr_out'length));
                        when 1 =>
                            p8 := temp;--pixel 8 of a kernel 
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v-image_width,read_addr_out'length));
                        when 2 =>
                            p9 := temp;--pixel 9 of a kernel 
                            if edge_pixel_v > image_width + 1 then--check whether a full kernel of pixels were read
                                --starting triple input sorter for pixels 1,4,7
                                if (p1 > p4) then
                                    temp1 := p1;
                                    p1 := p4;
                                    p4 := temp1;
                                end if;
                                if (p4 > p7) then
                                    temp1 := p4;
                                    p4 := p7;
                                    p7 := temp1;
                                end if;
                                if (p1 > p4) then
                                    temp1 := p1;
                                    p1 := p4;
                                    p4 := temp1;
                                end if;
                                --starting triple input sorter for pixels 2,5,8
                                if (p2 > p5) then
                                    temp1 := p2;
                                    p2 := p5;
                                    p5 := temp1;
                                end if;
                                if (p5 > p8) then
                                    temp1 := p5;
                                    p5 := p8;
                                    p8 := temp1;
                                end if;
                                if (p2 > p5) then
                                    temp1 := p2;
                                    p2 := p5;
                                    p5 := temp1;
                                end if;
                                --starting triple input sorter for pixels 3,6,9
                                if (p3 > p6) then
                                    temp1 := p3;
                                    p3 := p6;
                                    p6 := temp1;
                                end if;
                                if (p6 > p9) then
                                    temp1 := p6;
                                    p6 := p9;
                                    p9 := temp1;
                                end if;
                                if (p3 > p6) then
                                    temp1 := p3;
                                    p3 := p6;
                                    p6 := temp1;
                                end if;
                                --sorting to find the maximum from pixel 1,2,3 - maximum will be v3
                                if (p1 > p2) then
                                    temp1 := p1;
                                    p1 := p2;
                                    p2 := temp1;
                                end if;
                                if (p2 > p3) then
                                    temp1 := p2;
                                    p2 := p3;
                                    p3 := temp1;
                                end if;
                                if (p1 > p2) then
                                    temp1 := p1;
                                    p1 := p2;
                                    p2 := temp1;
                                end if;
                                --sorting to find the median from pixel 4,5,6 - median will be v5
                                if (p4 > p5) then
                                    temp1 := p4;
                                    p4 := p5;
                                    p5 := temp1;
                                end if;
                                if (p5 > p6) then
                                    temp1 := p5;
                                    p5 := p6;
                                    p6 := temp1;
                                end if;
                                if (p4 > p5) then
                                    temp1 := p4;
                                    p4 := p5;
                                    p5 := temp1;
                                end if;
                                --sorting to find the minimum from pixel 7,8,9 - minimum will be v7
                                if (p7 > p8) then
                                    temp1 := p7;
                                    p7 := p8;
                                    p8 := temp1;
                                end if;
                                if (p8 > p9) then
                                    temp1 := p8;
                                    p8 := p9;
                                    p9 := temp1;
                                end if;
                                if (p7 > p8) then
                                    temp1 := p7;
                                    p7 := p8;
                                    p8 := temp1;
                                end if;
                                --finding the final median value - p5
                                if (p3 > p5) then
                                    temp1 := p3;
                                    p3 := p5;
                                    p5 := temp1;
                                end if;
                                if (p5 > p7) then
                                    temp1 := p5;
                                    p5 := p7;
                                    p7 := temp1;
                                end if;
                                if (p3 > p5) then
                                    temp1 := p3;
                                    p3 := p5;
                                    p5 := temp1;
                                end if;
                                median := p5; 
                                write_addr_out<=std_logic_vector(to_unsigned(convol_addr,write_addr_out'length)); -- assign the write address of the current pixel of final image ram
                                data_a_out<=std_logic_vector(resize(median,data_a_out'length)); -- assign the averaged value to data_a_out
                                write_en_io_out<= "1"; -- enable the write_en for input ram.
                                convol_addr:=convol_addr+1; -- increase convol_addr by 1.
                            end if;
                            temp:= "00000000";   -- make the total 0 after the output 
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v-(image_width-1),read_addr_out'length));
                        when 3 =>
                            p1 := temp;    --pixel 1 of a kernel                 
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v-1,read_addr_out'length));
                            write_en_io_out<= "0";
                            median:= "00000000";
                        when 4 =>
                            p2 := temp;   --pixel 2 of a kernel                  
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v,read_addr_out'length));
                        when 5 => 
                            p3 := temp;   --pixel 3 of a kernel                 
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v+1,read_addr_out'length));
                        when 6 =>
                            p4 := temp;   --pixel 4 of a kernel                 
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v+(image_width-1),read_addr_out'length));
                        when 7 =>
                            p5 := temp;   --pixel 5 of a kernel                 
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v+image_width,read_addr_out'length));
                        when 8 =>
                            p6 := temp;    --pixel 6 of a kernel                
                            read_addr_out<=std_logic_vector(to_unsigned(edge_pixel_v+(image_width+1),read_addr_out'length));
                        when others =>
                    end case;                                                                                                                                                                                                                                  
                    if cur_pix_kern =8 then -- address setting of a single kernel is done.
                        cur_pix_kern:=0;  -- assign cur_pix_kern 0
                        if cur_col_v=image_width-2 then -- check whether the current column is the second last.
                            if edge_pixel_v=(image_width*image_width-(image_width+2)) then  -- check for last pixel
                                control:=3;  -- assign control 3. 
                            else
                                edge_pixel_v:=edge_pixel_v+3;   -- move to the next pixel
                                cur_col_v:=1; 
                            end if;
                        else
                            edge_pixel_v:=edge_pixel_v+1; -- inccrease edge_pixel_v by 1. 
                            cur_col_v:=cur_col_v+1; 
                        end if;
                    else
                        cur_pix_kern:=cur_pix_kern+1; -- increase cur_pix_kern by 1
                    end if;
                elsif control=3 or control=4 or control=5 then
                    temp:= resize(unsigned(data_a_in),temp'length);
                    case control IS  -- for earch iteration of calculating the total, corresponding read_addr_out will be set using  edge_pixel_v, image_width &
                        --last three pixels of the image
                        when 3 =>
                            p7 := temp;
                        when 4 =>
                            p8 := temp;
                        when 5 =>
                            p9 := temp;
                        when others =>
                    end case;
                    control:=control+1;
                elsif control=6 then --finding median of last kernel
                    if (p1 > p4) then
                        temp1 := p1;
                        p1 := p4;
                        p4 := temp1;
                    end if;
                    if (p4 > p7) then
                        temp1 := p4;
                        p4 := p7;
                        p7 := temp1;
                    end if;
                    if (p1 > p4) then
                        temp1 := p1;
                        p1 := p4;
                        p4 := temp1;
                    end if;
                    --starting triple input sorter pixel 2,5,8
                    if (p2 > p5) then
                        temp1 := p2;
                        p2 := p5;
                        p5 := temp1;
                    end if;
                    if (p5 > p8) then
                        temp1 := p5;
                        p5 := p8;
                        p8 := temp1;
                    end if;
                    if (p2 > p5) then
                        temp1 := p2;
                        p2 := p5;
                        p5 := temp1;
                    end if;
                    --starting triple input sorter pixel 3,6,9
                    if (p3 > p6) then
                        temp1 := p3;
                        p3 := p6;
                        p6 := temp1;
                    end if;
                    if (p6 > p9) then
                        temp1 := p6;
                        p6 := p9;
                        p9 := temp1;
                    end if;
                    if (p3 > p6) then
                        temp1 := p3;
                        p3 := p6;
                        p6 := temp1;
                    end if;
                    --sorting to find the maximum from pixel 1,2,3 - maximum will be v3
                    if (p1 > p2) then
                        temp1 := p1;
                        p1 := p2;
                        p2 := temp1;
                    end if;
                    if (p2 > p3) then
                        temp1 := p2;
                        p2 := p3;
                        p3 := temp1;
                    end if;
                    if (p1 > p2) then
                        temp1 := p1;
                        p1 := p2;
                        p2 := temp1;
                    end if;
                    --sorting to find the median from pixel 4,5,6 - median will be v5
                    if (p4 > p5) then
                        temp1 := p4;
                        p4 := p5;
                        p5 := temp1;
                    end if;
                    if (p5 > p6) then
                        temp1 := p5;
                        p5 := p6;
                        p6 := temp1;
                    end if;
                    if (p4 > p5) then
                        temp1 := p4;
                        p4 := p5;
                        p5 := temp1;
                    end if;
                    --sorting to find the minimum from pixel 7,8,9 - minimum will be v7
                    if (p7 > p8) then
                        temp1 := p7;
                        p7 := p8;
                        p8 := temp1;
                    end if;
                    if (p8 > p9) then
                        temp1 := p8;
                        p8 := p9;
                        p9 := temp1;
                    end if;
                    if (p7 > p8) then
                        temp1 := p7;
                        p7 := p8;
                        p8 := temp1;
                    end if;
                    --finding the final median value - v5
                    if (p3 > p5) then
                        temp1 := p3;
                        p3 := p5;
                        p5 := temp1;
                    end if;
                    if (p5 > p7) then
                        temp1 := p5;
                        p5 := p7;
                        p7 := temp1;
                    end if;
                    if (p3 > p5) then
                        temp1 := p3;
                        p3 := p5;
                        p5 := temp1;
                    end if;
                    median := p5;
                    write_addr_out<=std_logic_vector(to_unsigned(convol_addr,write_addr_out'length)); 
                    data_a_out<=std_logic_vector(resize(median,data_a_out'length));
                    write_en_io_out<="1";
                    control:=control+1;
                elsif control=7 then
                    write_en_io_out <= "0";
                    median:= "00000000";
                    conv_done_out<='1';
                    control:=8;
                end if;
            end if;         
        end if;
end process;

end Behavioral;
