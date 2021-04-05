library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rounds_tb is
end rounds_tb;



architecture Behavioral of rounds_tb is


component rounds_rtl is
  Port (   clk: in std_logic;
		   key : in STD_LOGIC_VECTOR (127 downto 0);
		   state : in STD_LOGIC_VECTOR(127 downto 0);
           out_put : out STD_LOGIC_VECTOR(127 downto 0)
		   );
end component;


signal clk: std_logic;
signal key: std_logic_vector ( 127 downto 0);
signal state: std_logic_vector (127 downto 0);
signal out_put :STD_LOGIC_VECTOR(127 downto 0);



begin

	rounds_rtl_map : rounds_rtl
	port map (
			clk =>clk,
			key => key,
			state => state,
			out_put => out_put
							
	);
	
	process
		begin
		clk<='1';
		wait for 10ns;
		clk<='0';
		wait for 10ns;
	end process;
	
	stim_procc: process
		begin
--		state<=x"3243f6a8885a308d313198a2e0370734";
--		key<=x"2b7e151628aed2a6abf7158809cf4f3c";
		
		state<=x"00000000000000000000000000000010";
     	key<=x"00000000000000000000000000000020";
    	wait for 10ns;		
    	
	
		
    	
    	
	end process;	
	
	
	
end Behavioral ;
