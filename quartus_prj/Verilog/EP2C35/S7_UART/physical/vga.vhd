-- The FPGA-evb-S2 Xilinx Spartan-II evaluation board example
--
-- This example displays horizontal or vertical color stripes
-- on a VGA monitor. The video mode is 640x480/59.5 Hz.
-- Orientation of stripes is selectable by first DIP switch.
--
-- (C)2001 Jan Pech, j.pech@sh.cvut.cz
--
--
--这是我收集的一个例子程序。
--一般在同步头宽度上再加上一个值就可以认为是消隐宽度，比方说0--100
--对于存储器大的方案，这个值可以是0值。

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity vga is
  port (resetn: in  std_logic;                      -- active low reset
        clock:  in  std_logic;                      -- system clock (25 MHz)
        orient: in  std_logic;                      -- orientation of stripes
        hsync:  out std_logic;                      -- horizontal sync
        vsync:  out std_logic;                      -- vertical sync
        pixel:  out std_logic_vector(5 downto 0));  -- pixel data
end vga;


architecture behavioral of vga is

  -- Horizontal timing constants
  constant H_PIXELS:     integer := 640;    -- number of pixels per line
  constant H_FRONTPORCH: integer := 16;     -- gap before sync pulse
  constant H_SYNCTIME:   integer := 96;     -- width of sync pulse
  constant H_BACKPORCH:  integer := 48;     -- gap after sync pulse
  constant H_SYNCSTART:  integer := H_PIXELS + H_FRONTPORCH;
  constant H_SYNCEND:    integer := H_SYNCSTART + H_SYNCTIME;
  constant H_PERIOD:     integer := H_SYNCEND + H_BACKPORCH;
  -- Vertical timing constants
  constant V_LINES:      integer := 480;    -- number of lines per frame
  constant V_FRONTPORCH: integer := 10;     -- gap before sync pulse
  constant V_SYNCTIME:   integer := 2;      -- width of sync pulse
  constant V_BACKPORCH:  integer := 33;     -- gap after sync pulse
  constant V_SYNCSTART:  integer := V_LINES + V_FRONTPORCH;
  constant V_SYNCEND:    integer := V_SYNCSTART + V_SYNCTIME;
  constant V_PERIOD:     integer := V_SYNCEND + V_BACKPORCH;

  signal hcnt: std_logic_vector(9 downto 0);    -- horizontal counter of  pixels
  signal vcnt: std_logic_vector(9 downto 0);    -- vertical counter of lines
  signal hsyncint: std_logic;                   -- internal horizontal sync
  signal enable: std_logic;                     -- output enable for pixel data

begin

  -- Horizontal counter of pixels
  HORIZONTAL_COUNTER: process(clock, resetn)
  begin
    if (resetn = '0') then
      hcnt <= (others => '0');
    elsif (clock'event and clock = '1') then
      if hcnt < H_PERIOD then
        hcnt <= hcnt + 1;
      else
        hcnt <= (others => '0');
      end if;
    end if;
  end process;

  -- Internal horizontal synchronization pulse generation (negative polarity)
  HORIZONTAL_SYNC: process(clock, resetn)
  begin
    if (resetn = '0') then
      hsyncint <= '1';
    elsif (clock'event and clock = '1') then
      if (hcnt >= H_SYNCSTART and hcnt < H_SYNCEND) then
        hsyncint <= '0';
      else
        hsyncint <= '1';
      end if;
    end if;
  end process;

  -- Horizontal synchronization output
  hsync <= hsyncint;

  -- Vertical counter of lines
  VERTICAL_COUNTER: process(hsyncint, resetn)
  begin
    if (resetn = '0') then
      vcnt <= (others => '0');
    elsif (hsyncint'event and hsyncint = '1') then
      if vcnt < V_PERIOD then
        vcnt <= vcnt + 1;
      else
        vcnt <= (others => '0');
      end if;
    end if;
  end process;

  -- Vertical synchronization pulse generation (negative polarity)
  VERTICAL_SYNC: process(hsyncint, resetn)
  begin
    if (resetn = '0') then
      vsync <= '1';
    elsif (hsyncint'event and hsyncint = '1') then
      if (vcnt >= V_SYNCSTART and vcnt < V_SYNCEND) then
        vsync <= '0';
      else
        vsync <= '1';
      end if;
    end if;
  end process;

  -- Enabling of color outputs
  OUTPUT_ENABLE: process(clock)
  begin
    if (clock'event and clock = '1') then
      if (hcnt >= H_PIXELS or vcnt >= V_LINES) then
        enable <= '0';
      else 
        enable <= '1';
      end if;
    end if;
  end process;

  -- Output image generation (horizontal or vertical color stripes)
  IMAGE: process(enable, orient, hcnt, vcnt)
  begin
    if (enable = '0') then
      pixel <= (others => '0');
    elsif (orient = '1') then
      pixel <= hcnt(7 downto 2);
    else
      pixel <= vcnt(7 downto 2);
    end if;
  end process;

end behavioral;

END