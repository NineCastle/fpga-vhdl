library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity top is
	Port(
			clk: in std_logic;
			rst: in std_logic;
			gir: in std_logic_vector(1 downto 0);
			sec: out std_logic_vector(7 downto 0);
			cik: out std_logic_vector(7 downto 0)
);
end entity;


architecture Behavioral of top is

component rounds_rtl is
port (
		   clk: in std_logic;
           rst: in std_logic;
           key: in std_logic_vector(127 downto 0);
           state: in std_logic_vector(127 downto 0);
           out_put: out std_logic_vector(127 downto 0)
);
end component;

        signal x,keyx,statex,top_key,top_state : std_logic_vector(127 downto 0);	
		signal LED_bcd: std_logic_vector(3 downto 0):= (others=> '0');
		signal LED_out: std_logic_vector(7 downto 0);
		signal top_out_put: std_logic_vector(127 downto 0);
		
		---------------------------------------------------------
		--1 milyon saat darbesi bekleme gerceklestirerek artis yapiyor
        signal bekleme_suresi: STD_LOGIC_VECTOR (19 downto 0):=(others=> '0');
        -- her 1 milyon saat darbesinde 1 oluyor
        signal bekleme_suresi_tamam_mi : std_logic;
        -- her bir dijitte gosterilecek hex sayiyi tutar
        signal display_sayisi: STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
        -- ilgili bitlerin gosterilecegi 7 segment secici
        signal aktif_LED_secici: std_logic_vector(2 downto 0);
        signal tazeleme_sayicisi: STD_LOGIC_VECTOR(20 downto 0):=(others=>'0');
        signal sonuc : std_logic_vector(31 downto 0);
		
begin
statex<=x"00000000000000000000000000000010";
keyx<=x"00000000000000000000000000000020";

i_rounds_rtl : rounds_rtl
port map(
clk			=> clk,
rst         => rst,
key         => top_key,
state       => top_state,
out_put		=> top_out_put
);

top_key <= keyx;
top_state <=statex;

process(LED_bcd)
begin
	case LED_bcd is
		when "0000" => LED_out <= "10000001"; --"0"
		when "0001" => LED_out <= "11001111"; --"1"
		when "0010" => LED_out <= "10010010"; --"2"
		when "0011" => LED_out <= "10000110"; --"3"
		when "0100" => LED_out <= "11001100"; --"4"
		when "0101" => LED_out <= "10100100"; --"5"
		when "0110" => LED_out <= "10100000"; --"6"
		when "0111" => LED_out <= "10001111"; --"7"
		when "1000" => LED_out <= "10000000"; --"8"
		when "1001" => LED_out <= "10000100"; --"9"
		when "1010" => LED_out <= "10000010"; --"A"
		when "1011" => LED_out <= "11100000"; --"B"
		when "1100" => LED_out <= "10110001"; --"C"
		when "1101" => LED_out <= "11000010"; --"D"
		when "1110" => LED_out <= "10110000"; --"E"
		when "1111" => LED_out <= "10111000"; --"F"
		when others => LED_out <= "10000001"; --bos
	end case;

end process;

process(clk,rst)
begin
if rst='1' then
tazeleme_sayicisi <= (others => '0');
elsif rising_edge(clk) then
tazeleme_sayicisi <= tazeleme_sayicisi + 1;
end if;
end process;

-- 8 to 1 MUX
aktif_LED_secici <= tazeleme_sayicisi(20 downto 18);

process(aktif_led_secici)
begin

if gir<= "00" then
sonuc(31 downto 0) <= top_out_put (127 downto 96);

elsif gir<= "01" then
sonuc(31 downto 0) <= top_out_put (95 downto 64);

elsif gir<= "10" then
sonuc(31 downto 0) <= top_out_put (63 downto 32);

elsif gir<= "11" then
sonuc(31 downto 0) <= top_out_put (31 downto 0);
end if;

case aktif_lED_secici is
when "000"=>
sec <= "01111111"; --1.led aktif 
LED_bcd <= sonuc(31 downto 28);
when "001" =>
sec <= "10111111"; --2.led aktif. 
LED_bcd <= sonuc(27 downto 24);
when "010" =>
sec <= "11011111"; --3.led aktif 
LED_bcd <= sonuc(23 downto 20);
when "011" =>
sec <= "11101111"; --4.led aktif 
LED_bcd <= sonuc(19 downto 16);
-------
when "111" =>
sec <= "11110111"; --5.led aktif 
LED_bcd <= sonuc(15 downto 12);
----
when "110" =>
sec <= "11111011"; --6.led aktif 
LED_bcd <= sonuc(11 downto 8);
----
when "101" =>
sec <= "11111101"; --7.led aktif 
LED_bcd <= sonuc(7 downto 4);
-------
when "100" =>
sec <= "11111110"; --8.led aktif 
LED_bcd <= sonuc(3 downto 0);
--------
when others =>
sec <= "11111111"; --hepsi pasif
end case;



end process;

--4 dijit display deki sayilarin arasýndaki bekleme suresi
process(clk,rst)
begin
if(rst='1') then
bekleme_suresi <= (others => '0');
elsif(rising_edge(clk)) then
if(bekleme_suresi>x"FFFFF") then
bekleme_suresi <= (others => '0');
else
bekleme_suresi <= bekleme_suresi + "00001";
end if;
end if;
end process;

bekleme_suresi_tamam_mi <= '1' when bekleme_suresi=x"FFFFF"
else '0';

process (clk,rst)
begin
if(rst='1') then
display_sayisi <= (others => '0');
elsif (rising_edge(clk)) then
if(bekleme_suresi_tamam_mi = '1') then
display_sayisi <= display_sayisi + x"0001";
end if;
end if;
end process;
cik <= LED_out;


end Behavioral;