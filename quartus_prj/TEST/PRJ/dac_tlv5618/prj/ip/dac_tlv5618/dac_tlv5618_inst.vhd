	component dac_tlv5618 is
		port (
			source : out std_logic_vector(15 downto 0)   -- source
		);
	end component dac_tlv5618;

	u0 : component dac_tlv5618
		port map (
			source => CONNECTED_TO_source  -- sources.source
		);

