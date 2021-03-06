--
-- A simulation model of Asteroids Deluxe hardware
-- Copyright (c) MikeJ - May 2004
--
-- All rights reserved
-- Modified and ported to Papilio Pro by James Sweet - Feb 2015
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- You are responsible for any legal issues arising from your use of this code.
--
-- The latest version of this file can be found at: www.fpgaarcade.com
--
-- Email support@fpgaarcade.com
--
-- Revision list
--
-- version 001 initial release
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package pkg_asteroids is


--COMPONENT ASTEROIDS
--PORT(
--	BUTTON : IN std_logic_vector(7 downto 0);
--	SELF_TEST_SWITCH_L: IN std_logic;
--	RESET_6_L : IN std_logic;
--	CLK_6 : IN std_logic;          
--	AUDIO_OUT : OUT std_logic_vector(7 downto 0);
--	X_VECTOR : OUT std_logic_vector(9 downto 0);
--	Y_VECTOR : OUT std_logic_vector(9 downto 0);
--	Z_VECTOR : OUT std_logic_vector(3 downto 0);
--	START1_LED_L		 : out 	std_logic;
--	START2_LED_L		 : out	std_logic;
--	PROG_ROM_ADDR	: out std_logic_vector(12 downto 0);
--	PROG_ROM_DATA : in std_logic_vector(7 downto 0);
--	BEAM_ON : OUT std_logic;
--	BEAM_ENA : OUT std_logic
--	);
--END COMPONENT;


component ASTEROIDS_VG
 port (
	C_ADDR       : in    std_logic_vector(15 downto 0);
	C_DIN        : in    std_logic_vector( 7 downto 0);
	C_DOUT       : out   std_logic_vector( 7 downto 0);
	C_RW_L       : in    std_logic;
	VMEM_L       : in    std_logic;
	--
	DMA_GO_L     : in    std_logic;
	DMA_RESET_L  : in    std_logic;
	HALT_OP      : out   std_logic;
	--
	X_VECTOR     : out   std_logic_vector(9 downto 0);
	Y_VECTOR     : out   std_logic_vector(9 downto 0);
	Z_VECTOR     : out   std_logic_vector(3 downto 0);
	BEAM_ON      : out   std_logic;
	--
	ENA_1_5M     : in    std_logic;
	ENA_1_5M_E   : in    std_logic;
	RESET_L      : in    std_logic;
	CLK_6        : in    std_logic
	);
end component;

component ASTEROIDS_POKEY
 port (
 ADDR      : in  std_logic_vector(3 downto 0);
 DIN       : in  std_logic_vector(7 downto 0);
 DOUT      : out std_logic_vector(7 downto 0);
 DOUT_OE_L : out std_logic;
 RW_L      : in  std_logic;
 CS        : in  std_logic; -- used as enable
 CS_L      : in  std_logic;
 --
 AUDIO_OUT : out std_logic_vector(7 downto 0);
 --
 PIN       : in  std_logic_vector(7 downto 0);
 ENA       : in  std_logic;
 CLK       : in  std_logic  -- note 6 Mhz
 );
end component;

component ASTEROIDS_PROG_ROM_0
 port (
	CLK         : in    std_logic;
	ADDR        : in    std_logic_vector(10 downto 0);
	DATA        : out   std_logic_vector(7 downto 0)
	);
end component;

component ASTEROIDS_PROG_ROM_1
 port (
	CLK         : in    std_logic;
	ADDR        : in    std_logic_vector(10 downto 0);
	DATA        : out   std_logic_vector(7 downto 0)
	);
end component;

component ASTEROIDS_PROG_ROM_2
 port (
	CLK         : in    std_logic;
	ADDR        : in    std_logic_vector(10 downto 0);
	DATA        : out   std_logic_vector(7 downto 0)
	);
end component;

component ASTEROIDS_PROG_ROM_3
 port (
	CLK         : in    std_logic;
	ADDR        : in    std_logic_vector(10 downto 0);
	DATA        : out   std_logic_vector(7 downto 0)
	);
end component;

component ASTEROIDS_VEC_ROM_1
 port (
	CLK         : in    std_logic;
	ADDR        : in    std_logic_vector(10 downto 0);
	DATA        : out   std_logic_vector(7 downto 0)
	);
end component;

component ASTEROIDS_VEC_ROM_2
 port (
	CLK         : in    std_logic;
	ADDR        : in    std_logic_vector(10 downto 0);
	DATA        : out   std_logic_vector(7 downto 0)
	);
end component;

component ASTEROIDS_RAM
 port (
 ADDR   : in  std_logic_vector(9 downto 0);
 DIN    : in  std_logic_vector(7 downto 0);
 DOUT   : out std_logic_vector(7 downto 0);
 RW_L   : in  std_logic;
 CS_L   : in  std_logic; -- used for write enable gate only
 ENA    : in  std_logic; -- ditto
 CLK    : in  std_logic
 );
end component;

COMPONENT ram_1k
PORT (
 clka : IN STD_LOGIC;
 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
 addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
 dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END COMPONENT;

COMPONENT pwmgen
PORT(
inval : IN std_logic_vector(4 downto 0);
clk : IN std_logic;
reset : IN std_logic;          
output : OUT std_logic
);
END COMPONENT;

COMPONENT deltasigma
PORT(
inval : IN std_logic_vector(7 downto 0);
clk : IN std_logic;
reset : IN std_logic;          
output : OUT std_logic
);
END COMPONENT;



------------------------------------------------------------------------------
-- "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
-- "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
------------------------------------------------------------------------------
-- CLK_OUT1_____6.069______0.000______50.0______495.742____211.523
-- CLK_OUT2___100.571______0.000______50.0______261.440____211.523
--
------------------------------------------------------------------------------
-- "Input Clock   Freq (MHz)    Input Jitter (UI)"
------------------------------------------------------------------------------
-- __primary__________32.000____________0.010
component asteroids_clock
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  CLK_OUT2          : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic
 );
end component;


component ASTEROIDS_MUL4
 port (
	A             : in    std_logic_vector(3 downto 0);
	B             : in    std_logic_vector(3 downto 0);
	R             : out   std_logic_vector(7 downto 0)
	);
end component;

component T65
	port(
		 Mode    : in  std_logic_vector(1 downto 0);      -- "00" => 6502, "01" => 65C02, "10" => 65C816
		 Res_n   : in  std_logic;
		 Enable  : in  std_logic;
		 Clk     : in  std_logic;
		 Rdy     : in  std_logic;
		 Abort_n : in  std_logic;
		 IRQ_n   : in  std_logic;
		 NMI_n   : in  std_logic;
		 SO_n    : in  std_logic;
		 R_W_n   : out std_logic;
		 Sync    : out std_logic;
		 EF      : out std_logic;
		 MF      : out std_logic;
		 XF      : out std_logic;
		 ML_n    : out std_logic;
		 VP_n    : out std_logic;
		 VDA     : out std_logic;
		 VPA     : out std_logic;
		 A       : out std_logic_vector(23 downto 0);
		 DI      : in  std_logic_vector(7 downto 0);
		 DO      : out std_logic_vector(7 downto 0)
	);
end component;

end;

package body pkg_asteroids is

end;
