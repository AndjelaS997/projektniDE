library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity clock is
    port (
        CLK    : in std_logic;
        RESET  : in std_logic;
        SET    : in std_logic;
        SET_HR : in std_logic_vector(7 downto 0);
        SET_MIN: in std_logic_vector(7 downto 0);
        SET_SEC: in std_logic_vector(7 downto 0);
        HOURS  : out std_logic_vector(7 downto 0);
        MINUTES: out std_logic_vector(7 downto 0);
        SECONDS: out std_logic_vector(7 downto 0)
    );
end entity clock;

architecture Behavioral of clock is
    signal sec_0, sec_1, min_0, min_1, hour_0, hour_1 : std_logic_vector(3 downto 0) := (others => '0');
    signal sec_rco, min_rco, hour_rco: std_logic;
    
    signal sec_enable, min_enable, hour_enable : std_logic;

   signal rst_sec, rst_min, rst_hour, rst_global_sec,rst_global_min, rst_global_hour : std_logic;
   signal seconds_out, minutes_out, hours_out : std_logic_vector( 7 downto 0) := (others => '0');
    
begin

     rst_global_sec <= (RESET or rst_sec);
     rst_global_min <= (RESET or rst_min);
     rst_global_hour <= (RESET or rst_hour);


    -- Sekunde brojanje
    sec_counter_0: counter_74S163
        port map (
            CLK => CLK,
            CLR => rst_global_sec,
            LOAD => SET,
            ENABLE => '1',
            DATA => SET_SEC(3 downto 0),
            Q => sec_0,
            RCO => sec_rco
        );
    sec_counter_1: counter_74S163
        port map (
            CLK => CLK,
            CLR => rst_global_sec,
            LOAD => SET,
            ENABLE => sec_rco,
            DATA => SET_SEC(3 downto 0),
            Q => sec_1,
            RCO => open
        );

    SEC_PROCESS : process(clk) begin
    
    	if (rising_edge(CLK)) then 

		    if (RESET = '1') then
			        min_enable <= '0';
			        rst_sec <= '1';
                    
		else
			if (seconds_out = x"3b") then
				    min_enable <= '1';
 				    rst_sec <= '1';
			else
				 min_enable <= '0';
				 rst_sec <= '0';
			end if;
		end if;
	end if;
    end process SEC_PROCESS;

    -- Minute brojanje
    min_counter_0: counter_74S163
        port map (
            CLK => CLK,
            CLR => rst_global_min,
            LOAD => SET,
            ENABLE => min_enable,
            DATA => SET_MIN(3 downto 0),
            Q => min_0,
            RCO => min_rco
        );
    min_counter_1: counter_74S163
        port map (
            CLK => CLK,
            CLR => rst_global_min,
            LOAD => SET,
            ENABLE => min_rco,
            DATA => SET_MIN(3 downto 0),
            Q => min_1,
            RCO => open
        );

        MIN_PROCESS : process(clk) begin 
                if(rising_edge(CLK)) then

                        if(RESET = '1') then
                                hour_enable <= '0';
                                rst_min <= '1'; 
                    
                        else
                            if(minutes_out = x"3b") then
                                    hour_enable <= '1';
                                    rst_min <= '1';
                            else
                                    hour_enable <= '0';
                                    rst_min <= '0';
                           end if;
                       end if;
                end if;
     end process MIN_PROCESS;


    -- Sati brojanje
    hour_counter_0: counter_74S163
        port map (
            CLK => CLK,
            CLR => rst_global_hour,
            LOAD => SET,
            ENABLE => hour_enable,
            DATA => SET_HR(3 downto 0),
            Q => hour_0,
            RCO => hour_rco
        );
    hour_counter_1: counter_74S163
        port map (
            CLK => CLK,
            CLR => rst_global_hour,
            LOAD => SET,
            ENABLE => hour_rco,
            DATA => SET_HR(3 downto 0),
            Q => hour_1,
            RCO => open
        );

    HOURS_PROCESS : process(clk) begin
   
           if(rising_edge(CLK)) then
                if(RESET = '1') then
                    rst_hour <= '1';
               
               else
                    if(hours_out = x"17") then
                        rst_hour <= '1';

                    else 
                        rst_hour <= '0';
                    end if;
                end if;
            end if;
    end process HOURS_PROCESS;
                    
    seconds_out <= sec_0 & sec_1;
    minutes_out <= min_0 & min_1;
    hours_out <= hour_0 & hour_1;

    SECONDS <= seconds_out;
    MINUTES <= minutes_out;
    HOURS <= hours_out;
    
end architecture Behavioral;