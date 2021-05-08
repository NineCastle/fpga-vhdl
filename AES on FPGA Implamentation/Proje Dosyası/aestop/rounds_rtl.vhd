library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;


entity rounds_rtl is
    Port ( 
           clk: in std_logic;
           rst: in std_logic;
           key: in std_logic_vector(127 downto 0);
           state: in std_logic_vector(127 downto 0);
           out_put: out std_logic_vector(127 downto 0)
			
		   );
end rounds_rtl;

architecture Behavioral of rounds_rtl is


			type memoryx is array (1 to 16) of std_logic_vector (7 downto 0);
			signal finalx : memoryx;
		
begin

	
	
	process(state,key)
	variable count: integer range 1 to 26 ;
	variable flag: std_logic:='0';
	variable count_round: integer range 1 to 11:=1;
	
	----
type memory is array (1 to 16) of std_logic_vector (7 downto 0);
type matrix_memory is array (1 to 32) of std_logic_vector (7 downto 0);
type s_box is array (0 to 15,0 to 15) of std_logic_vector(7 downto 0);
variable k: memory;	--key
variable t: memory;	--text
variable result : memory;
variable enc: memory;
variable temp: memory;
variable matrix : matrix_memory;
variable mcol:memory; 
variable rcon: std_logic_vector(7 downto 0);

variable f1,f2,f3,f4: std_logic_vector(7 downto 0);
variable mk: memory;
variable k_new: memory;
variable final : memory;

variable s: s_box:=(       (x"63",x"7c",x"77",x"7b",x"f2",x"6b",x"6f",x"c5",x"30",x"01",x"67",x"2b",x"fe",x"d7",x"ab",x"76"),
		                   (x"ca",x"82",x"c9",x"7d",x"fa",x"59",x"47",x"f0",x"ad",x"d4",x"a2",x"af",x"9c",x"a4",x"72",x"c0"),
						   (x"b7",x"fd",x"93",x"26",x"36",x"3f",x"f7",x"cc",x"34",x"a5",x"e5",x"f1",x"71",x"d8",x"31",x"15"),
						   (x"04",x"c7",x"23",x"c3",x"18",x"96",x"05",x"9a",x"07",x"12",x"80",x"e2",x"eb",x"27",x"b2",x"75"),
						   (x"09",x"83",x"2c",x"1a",x"1b",x"6e",x"5a",x"a0",x"52",x"3b",x"d6",x"b3",x"29",x"e3",x"2f",x"84"),
						   (x"53",x"d1",x"00",x"ed",x"20",x"fc",x"b1",x"5b",x"6a",x"cb",x"be",x"39",x"4a",x"4c",x"58",x"cf"),
						   (x"d0",x"ef",x"aa",x"fb",x"43",x"4d",x"33",x"85",x"45",x"f9",x"02",x"7f",x"50",x"3c",x"9f",x"a8"),
						   (x"51",x"a3",x"40",x"8f",x"92",x"9d",x"38",x"f5",x"bc",x"b6",x"da",x"21",x"10",x"ff",x"f3",x"d2"),
						   (x"cd",x"0c",x"13",x"ec",x"5f",x"97",x"44",x"17",x"c4",x"a7",x"7e",x"3d",x"64",x"5d",x"19",x"73"),
						   (x"60",x"81",x"4f",x"dc",x"22",x"2a",x"90",x"88",x"46",x"ee",x"b8",x"14",x"de",x"5e",x"0b",x"db"),
						   (x"e0",x"32",x"3a",x"0a",x"49",x"06",x"24",x"5c",x"c2",x"d3",x"ac",x"62",x"91",x"95",x"e4",x"79"),
						   (x"e7",x"c8",x"37",x"6d",x"8d",x"d5",x"4e",x"a9",x"6c",x"56",x"f4",x"ea",x"65",x"7a",x"ae",x"08"),
						   (x"ba",x"78",x"25",x"2e",x"1c",x"a6",x"b4",x"c6",x"e8",x"dd",x"74",x"1f",x"4b",x"bd",x"8b",x"8a"),
						   (x"70",x"3e",x"b5",x"66",x"48",x"03",x"f6",x"0e",x"61",x"35",x"57",x"b9",x"86",x"c1",x"1d",x"9e"),
						   (x"e1",x"f8",x"98",x"11",x"69",x"d9",x"8e",x"94",x"9b",x"1e",x"87",x"e9",x"ce",x"55",x"28",x"df"),
						   (x"8c",x"a1",x"89",x"0d",x"bf",x"e6",x"42",x"68",x"41",x"99",x"2d",x"0f",x"b0",x"54",x"bb",x"16"));

	-------

	begin
	
		--key atamalari
	k(16) := key(7 downto 0);
	k(15) := key(15 downto 8);
	k(14) := key(23 downto 16);
	k(13) := key(31 downto 24);
	k(12) := key(39 downto 32);
	k(11) := key(47 downto 40);
	k(10) := key(55 downto 48);
	k(9) := key(63 downto 56);
	k(8) := key(71 downto 64);
	k(7) := key(79 downto 72);
	k(6) := key(87 downto 80);
	k(5) := key(95 downto 88);
	k(4) := key(103 downto 96);
	k(3) := key(111 downto 104);
	k(2) := key(119 downto 112);
	k(1) := key(127 downto 120);
	--         end
	
	-- state atamalari
	t(16) :=state(7 downto 0);
	t(15) :=state(15 downto 8);
	t(14) :=state(23 downto 16);
	t(13) :=state(31 downto 24);
	t(12) :=state(39 downto 32);
	t(11) :=state(47 downto 40);
	t(10) :=state(55 downto 48);
	t(9) :=state(63 downto 56);
	t(8) :=state(71 downto 64);
    t(7) :=state(79 downto 72);
	t(6) :=state(87 downto 80);
	t(5) :=state(95 downto 88);
	t(4) :=state(103 downto 96);
	t(3) :=state(111 downto 104);
	t(2) :=state(119 downto 112);
	t(1) :=state(127 downto 120);
	--         end
	
	-- key ve textin atandýðý kýsým.	
	count := 1;
    while (count < 17) loop
    result(count) := k(count) xor t(count);
    mk := k;
    count:= count+1;
    
	end loop;
	if count=17 then
	enc := result;
    count:=1;
    flag:='1';
	end if;
	-- end

