----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2020 11:54:09 PM
-- Design Name: 
-- Module Name: median_filter - Behavioral
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

entity median_filter is
Port ( clk                    : in STD_LOGIC;
       main_rst_n             : in STD_LOGIC;
       start_in               : in STD_LOGIC;
       rx                     : in STD_LOGIC;
       tx                     : out STD_LOGIC;
       finished_out           : out STD_LOGIC;
       main_convolve_led_out  : out STD_LOGIC;
       main_padding_led_out   : out STD_LOGIC;
       main_receiving_led_out : out STD_LOGIC;
       main_sending_led_out   : out STD_LOGIC);
end median_filter;

architecture Behavioral of median_filter is

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

component convolve is
    Generic (addr_bit_size  : INTEGER := 9;
             data_bit_size  : INTEGER := 7);             
    
    Port ( data_a_in      : in STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);
           data_a_out     : out STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);
           clk            : in STD_LOGIC;
           read_addr_out  : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0);  
           write_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0); 
           write_en_io_out : out STD_LOGIC_VECTOR(0 DOWNTO 0); 
           write_en_pad_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           pad_done_in     : in STD_LOGIC;
           conv_done_out   : out STD_LOGIC;
           reset_in          : in STD_LOGIC );  
end component;

component control_unit is
    Port ( clk                     : in STD_LOGIC;
           rst_n                   : in STD_LOGIC;
           padding_done_in         : in STD_LOGIC;
           convolve_done_in        : in STD_LOGIC;
           comm_done_in            : in STD_LOGIC;
           start_op_in             : in STD_LOGIC;
           finished_op_out         : out STD_LOGIC;
           enable_mux_padding_out  : out STD_LOGIC;
           enable_mux_convolve_out : out STD_LOGIC;
           enable_mux_comm_out     : out STD_LOGIC;
           start_padding_out       : out STD_LOGIC;
           start_convolve_out      : out STD_LOGIC;
           start_comm_out          : out STD_LOGIC;
           select_comm_op_out      : out STD_LOGIC;
           convolve_led_out        : out STD_LOGIC;
           padding_led_out         : out STD_LOGIC;
           receiving_led_out       : out STD_LOGIC;
           sending_led_out       : out STD_LOGIC);
end component;

component mux_for_rams is
    Generic (addr_length_g : Integer := 10;
             data_size_g   : Integer := 8);
             
    Port ( padding_en_in       : in STD_LOGIC;
           convolve_en_in      : in STD_LOGIC;
           comm_en_in          : in STD_LOGIC;
           ioi_wea_pu_in       : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_convu_in    : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_comm_in     : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_pu_in     : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_addra_convu_in  : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_addra_comm_in   : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_dina_convu_in   : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           ioi_dina_comm_in    : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           padi_wea_pu_in      : in STD_LOGIC_VECTOR (0 downto 0);
           padi_wea_convu_in   : in STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_pu_in    : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           padi_addra_convu_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_wea_out         : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out       : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_dina_out        : out STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           padi_wea_out        : out STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_out      : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0));
end component;

component uart is
    Generic (mem_addr_size_g   : integer := 10;
             pixel_data_size_g : integer := 8;
             base_val          : integer := 0);

    Port ( clk                    : in STD_LOGIC;
           rst_n                  : in STD_LOGIC;
           start_op_in            : in STD_LOGIC;
           finished_op_out        : out STD_LOGIC;
           send_rec_select_in     : in STD_LOGIC;
           ioi_addra_out          : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0);
           ioi_dina_out           : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_douta_in           : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_wea_out            : out STD_LOGIC_VECTOR (0 downto 0);
           uart_interrupt_in      : in STD_LOGIC;
           uart_s_axi_awaddr_out  : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_awvalid_out : out STD_LOGIC;
           uart_s_axi_awready_in  : in STD_LOGIC;
           uart_s_axi_wdata_out   : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_wstrb_out   : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_wvalid_out  : out STD_LOGIC;
           uart_s_axi_wready_in   : in STD_LOGIC;
           uart_s_axi_bresp_in    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_bvalid_in   : in STD_LOGIC;
           uart_s_axi_bready_out  : out STD_LOGIC;
           uart_s_axi_araddr_out  : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_arvalid_out : out STD_LOGIC;
           uart_s_axi_arready_in  : in STD_LOGIC;
           uart_s_axi_rdata_in    : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_rresp_in    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_rvalid_in   : in STD_LOGIC;
           uart_s_axi_rready_out  : out STD_LOGIC);
