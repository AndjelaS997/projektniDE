library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_74S163 is
    port (
        CLK   : in std_logic;
        CLR   : in std_logic;
        LOAD  : in std_logic;
        ENABLE : in std_logic;
        DATA     : in std_logic_vector(3 downto 0);
        Q     : out std_logic_vector(3 downto 0);
        RCO   : out std_logic
    );
end entity counter_74S163;

architecture Behavioral of counter_74S163 is
    signal count : std_logic_vector(3 downto 0) := "0000";
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            count <= "0000";
        elsif rising_edge(CLK) then
            if LOAD = '1' then
                count <= DATA;
            elsIF (ENABLE= '1') then
                count <= std_logic_vector(unsigned(count) + 1);
            end if;
        end if;
    end process;
    
    Q <= count;
    RCO <= '1' when (count = "1111") else '0';
end architecture Behavioral;