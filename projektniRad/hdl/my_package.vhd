library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package my_package is
    component counter_74S163
        port (
            CLK   : in std_logic;
            CLR   : in std_logic;
            LOAD  : in std_logic;
            ENABLE  : in std_logic;
            DATA     : in std_logic_vector(3 downto 0);
            Q     : out std_logic_vector(3 downto 0);
            RCO   : out std_logic
        );
    end component;
end my_package;