end component;

component axi_uartlite_0 is
    Port (s_axi_aclk    : IN STD_LOGIC;
          s_axi_aresetn : IN STD_LOGIC;
          interrupt     : OUT STD_LOGIC;
          s_axi_awaddr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_awvalid : IN STD_LOGIC;
          s_axi_awready : OUT STD_LOGIC;
          s_axi_wdata   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axi_wstrb   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_wvalid  : IN STD_LOGIC;
          s_axi_wready  : OUT STD_LOGIC;
          s_axi_bresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          s_axi_bvalid  : OUT STD_LOGIC;
          s_axi_bready  : IN STD_LOGIC;
          s_axi_araddr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_arvalid : IN STD_LOGIC;
          s_axi_arready : OUT STD_LOGIC;
          s_axi_rdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axi_rresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          s_axi_rvalid  : OUT STD_LOGIC;
          s_axi_rready  : IN STD_LOGIC;
          rx            : IN STD_LOGIC;
          tx            : OUT STD_LOGIC);
end component;


signal start_padding_cu_to_pu : STD_LOGIC;
signal start_convolve_cu_to_convu : STD_LOGIC;
signal start_comm_cu_to_comm : STD_LOGIC;
signal select_comm_op_cu_to_comm : STD_LOGIC;
signal finished_pu_to_cu : STD_LOGIC;
signal finished_convu_to_cu : STD_LOGIC;
signal finished_comm_to_cu : STD_LOGIC;
signal enable_mux_padding_cu_to_mux : STD_LOGIC;
signal enable_mux_convolve_cu_to_mux : STD_LOGIC;
signal enable_mux_comm_cu_to_mux : STD_LOGIC;
signal wea_to_ioi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addra_to_ioi : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal dina_to_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal douta_from_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wea_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addra_to_padi : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal dina_to_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal douta_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal web_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addrb_to_padi : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal dinb_to_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal doutb_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal ioi_wea_pu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_pu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal ioi_wea_convu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_convu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal ioi_wea_comm_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_comm_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal ioi_dina_convu_to_mux : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal ioi_dina_comm_to_mux : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal padi_wea_pu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal padi_addra_pu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal padi_wea_convu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal padi_addra_convu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal interrupt_auu_to_comm : STD_LOGIC;
signal s_axi_awaddr_comm_to_auu : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_awvalid_comm_to_auu : STD_LOGIC;
signal s_axi_awready_auu_to_comm : STD_LOGIC;
signal s_axi_wdata_comm_to_auu : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axi_wstrb_comm_to_auu : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_wvalid_comm_to_auu : STD_LOGIC;
signal s_axi_wready_auu_to_comm : STD_LOGIC;
signal s_axi_bresp_auu_to_comm : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal s_axi_bvalid_auu_to_comm : STD_LOGIC;
signal s_axi_bready_comm_to_auu : STD_LOGIC;
signal s_axi_araddr_comm_to_auu : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_arvalid_comm_to_auu : STD_LOGIC;
signal s_axi_arready_auu_to_comm : STD_LOGIC;
signal s_axi_rdata_auu_to_comm : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axi_rresp_auu_to_comm : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal s_axi_rvalid_auu_to_comm : STD_LOGIC;
signal s_axi_rready_comm_to_auu : STD_LOGIC;

begin

