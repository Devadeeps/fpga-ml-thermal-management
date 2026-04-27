library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FPGA_Temperature_System_TB is
end FPGA_Temperature_System_TB;

architecture Behavioral of FPGA_Temperature_System_TB is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;  -- Clock period (100 MHz)

    -- Signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal V_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal I_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal FPGA_Power : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal PWM_Duty : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Freq : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Ambient_Temp : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Cooling_Fan : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Prev_FPGA_Temp : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Heat_sink_Temp : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal FPGA_Temp : STD_LOGIC_VECTOR(15 downto 0);
    signal PWM_Freq : STD_LOGIC_VECTOR(15 downto 0);
    signal Overheat_Risk : STD_LOGIC;
    signal RL_State : STD_LOGIC_VECTOR(1 downto 0);
    signal RL_Reward : STD_LOGIC_VECTOR(7 downto 0);

begin
    -- Instantiate the DUT (Design Under Test)
    DUT : entity work.FPGA_Temperature_System
        port map (
            clk => clk,
            reset => reset,
            V_in => V_in,
            I_in => I_in,
            FPGA_Power => FPGA_Power,
            PWM_Duty => PWM_Duty,
            Freq => Freq,
            Ambient_Temp => Ambient_Temp,
            Cooling_Fan => Cooling_Fan,
            Prev_FPGA_Temp => Prev_FPGA_Temp,
            Heat_sink_Temp => Heat_sink_Temp,
            FPGA_Temp => FPGA_Temp,
            PWM_Freq => PWM_Freq,
            Overheat_Risk => Overheat_Risk,
            RL_State => RL_State,
            RL_Reward => RL_Reward
        );

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Stimulus process
    process
    begin
        -- Reset the system
        reset <= '1';
        wait for 100 ns;
        reset <= '0';

        -- Apply test inputs
        V_in <= std_logic_vector(to_signed(1200, 16));  -- 1.2 V
        I_in <= std_logic_vector(to_signed(400, 16));   -- 0.4 A
        FPGA_Power <= std_logic_vector(to_signed(480, 16));  -- 0.48 W
        PWM_Duty <= std_logic_vector(to_signed(3000, 16));   -- 30%
        Freq <= std_logic_vector(to_signed(10000, 16));      -- 10 kHz
        Ambient_Temp <= std_logic_vector(to_signed(2500, 16));  -- 25°C
        Cooling_Fan <= std_logic_vector(to_signed(1200, 16));   -- 1200 RPM
        Prev_FPGA_Temp <= std_logic_vector(to_signed(4000, 16));  -- 40°C
        Heat_sink_Temp <= std_logic_vector(to_signed(3800, 16));  -- 38°C

        wait for 200 ns;

        -- Change inputs
        V_in <= std_logic_vector(to_signed(1200, 16));  -- 1.2 V
        I_in <= std_logic_vector(to_signed(500, 16));   -- 0.5 A
        FPGA_Power <= std_logic_vector(to_signed(600, 16));  -- 0.60 W
        PWM_Duty <= std_logic_vector(to_signed(4000, 16));   -- 40%
        Freq <= std_logic_vector(to_signed(20000, 16));      -- 20 kHz
        Ambient_Temp <= std_logic_vector(to_signed(2600, 16));  -- 26°C
        Cooling_Fan <= std_logic_vector(to_signed(1300, 16));   -- 1300 RPM
        Prev_FPGA_Temp <= std_logic_vector(to_signed(4100, 16));  -- 41°C
        Heat_sink_Temp <= std_logic_vector(to_signed(3900, 16));  -- 39°C
        
        

        

        -- Add more test cases as needed
        -- Overheat condition test
        wait for 200 ns;
        V_in <= std_logic_vector(to_signed(1500, 16));  -- Higher voltage
        I_in <= std_logic_vector(to_signed(700, 16));   -- Higher current
        FPGA_Power <= std_logic_vector(to_signed(1050, 16));  -- Increased power
        PWM_Duty <= std_logic_vector(to_signed(5000, 16));   -- 50%
        Freq <= std_logic_vector(to_signed(25000, 16));      -- 25 kHz
        Ambient_Temp <= std_logic_vector(to_signed(5000, 16));  -- 50°C
        Cooling_Fan <= std_logic_vector(to_signed(0, 16));   -- Fan off!
        Prev_FPGA_Temp <= std_logic_vector(to_signed(4900, 16));  -- Almost overheating
        Heat_sink_Temp <= std_logic_vector(to_signed(4700, 16));  -- High heat sink temp


        -- End simulation
        
        wait for 200 ns;
        wait;
    end process;

end Behavioral;
