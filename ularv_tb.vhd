library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula_tb is
end entity ula_tb;

architecture teste of ula_tb is

    signal A      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal B      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal opcode : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Z      : STD_LOGIC_VECTOR(31 downto 0);
    signal cond   : STD_LOGIC;

begin

    DUT: entity work.ularv
        generic map (
            WSIZE => 32
        )
        port map (
            opcode => opcode,
            A      => A,
            B      => B,
            Z      => Z,
            cond   => cond
        );

    process
    begin

        -- TESTE 1: ADD positivo: 5 + 3 = 8
        A <= x"00000005";
        B <= x"00000003";
        opcode <= "0000";
        wait for 10 ns;
        assert Z = x"00000008" and cond = '0'
            report "Erro no ADD positivo" severity error;

        -- TESTE 2: ADD zero: 5 + (-5) = 0
        A <= x"00000005";
        B <= x"FFFFFFFB";
        wait for 10 ns;
        assert Z = x"00000000"
            report "Erro no ADD com resultado zero" severity error;

        -- TESTE 3: ADD negativo: (-5) + (-3) = -8
        A <= x"FFFFFFFB";
        B <= x"FFFFFFFD";
        wait for 10 ns;
        assert Z = x"FFFFFFF8"
            report "Erro no ADD negativo" severity error;

        -- TESTE 4: SUB positivo: 10 - 3 = 7
        A <= x"0000000A";
        B <= x"00000003";
        opcode <= "0001";
        wait for 10 ns;
        assert Z = x"00000007"
            report "Erro no SUB positivo" severity error;

        -- TESTE 5: SUB negativo: 3 - 5 = -2
        A <= x"00000003";
        B <= x"00000005";
        wait for 10 ns;
        assert Z = x"FFFFFFFE"
            report "Erro no SUB negativo" severity error;

        -- TESTE 6: SUB zero: 5 - 5 = 0
        A <= x"00000005";
        B <= x"00000005";
        wait for 10 ns;
        assert Z = x"00000000"
            report "Erro no SUB com resultado zero" severity error;

        -- TESTE 7: AND: 10 AND 3 = 2
        A <= x"0000000A";
        B <= x"00000003";
        opcode <= "0010";
        wait for 10 ns;
        assert Z = x"00000002"
            report "Erro no AND" severity error;

        -- TESTE 8: OR: 10 OR 3 = 11
        opcode <= "0011";
        wait for 10 ns;
        assert Z = x"0000000B"
            report "Erro no OR" severity error;

        -- TESTE 9: XOR: 10 XOR 3 = 9
        opcode <= "0100";
        wait for 10 ns;
        assert Z = x"00000009"
            report "Erro no XOR" severity error;

        -- TESTE 10: SLL: desloca 80000001 uma posicao a esquerda
        A <= x"80000001";
        B <= x"00000001";
        opcode <= "0101";
        wait for 10 ns;
        assert Z = x"00000002"
            report "Erro no SLL" severity error;

        -- TESTE 11: SRL: deslocamento logico a direita
        opcode <= "0110";
        wait for 10 ns;
        assert Z = x"40000000"
            report "Erro no SRL" severity error;

        -- TESTE 12: SRA: deslocamento aritmetico a direita
        opcode <= "0111";
        wait for 10 ns;
        assert Z = x"C0000000"
            report "Erro no SRA" severity error;

        -- A = -1 com sinal; B = 1
        A <= x"FFFFFFFF";
        B <= x"00000001";

        -- TESTE 13: SLT: -1 < 1 e verdadeiro
        opcode <= "1000";
        wait for 10 ns;
        assert Z = x"00000001" and cond = '1'
            report "Erro no SLT" severity error;

        -- TESTE 14: SLTU: 4294967295 < 1 e falso
        opcode <= "1001";
        wait for 10 ns;
        assert Z = x"00000000" and cond = '0'
            report "Erro no SLTU" severity error;

        -- TESTE 15: SGE: -1 >= 1 e falso
        opcode <= "1010";
        wait for 10 ns;
        assert Z = x"00000000" and cond = '0'
            report "Erro no SGE" severity error;

        -- TESTE 16: SGEU: 4294967295 >= 1 e verdadeiro
        opcode <= "1011";
        wait for 10 ns;
        assert Z = x"00000001" and cond = '1'
            report "Erro no SGEU" severity error;

        -- TESTE 17: SEQ: operandos iguais
        A <= x"00000007";
        B <= x"00000007";
        opcode <= "1100";
        wait for 10 ns;
        assert Z = x"00000001" and cond = '1'
            report "Erro no SEQ" severity error;

        -- TESTE 18: SNE: operandos diferentes
        A <= x"00000007";
        B <= x"00000008";
        opcode <= "1101";
        wait for 10 ns;
        assert Z = x"00000001" and cond = '1'
            report "Erro no SNE" severity error;

        report "Todos os testes foram concluidos!"
            severity note;

        wait;
    end process;

end architecture teste;