input_output_ram_1 : input_output_ram
    port map (clka  => clk,
              wea   => wea_to_ioi,
              addra => addra_to_ioi,
              dina  => dina_to_ioi,
              douta => douta_from_ioi);

pad_conv_ram_1 : pad_conv_ram
  port map (clka  => clk,
            wea   => wea_to_padi,
            addra => addra_to_padi,
            dina  => dina_to_padi,
            douta => douta_from_padi,
            clkb  => clk,
            web   => web_to_padi,
            addrb => addrb_to_padi,
            dinb  => dinb_to_padi,
            doutb => doutb_from_padi);

padding_unit : padding
    port map (clk            => clk,
              reset          => main_rst_n,
              start      =>  start_padding_cu_to_pu,
              finished   => finished_pu_to_cu,
              ioi_wea_out    => ioi_wea_pu_to_mux,
              ioi_addra_out  => ioi_addra_pu_to_mux,
              ioi_douta_in   => douta_from_ioi,
              padi_wea_out   => padi_wea_pu_to_mux,
              padi_addra_out => padi_addra_pu_to_mux,
              padi_dina_out  => dina_to_padi,
              padi_web_out   => web_to_padi,
              padi_addrb_out => addrb_to_padi,
              padi_dinb_out  => dinb_to_padi);

convolution_unit : convolve
    port map(data_a_in      => douta_from_padi,
             clk            => clk,
             reset_in          => main_rst_n,
             pad_done_in     => start_convolve_cu_to_convu,
             data_a_out     => ioi_dina_convu_to_mux,
             write_en_io_out => ioi_wea_convu_to_mux,
             write_en_pad_out => padi_wea_convu_to_mux,
             read_addr_out  => padi_addra_convu_to_mux,
             write_addr_out => ioi_addra_convu_to_mux,
             conv_done_out   => finished_convu_to_cu);

control_unit_1 : control_unit
    port map(clk                     => clk,
             rst_n                   => main_rst_n,
             padding_done_in         => finished_pu_to_cu,
             convolve_done_in        => finished_convu_to_cu,
             comm_done_in            => finished_comm_to_cu,
             start_op_in             => start_in,
             finished_op_out         => finished_out,
             enable_mux_padding_out  => enable_mux_padding_cu_to_mux,
             enable_mux_convolve_out => enable_mux_convolve_cu_to_mux,
             enable_mux_comm_out     => enable_mux_comm_cu_to_mux,
             start_padding_out       => start_padding_cu_to_pu,
             start_convolve_out      => start_convolve_cu_to_convu,
             start_comm_out          => start_comm_cu_to_comm,
             select_comm_op_out      => select_comm_op_cu_to_comm,
             convolve_led_out        => main_convolve_led_out,
             padding_led_out         => main_padding_led_out,
             receiving_led_out       => main_receiving_led_out,
             sending_led_out         => main_sending_led_out);

mux_for_rams_1 : mux_for_rams
    port map (padding_en_in       => enable_mux_padding_cu_to_mux,
              convolve_en_in      => enable_mux_convolve_cu_to_mux,
              comm_en_in          => enable_mux_comm_cu_to_mux,
              ioi_wea_pu_in       => ioi_wea_pu_to_mux,
              ioi_wea_convu_in    => ioi_wea_convu_to_mux,
              ioi_wea_comm_in     => ioi_wea_comm_to_mux,
              ioi_addra_pu_in     => ioi_addra_pu_to_mux,
              ioi_addra_convu_in  => ioi_addra_convu_to_mux,
              ioi_addra_comm_in   => ioi_addra_comm_to_mux,
              ioi_dina_convu_in   => ioi_dina_convu_to_mux,
              ioi_dina_comm_in    => ioi_dina_comm_to_mux,
              padi_wea_pu_in      => padi_wea_pu_to_mux,
              padi_wea_convu_in   => padi_wea_convu_to_mux,
              padi_addra_pu_in    => padi_addra_pu_to_mux,
              padi_addra_convu_in => padi_addra_convu_to_mux,
              ioi_wea_out         => wea_to_ioi,
              ioi_addra_out       => addra_to_ioi,
              ioi_dina_out        => dina_to_ioi,
              padi_wea_out        => wea_to_padi,
              padi_addra_out      => addra_to_padi);