-- 9 roundlýk kýsým döngü ile.
count_round:=1;
if flag='1' then
                
                while (count_round < 10) loop

              
----				-- sbox kodlarim
               
				temp(1):=s(conv_integer(unsigned(enc(1)(7 downto 4))),conv_integer(unsigned(enc(1)(3 downto 0))));
				temp(2):=s(conv_integer(unsigned(enc(6)(7 downto 4))),conv_integer(unsigned(enc(6)(3 downto 0))));
				temp(3):=s(conv_integer(unsigned(enc(11)(7 downto 4))),conv_integer(unsigned(enc(11)(3 downto 0))));
				temp(4):=s(conv_integer(unsigned(enc(16)(7 downto 4))),conv_integer(unsigned(enc(16)(3 downto 0))));
				temp(5):=s(conv_integer(unsigned(enc(5)(7 downto 4))),conv_integer(unsigned(enc(5)(3 downto 0))));
				temp(6):=s(conv_integer(unsigned(enc(10)(7 downto 4))),conv_integer(unsigned(enc(10)(3 downto 0))));
			    temp(7):=s(conv_integer(unsigned(enc(15)(7 downto 4))),conv_integer(unsigned(enc(15)(3 downto 0))));
				temp(8):=s(conv_integer(unsigned(enc(4)(7 downto 4))),conv_integer(unsigned(enc(4)(3 downto 0))));
				temp(9):=s(conv_integer(unsigned(enc(9)(7 downto 4))),conv_integer(unsigned(enc(9)(3 downto 0))));
				temp(10):=s(conv_integer(unsigned(enc(14)(7 downto 4))),conv_integer(unsigned(enc(14)(3 downto 0))));
				temp(11):=s(conv_integer(unsigned(enc(3)(7 downto 4))),conv_integer(unsigned(enc(3)(3 downto 0))));
				temp(12):=s(conv_integer(unsigned(enc(8)(7 downto 4))),conv_integer(unsigned(enc(8)(3 downto 0))));
				temp(13):=s(conv_integer(unsigned(enc(13)(7 downto 4))),conv_integer(unsigned(enc(13)(3 downto 0))));
				temp(14):=s(conv_integer(unsigned(enc(2)(7 downto 4))),conv_integer(unsigned(enc(2)(3 downto 0))));
				temp(15):=s(conv_integer(unsigned(enc(7)(7 downto 4))),conv_integer(unsigned(enc(7)(3 downto 0))));
				temp(16):=s(conv_integer(unsigned(enc(12)(7 downto 4))),conv_integer(unsigned(enc(12)(3 downto 0))));
				

              
              --------------------------------------------1.sutun------------------------------------------
		 
		      --1
		      if temp(1)(7)='0' then
		      matrix(1):=temp(1)(6 downto 0) & '0';
		      else
		      matrix(1):=(temp(1)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(2)(7)='0' then
		      matrix(2):=temp(2)(6 downto 0) & '0';
		      else
		      matrix(2):=(temp(2)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(1) := matrix(1) xor matrix(2) xor temp(2) xor temp(3) xor temp(4);
		      
		      --2
		      if temp(2)(7)='0' then
		      matrix(3):=temp(2)(6 downto 0) & '0';
		      else
		      matrix(3):=(temp(2)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(3)(7)='0' then
		      matrix(4):=temp(3)(6 downto 0) & '0';
		      else
		      matrix(4):=(temp(3)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(2) := temp(1) xor matrix(3) xor matrix(4) xor temp(3) xor temp(4);
		      
		      --3
		      if temp(3)(7)='0' then
		      matrix(5):=temp(3)(6 downto 0) & '0';
		      else
		      matrix(5):=(temp(3)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(4)(7)='0' then
		      matrix(6):=temp(4)(6 downto 0) & '0';
		      else
		      matrix(6):=(temp(4)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(3) := temp(1) xor temp(2) xor matrix(5) xor matrix(6) xor temp(4);
		      
		      --4
		      if temp(1)(7)='0' then
		      matrix(7):=temp(1)(6 downto 0) & '0';
		      else
		      matrix(7):=(temp(1)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(4)(7)='0' then
		      matrix(8):=temp(4)(6 downto 0) & '0';
		      else
		      matrix(8):=(temp(4)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(4) := matrix(7) xor temp(1) xor temp(2) xor temp(3) xor matrix(8);
		      -- end 
		      
		      --------------------------------------------2.sutun------------------------------------------
		      
		      --5
		      if temp(5)(7)='0' then
		      matrix(9):=temp(5)(6 downto 0) & '0';
		      else
		      matrix(9):=(temp(5)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(6)(7)='0' then
		      matrix(10):=temp(6)(6 downto 0) & '0';
		      else
		      matrix(10):=(temp(6)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(5) := matrix(9) xor matrix(10) xor temp(6) xor temp(7) xor temp(8);
		
		      --6
		      if temp(6)(7)='0' then
		      matrix(11):=temp(6)(6 downto 0) & '0';
		      else
		      matrix(11):=(temp(6)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(7)(7)='0' then
		      matrix(12):=temp(7)(6 downto 0) & '0';
		      else
		      matrix(12):=(temp(7)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(6) := temp(5) xor matrix(11) xor matrix(12) xor temp(7) xor temp(8);
		      
		      --7
		       if temp(7)(7)='0' then
		      matrix(13):=temp(7)(6 downto 0) & '0';
		      else
		      matrix(13):=(temp(7)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(8)(7)='0' then
		      matrix(14):=temp(8)(6 downto 0) & '0';
		      else
		      matrix(14):=(temp(8)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(7) := temp(5) xor temp(6) xor matrix(13) xor matrix(14) xor temp(8);
		      
		      --8
		      if temp(5)(7)='0' then
		      matrix(15):=temp(5)(6 downto 0) & '0';
		      else
		      matrix(15):=(temp(5)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(8)(7)='0' then
		      matrix(16):=temp(8)(6 downto 0) & '0';
		      else
		      matrix(16):=(temp(8)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(8) := matrix(15) xor temp(5) xor temp(6) xor temp(7) xor matrix(16);
		      -- end 
		      
		      --------------------------------------------3.sutun------------------------------------------
		      --9
		      if temp(9)(7)='0' then
		      matrix(17):=temp(9)(6 downto 0) & '0';
		      else
		      matrix(17):=(temp(9)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(10)(7)='0' then
		      matrix(18):=temp(10)(6 downto 0) & '0';
		      else
		      matrix(18):=(temp(10)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(9) := matrix(17) xor matrix(18) xor temp(10) xor temp(11) xor temp(12);
		      
		      --10
		      if temp(10)(7)='0' then
		      matrix(19):=temp(10)(6 downto 0) & '0';
		      else
		      matrix(19):=(temp(10)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(11)(7)='0' then
		      matrix(20):=temp(11)(6 downto 0) & '0';
		      else
		      matrix(20):=(temp(11)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(10) := temp(9) xor matrix(19) xor matrix(20) xor temp(11) xor temp(12);
		      
		      --11
		      if temp(11)(7)='0' then
		      matrix(21):=temp(11)(6 downto 0) & '0';
		      else
		      matrix(21):=(temp(11)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(12)(7)='0' then
		      matrix(22):=temp(12)(6 downto 0) & '0';
		      else
		      matrix(22):=(temp(12)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(11) := temp(9) xor temp(10) xor matrix(21) xor matrix(22) xor temp(12);
		      
		      --12
		      if temp(9)(7)='0' then
		      matrix(23):=temp(9)(6 downto 0) & '0';
		      else
		      matrix(23):=(temp(9)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(12)(7)='0' then
		      matrix(24):=temp(12)(6 downto 0) & '0';
		      else
		      matrix(24):=(temp(12)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(12) := matrix(23) xor temp(9) xor temp(10) xor temp(11) xor matrix(24);
		      -- end 
		      
		      --------------------------------------------4.sutun------------------------------------------
		       --13
		      if temp(13)(7)='0' then
		      matrix(25):=temp(13)(6 downto 0) & '0';
		      else
		      matrix(25):=(temp(13)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(14)(7)='0' then
		      matrix(26):=temp(14)(6 downto 0) & '0';
		      else
		      matrix(26):=(temp(14)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(13) := matrix(25) xor matrix(26) xor temp(14) xor temp(15) xor temp(16);
		      
		      --14
		      if temp(14)(7)='0' then
		      matrix(27):=temp(14)(6 downto 0) & '0';
		      else
		      matrix(27):=(temp(14)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(15)(7)='0' then
		      matrix(28):=temp(15)(6 downto 0) & '0';
		      else
		      matrix(28):=(temp(15)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(14) := temp(13) xor matrix(27) xor matrix(28) xor temp(15) xor temp(16);
		      
		      --15
		      if temp(15)(7)='0' then
		      matrix(29):=temp(15)(6 downto 0) & '0';
		      else
		      matrix(29):=(temp(15)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(16)(7)='0' then
		      matrix(30):=temp(16)(6 downto 0) & '0';
		      else
		      matrix(30):=(temp(16)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(15) := temp(13) xor temp(14) xor matrix(29) xor matrix(30) xor temp(16);
		      
		      --16
		      if temp(13)(7)='0' then
		      matrix(31):=temp(13)(6 downto 0) & '0';
		      else
		      matrix(31):=(temp(13)(6 downto 0) & '0') xor "00011011";
		      end if;
		      if temp(16)(7)='0' then
		      matrix(32):=temp(16)(6 downto 0) & '0';
		      else
		      matrix(32):=(temp(16)(6 downto 0) & '0') xor "00011011";
		      end if;
		      mcol(16) := matrix(31) xor temp(13) xor temp(14) xor temp(15) xor matrix(32);
		      -- end 
	          
		 	 -- key kýsmý
		 	  if count_round=1 then
		 	    rcon:=x"01";
		 	  elsif count_round=2 then
		 	    rcon:=x"02";
		 	  elsif count_round=3 then
		 	    rcon:=x"04";
		 	  elsif count_round=4 then
		 	    rcon:=x"08";
		 	  elsif count_round=5 then
		 	    rcon:=x"10";
		 	  elsif count_round=6 then
		 	    rcon:=x"20";
		 	  elsif count_round=7 then
		 	    rcon:=x"40";   
		 	  elsif count_round=8 then
		 	    rcon:=x"80";
		 	  elsif count_round=9 then
		 	    rcon:=x"1b";	 
		 	    	  
		 	  end if;
		 	    
		 	  f1:=s(conv_integer(unsigned(mk(14)(7 downto 4))),conv_integer(unsigned(mk(14)(3 downto 0))));
		 	  f2:=s(conv_integer(unsigned(mk(15)(7 downto 4))),conv_integer(unsigned(mk(15)(3 downto 0))));
		 	  f3:=s(conv_integer(unsigned(mk(16)(7 downto 4))),conv_integer(unsigned(mk(16)(3 downto 0))));
		 	  f4:=s(conv_integer(unsigned(mk(13)(7 downto 4))),conv_integer(unsigned(mk(13)(3 downto 0))));
		 	  
		 	  k_new(1):=  mk(1) xor f1 xor rcon;
		 	  k_new(2):=  mk(2) xor f2 xor x"00";
		 	  k_new(3):=  mk(3) xor f3 xor x"00";
		 	  k_new(4):=  mk(4) xor f4 xor x"00";
		 	  
		 	  k_new(5):=  k_new(1) xor mk(5);
		 	  k_new(6):=  k_new(2) xor mk(6);
		 	  k_new(7):=  k_new(3) xor mk(7);
		 	  k_new(8):=  k_new(4) xor mk(8);
		 	  
		 	  k_new(9):=  k_new(5) xor mk(9);
		 	  k_new(10):= k_new(6) xor mk(10);
		 	  k_new(11):= k_new(7) xor mk(11);
		 	  k_new(12):= k_new(8) xor mk(12);
		 	  
		 	  k_new(13):= k_new(9) xor mk(13);
		 	  k_new(14):= k_new(10) xor mk(14);
		 	  k_new(15):= k_new(11) xor mk(15);
		 	  k_new(16):= k_new(12) xor mk(16);
		 	  
		 	
               final(1)  := mcol(1) xor k_new(1);
	           final(2)  := mcol(2) xor k_new(2);
	           final(3)  := mcol(3) xor k_new(3);
	           final(4)  := mcol(4) xor k_new(4);
	           final(5)  := mcol(5) xor k_new(5);
	           final(6)  := mcol(6) xor k_new(6);
	           final(7)  := mcol(7) xor k_new(7);
	           final(8)  := mcol(8) xor k_new(8);
	           final(9)  := mcol(9) xor k_new(9);
	           final(10) := mcol(10) xor k_new(10);
	           final(11) := mcol(11) xor k_new(11);
	           final(12) := mcol(12) xor k_new(12);
	           final(13) := mcol(13) xor k_new(13);
	           final(14) := mcol(14) xor k_new(14);
	           final(15) := mcol(15) xor k_new(15);
	           final(16) := mcol(16) xor k_new(16);
	           
	           mk:=k_new;
	           enc:=final;
	           count_round:=count_round+1;
	 
end loop;	  
            
end if;

enc:=final;
                temp(1):=s(conv_integer(unsigned(enc(1)(7 downto 4))),conv_integer(unsigned(enc(1)(3 downto 0))));
				temp(2):=s(conv_integer(unsigned(enc(6)(7 downto 4))),conv_integer(unsigned(enc(6)(3 downto 0))));
				temp(3):=s(conv_integer(unsigned(enc(11)(7 downto 4))),conv_integer(unsigned(enc(11)(3 downto 0))));
				temp(4):=s(conv_integer(unsigned(enc(16)(7 downto 4))),conv_integer(unsigned(enc(16)(3 downto 0))));
				temp(5):=s(conv_integer(unsigned(enc(5)(7 downto 4))),conv_integer(unsigned(enc(5)(3 downto 0))));
				temp(6):=s(conv_integer(unsigned(enc(10)(7 downto 4))),conv_integer(unsigned(enc(10)(3 downto 0))));
			    temp(7):=s(conv_integer(unsigned(enc(15)(7 downto 4))),conv_integer(unsigned(enc(15)(3 downto 0))));
				temp(8):=s(conv_integer(unsigned(enc(4)(7 downto 4))),conv_integer(unsigned(enc(4)(3 downto 0))));
				temp(9):=s(conv_integer(unsigned(enc(9)(7 downto 4))),conv_integer(unsigned(enc(9)(3 downto 0))));
				temp(10):=s(conv_integer(unsigned(enc(14)(7 downto 4))),conv_integer(unsigned(enc(14)(3 downto 0))));
				temp(11):=s(conv_integer(unsigned(enc(3)(7 downto 4))),conv_integer(unsigned(enc(3)(3 downto 0))));
				temp(12):=s(conv_integer(unsigned(enc(8)(7 downto 4))),conv_integer(unsigned(enc(8)(3 downto 0))));
				temp(13):=s(conv_integer(unsigned(enc(13)(7 downto 4))),conv_integer(unsigned(enc(13)(3 downto 0))));
				temp(14):=s(conv_integer(unsigned(enc(2)(7 downto 4))),conv_integer(unsigned(enc(2)(3 downto 0))));
				temp(15):=s(conv_integer(unsigned(enc(7)(7 downto 4))),conv_integer(unsigned(enc(7)(3 downto 0))));
				temp(16):=s(conv_integer(unsigned(enc(12)(7 downto 4))),conv_integer(unsigned(enc(12)(3 downto 0))));
				
				
			  mk:=k_new;
			  f1:=s(conv_integer(unsigned(mk(14)(7 downto 4))),conv_integer(unsigned(mk(14)(3 downto 0))));
		 	  f2:=s(conv_integer(unsigned(mk(15)(7 downto 4))),conv_integer(unsigned(mk(15)(3 downto 0))));
		 	  f3:=s(conv_integer(unsigned(mk(16)(7 downto 4))),conv_integer(unsigned(mk(16)(3 downto 0))));
		 	  f4:=s(conv_integer(unsigned(mk(13)(7 downto 4))),conv_integer(unsigned(mk(13)(3 downto 0))));
		 	  
		 	  k_new(1):= mk(1) xor f1 xor x"36";
		 	  k_new(2):= mk(2) xor f2 xor x"00";
		 	  k_new(3):= mk(3) xor f3 xor x"00";
		 	  k_new(4):= mk(4) xor f4 xor x"00";
		 	  
		 	  k_new(5):= k_new(1) xor mk(5);
		 	  k_new(6):= k_new(2) xor mk(6);
		 	  k_new(7):= k_new(3) xor mk(7);
		 	  k_new(8):= k_new(4) xor mk(8);
		 	  
		 	  k_new(9):= k_new(5) xor mk(9);
		 	  k_new(10):= k_new(6) xor mk(10);
		 	  k_new(11):= k_new(7) xor mk(11);
		 	  k_new(12):= k_new(8) xor mk(12);
		 	  
		 	  k_new(13):= k_new(9) xor mk(13);
		 	  k_new(14):= k_new(10) xor mk(14);
		 	  k_new(15):= k_new(11) xor mk(15);
		 	  k_new(16):= k_new(12) xor mk(16);
    
		      final(1):= temp(1) xor k_new(1);
		      final(2):= temp(2) xor k_new(2);
		      final(3):= temp(3) xor k_new(3);
		      final(4):= temp(4) xor k_new(4);
		      final(5):= temp(5) xor k_new(5);
		      final(6):= temp(6) xor k_new(6);
		      final(7):= temp(7) xor k_new(7);
		      final(8):= temp(8) xor k_new(8);
		      final(9):= temp(9) xor k_new(9);
		      final(10):= temp(10) xor k_new(10);
		      final(11):= temp(11) xor k_new(11);
		      final(12):= temp(12) xor k_new(12);
		      final(13):= temp(13) xor k_new(13);
		      final(14):= temp(14) xor k_new(14);
		      final(15):= temp(15) xor k_new(15);
		      final(16):= temp(16) xor k_new(16);

              out_put(127 downto 120) <= final(1);
	          out_put(119 downto 112) <= final(2);
	          out_put(111 downto 104) <= final(3);
	          out_put(103 downto 96)  <= final(4);
	          out_put(95 downto 88)   <= final(5);
	          out_put(87 downto 80)   <= final(6);
	          out_put(79 downto 72)   <= final(7);
	          out_put(71 downto 64)   <= final(8);
	          out_put(63 downto 56)   <= final(9);
	          out_put(55 downto 48)   <= final(10);
	          out_put(47 downto 40)   <= final(11);
	          out_put(39 downto 32)   <= final(12);
	          out_put(31 downto 24)   <= final(13);
	          out_put(23 downto 16)   <= final(14);
	          out_put(15 downto 8)    <= final(15);
	          out_put(7 downto 0)     <= final(16);  

	end process;
	-------------------------------------------------------------------------------------
	
    

end Behavioral;