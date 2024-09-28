library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_clock is
end entity tb_clock;

architecture sim of tb_clock is
    -- Signali za ulaze i izlaze
    signal clk_signal    : std_logic := '0';
    signal reset_signal  : std_logic := '0';
    signal set_signal    : std_logic := '0';
    signal set_hr_signal : std_logic_vector(7 downto 0) := (others => '0');
    signal set_min_signal: std_logic_vector(7 downto 0) := (others => '0');
    signal set_sec_signal: std_logic_vector(7 downto 0) := (others => '0');
    signal hours_signal   : std_logic_vector(7 downto 0);
    signal minutes_signal : std_logic_vector(7 downto 0);
    signal seconds_signal : std_logic_vector(7 downto 0);
    
    constant clk_period : time := 100 us;  -- Perioda takta

begin
    -- Instanciranje entiteta clock
    uut: entity work.clock
        port map (
            CLK => clk_signal,
            RESET => reset_signal,
            SET => set_signal,
            SET_HR => set_hr_signal,
            SET_MIN => set_min_signal,
            SET_SEC => set_sec_signal,
            HOURS => hours_signal,
            MINUTES => minutes_signal,
            SECONDS => seconds_signal
        );

    -- Generisanje takta
    clk_process : process
    begin
        while true loop
            clk_signal <= '0';
            wait for clk_period / 2;
            clk_signal <= '1';
            wait for clk_period / 2;
        end loop;
    end process clk_process;

    -- Test proces
    stimulus_process : process
    begin
        -- Inicijalizacija
        reset_signal <= '1';  -- Aktiviraj reset
        wait for clk_period;
        reset_signal <= '0';   -- Deaktiviraj reset
        wait for clk_period;

        -- Postavi vreme
        set_signal <= '1';
        set_hr_signal <= "00001000";  -- Postavi sate na 8
        set_min_signal <= "00001010";    -- Postavi minute na 10
        set_sec_signal <= "00001101";     -- Postavi sekunde na 13
        wait for clk_period;
        set_signal <= '0';  -- Deaktiviraj postavljanje

        -- Čekaj nekoliko taktova
        wait for 10 * clk_period;

        -- Ponovo resetuj
        reset_signal <= '1';
        wait for clk_period;
        reset_signal <= '0';
        
        -- Čekaj da se stanje stabilizuje
        wait for 10 * clk_period;
        
        -- Završiti simulaciju
        wait;
    end process stimulus_process;

end architecture sim;