uart_communication_unit : uart
    port map (clk                    => clk,
              rst_n                  => main_rst_n,
              start_op_in            => start_comm_cu_to_comm,
              finished_op_out        => finished_comm_to_cu,
              send_rec_select_in     => select_comm_op_cu_to_comm,
              ioi_addra_out          => ioi_addra_comm_to_mux,
              ioi_douta_in           => douta_from_ioi,
              ioi_dina_out           => ioi_dina_comm_to_mux,
              ioi_wea_out            => ioi_wea_comm_to_mux,
              uart_interrupt_in      => interrupt_auu_to_comm,
              uart_s_axi_awaddr_out  => s_axi_awaddr_comm_to_auu,
              uart_s_axi_awvalid_out => s_axi_awvalid_comm_to_auu,
              uart_s_axi_awready_in  => s_axi_awready_auu_to_comm,
              uart_s_axi_wdata_out   => s_axi_wdata_comm_to_auu,
              uart_s_axi_wstrb_out   => s_axi_wstrb_comm_to_auu,
              uart_s_axi_wvalid_out  => s_axi_wvalid_comm_to_auu,
              uart_s_axi_wready_in   => s_axi_wready_auu_to_comm,
              uart_s_axi_bresp_in    => s_axi_bresp_auu_to_comm,
              uart_s_axi_bvalid_in   => s_axi_bvalid_auu_to_comm,
              uart_s_axi_bready_out  => s_axi_bready_comm_to_auu,
              uart_s_axi_araddr_out  => s_axi_araddr_comm_to_auu,
              uart_s_axi_arvalid_out => s_axi_arvalid_comm_to_auu,
              uart_s_axi_arready_in  => s_axi_arready_auu_to_comm,
              uart_s_axi_rdata_in    => s_axi_rdata_auu_to_comm,
              uart_s_axi_rresp_in    => s_axi_rresp_auu_to_comm,
              uart_s_axi_rvalid_in   => s_axi_rvalid_auu_to_comm,
              uart_s_axi_rready_out  => s_axi_rready_comm_to_auu);

axi_uartlite_unit : axi_uartlite_0
    port map (s_axi_aclk    => clk,
              s_axi_aresetn => main_rst_n,
              interrupt     => interrupt_auu_to_comm,
              s_axi_awaddr  => s_axi_awaddr_comm_to_auu,
              s_axi_awvalid => s_axi_awvalid_comm_to_auu,
              s_axi_awready => s_axi_awready_auu_to_comm,
              s_axi_wdata   => s_axi_wdata_comm_to_auu,
              s_axi_wstrb   => s_axi_wstrb_comm_to_auu,
              s_axi_wvalid  => s_axi_wvalid_comm_to_auu,
              s_axi_wready  => s_axi_wready_auu_to_comm,
              s_axi_bresp   => s_axi_bresp_auu_to_comm,
              s_axi_bvalid  => s_axi_bvalid_auu_to_comm,
              s_axi_bready  => s_axi_bready_comm_to_auu,
              s_axi_araddr  => s_axi_araddr_comm_to_auu,
              s_axi_arvalid => s_axi_arvalid_comm_to_auu,
              s_axi_arready => s_axi_arready_auu_to_comm,
              s_axi_rdata   => s_axi_rdata_auu_to_comm,
              s_axi_rresp   => s_axi_rresp_auu_to_comm,
              s_axi_rvalid  => s_axi_rvalid_auu_to_comm,
              s_axi_rready  => s_axi_rready_comm_to_auu,
              rx            => rx,
              tx            => tx);

end Behavioral;
