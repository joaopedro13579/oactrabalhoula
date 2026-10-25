library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ularv is
    generic (
        WSIZE : natural := 32
    );
    port (
        opcode : in  STD_LOGIC_VECTOR(3 downto 0);
        A      : in  STD_LOGIC_VECTOR(WSIZE-1 downto 0);
        B      : in  STD_LOGIC_VECTOR(WSIZE-1 downto 0);
        Z      : out STD_LOGIC_VECTOR(WSIZE-1 downto 0);
        cond   : out STD_LOGIC
    );
end entity ularv;

architecture comportamento of ularv is
begin

    process(opcode, A, B)
        variable resultado : STD_LOGIC_VECTOR(WSIZE-1 downto 0);
        variable condicao  : STD_LOGIC;
        variable shamt     : natural;
    begin
        resultado := (others => '0');
        condicao  := '0';

        -- O RISC-V usa os 5 bits menos significativos de B
        -- para definir o deslocamento de uma palavra de 32 bits.
        shamt := to_integer(unsigned(B(4 downto 0)));

        case opcode is

            -- ADD: A + B
            when "0000" =>
                resultado := STD_LOGIC_VECTOR(
                    unsigned(A) + unsigned(B)
                );

            -- SUB: A - B
            when "0001" =>
                resultado := STD_LOGIC_VECTOR(
                    unsigned(A) - unsigned(B)
                );

            -- AND
            when "0010" =>
                resultado := A and B;

            -- OR
            when "0011" =>
                resultado := A or B;

            -- XOR
            when "0100" =>
                resultado := A xor B;

            -- SLL: deslocamento logico a esquerda
            when "0101" =>
                resultado := STD_LOGIC_VECTOR(
                    shift_left(unsigned(A), shamt)
                );

            -- SRL: deslocamento logico a direita
            when "0110" =>
                resultado := STD_LOGIC_VECTOR(
                    shift_right(unsigned(A), shamt)
                );

            -- SRA: deslocamento aritmetico a direita
            when "0111" =>
                resultado := STD_LOGIC_VECTOR(
                    shift_right(signed(A), shamt)
                );

            -- SLT: menor que, com sinal
            when "1000" =>
                if signed(A) < signed(B) then
                    resultado(0) := '1';
                    condicao := '1';
                end if;

            -- SLTU: menor que, sem sinal
            when "1001" =>
                if unsigned(A) < unsigned(B) then
                    resultado(0) := '1';
                    condicao := '1';
                end if;

            -- SGE: maior ou igual, com sinal
            when "1010" =>
                if signed(A) >= signed(B) then
                    resultado(0) := '1';
                    condicao := '1';
                end if;

            -- SGEU: maior ou igual, sem sinal
            when "1011" =>
                if unsigned(A) >= unsigned(B) then
                    resultado(0) := '1';
                    condicao := '1';
                end if;

            -- SEQ: igual
            when "1100" =>
                if A = B then
                    resultado(0) := '1';
                    condicao := '1';
                end if;

            -- SNE: diferente
            when "1101" =>
                if A /= B then
                    resultado(0) := '1';
                    condicao := '1';
                end if;

            -- Opcode nao utilizado
            when others =>
                resultado := (others => '0');
                condicao := '0';

        end case;

        Z    <= resultado;
        cond <= condicao;

    end process;

end architecture comportamento;