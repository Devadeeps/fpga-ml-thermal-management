library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FPGA_Temperature_System is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        -- Inputs
        V_in : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        I_in : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        FPGA_Power : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        PWM_Duty : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        Freq : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        Ambient_Temp : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        Cooling_Fan : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        Prev_FPGA_Temp : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        Heat_sink_Temp : in STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point input (16-bit)
        -- Outputs
        FPGA_Temp : out STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point output (16-bit)
        PWM_Freq : out STD_LOGIC_VECTOR(15 downto 0);  -- Fixed-point output (16-bit)
        Overheat_Risk : out STD_LOGIC;  -- Binary output (0 = no risk, 1 = risk)
        RL_State : out STD_LOGIC_VECTOR(1 downto 0);  -- RL state (00 = normal, 01 = warning, 10 = critical)
        RL_Reward : out STD_LOGIC_VECTOR(7 downto 0)  -- RL reward (8-bit signed)
    );
end FPGA_Temperature_System;

architecture Behavioral of FPGA_Temperature_System is
    -- Constants for weights (replace with actual trained weights)
    constant W_V_in : signed(15 downto 0) := to_signed(123, 16);  -- Weight for V_in
    constant W_I_in : signed(15 downto 0) := to_signed(456, 16);  -- Weight for I_in
    constant W_FPGA_Power : signed(15 downto 0) := to_signed(789, 16);  -- Weight for FPGA_Power
    constant W_PWM_Duty : signed(15 downto 0) := to_signed(101, 16);  -- Weight for PWM_Duty
    constant W_Freq : signed(15 downto 0) := to_signed(112, 16);  -- Weight for Freq
    constant W_Ambient_Temp : signed(15 downto 0) := to_signed(131, 16);  -- Weight for Ambient_Temp
    constant W_Cooling_Fan : signed(15 downto 0) := to_signed(415, 16);  -- Weight for Cooling_Fan
    constant W_Prev_FPGA_Temp : signed(15 downto 0) := to_signed(161, 16);  -- Weight for Prev_FPGA_Temp
    constant W_Heat_sink_Temp : signed(15 downto 0) := to_signed(718, 16);  -- Weight for Heat_sink_Temp

    -- Constants for thresholds
    constant TEMP_THRESHOLD : signed(15 downto 0) := to_signed(5000, 16);  -- Threshold for PWM adjustment (50°C)
    constant OVERHEAT_THRESHOLD : signed(15 downto 0) := to_signed(5000, 16);  -- Overheat threshold (50°C)
    constant NORMAL_THRESHOLD : signed(15 downto 0) := to_signed(4500, 16);  -- Normal state threshold (45°C)
    constant WARNING_THRESHOLD : signed(15 downto 0) := to_signed(5000, 16);  -- Warning state threshold (50°C)
    constant HYSTERESIS : signed(15 downto 0) := to_signed(100, 16);  -- Hysteresis for overheat risk

    -- Internal signals
    signal weighted_sum : signed(31 downto 0) := (others => '0');
    signal temp_prediction : signed(15 downto 0) := (others => '0');
    signal freq_adjustment : signed(15 downto 0) := (others => '0');
    signal current_state : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal reward : signed(7 downto 0) := (others => '0');
begin

    -- Process for temperature prediction (Random Forest Regressor)
    process(clk, reset)
    begin
        if reset = '1' then
            temp_prediction <= (others => '0');
        elsif rising_edge(clk) then
            -- Weighted sum calculation
            weighted_sum <= resize(signed(V_in) * W_V_in, 32) +
                            resize(signed(I_in) * W_I_in, 32) +
                            resize(signed(FPGA_Power) * W_FPGA_Power, 32) +
                            resize(signed(PWM_Duty) * W_PWM_Duty, 32) +
                            resize(signed(Freq) * W_Freq, 32) +
                            resize(signed(Ambient_Temp) * W_Ambient_Temp, 32) +
                            resize(signed(Cooling_Fan) * W_Cooling_Fan, 32) +
                            resize(signed(Prev_FPGA_Temp) * W_Prev_FPGA_Temp, 32) +
                            resize(signed(Heat_sink_Temp) * W_Heat_sink_Temp, 32);

            -- Scale down to 16-bit fixed-point output
            temp_prediction <= resize(weighted_sum / 1024, 16);
        end if;
    end process;

    -- Output the predicted temperature
    FPGA_Temp <= std_logic_vector(temp_prediction);

    -- Process for PWM frequency adjustment
    process(clk, reset)
    begin
        if reset = '1' then
            freq_adjustment <= to_signed(5000, 16);  -- Default frequency
        elsif rising_edge(clk) then
            -- Adjust frequency based on temperature with hysteresis
            if temp_prediction > TEMP_THRESHOLD + HYSTERESIS then
                freq_adjustment <= to_signed(10000, 16);  -- Increase frequency
            elsif temp_prediction < TEMP_THRESHOLD - HYSTERESIS then
                freq_adjustment <= to_signed(5000, 16);  -- Decrease frequency
            end if;
        end if;
    end process;

    -- Output the adjusted frequency
    PWM_Freq <= std_logic_vector(freq_adjustment);

    -- Process for overheat risk prediction
    process(clk, reset)
    begin
        if reset = '1' then
            Overheat_Risk <= '0';
        elsif rising_edge(clk) then
            -- Predict overheat risk with hysteresis
            if temp_prediction > OVERHEAT_THRESHOLD + HYSTERESIS then
                Overheat_Risk <= '1';  -- Overheat risk
            elsif temp_prediction < OVERHEAT_THRESHOLD - HYSTERESIS then
                Overheat_Risk <= '0';  -- No risk
            end if;
        end if;
    end process;

    -- Process for reinforcement learning (state and reward calculation)
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= "00";  -- Normal state
            reward <= to_signed(0, 8);
        elsif rising_edge(clk) then
            -- Update state based on temperature
            if temp_prediction < NORMAL_THRESHOLD then
                current_state <= "00";  -- Normal state
                reward <= to_signed(1, 8);  -- Positive reward
            elsif temp_prediction < WARNING_THRESHOLD then
                current_state <= "01";  -- Warning state
                reward <= to_signed(-1, 8);  -- Negative reward
            else
                current_state <= "10";  -- Critical state
                reward <= to_signed(-10, 8);  -- Large negative reward
            end if;
        end if;
    end process;

    -- Output the RL state and reward
    RL_State <= current_state;
    RL_Reward <= std_logic_vector(reward);

end Behavioral;
