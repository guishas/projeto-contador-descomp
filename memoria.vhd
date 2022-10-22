library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoria is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);
	
  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";
  constant GRT  : std_logic_vector(3 downto 0) := "1011";
  constant JGT  : std_logic_vector(3 downto 0) := "1100";

	
  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:	
tmp(0) := JSR & "111000101"; -- JSR %SETUP
tmp(1) := LDA & "101100000"; -- LDA @352
tmp(2) := CEQ & "000000111"; -- CEQ @7
tmp(3) := JEQ & "000000101"; -- JEQ %KEYZERO
tmp(4) := JMP & "000001110"; -- JMP %LERKEYONE
tmp(5) := STA & "111111111"; -- STA @511
tmp(6) := LDA & "101000010"; -- LDA @322
tmp(7) := CEQ & "000000111"; -- CEQ @7
tmp(8) := JEQ & "000001010"; -- JEQ %GOTOREGRESSOR
tmp(9) := JMP & "000001100"; -- JMP %GOTOCONTADOR
tmp(10) := JSR & "100011110"; -- JSR %REGRESSOR
tmp(11) := JMP & "000001110"; -- JMP %LERKEYONE
tmp(12) := JSR & "011000000"; -- JSR %CONTADOR
tmp(13) := JSR & "101101101"; -- JSR %CHECALIMITE
tmp(14) := LDA & "101100001"; -- LDA @353
tmp(15) := CEQ & "000000111"; -- CEQ @7
tmp(16) := JEQ & "000010010"; -- JEQ %KEYONE
tmp(17) := JMP & "000011001"; -- JMP %LERFPGARESET
tmp(18) := STA & "111111110"; -- STA @510
tmp(19) := JSR & "000101100"; -- JSR %LIMITE
tmp(20) := STA & "111111101"; -- STA @509
tmp(21) := LDA & "000010000"; -- LDA @16
tmp(22) := CEQ & "000000111"; -- CEQ @7
tmp(23) := JEQ & "000011001"; -- JEQ %LERFPGARESET
tmp(24) := JSR & "110100011"; -- JSR %ATUALIZAHEXCONT
tmp(25) := LDA & "101100100"; -- LDA @356
tmp(26) := CEQ & "000000110"; -- CEQ @6
tmp(27) := JEQ & "000011101"; -- JEQ %FPGARESET
tmp(28) := JMP & "000011110"; -- JMP %LERKEYTWO
tmp(29) := JSR & "110001010"; -- JSR %RESETACONT
tmp(30) := LDA & "101100010"; -- LDA @354
tmp(31) := CEQ & "000000111"; -- CEQ @7
tmp(32) := JEQ & "000100010"; -- JEQ %KEYTWO
tmp(33) := JMP & "000000001"; -- JMP %COMECO
tmp(34) := STA & "111111101"; -- STA @509
tmp(35) := LDA & "000010000"; -- LDA @16
tmp(36) := CEQ & "000000111"; -- CEQ @7
tmp(37) := JEQ & "000011001"; -- JEQ %LERFPGARESET
tmp(38) := JSR & "001110101"; -- JSR %SETINIT
tmp(39) := STA & "111111110"; -- STA @510
tmp(40) := JSR & "110110001"; -- JSR %ATUALIZAHEXREG
tmp(41) := NOP & "000000000"; -- NOP
tmp(42) := JMP & "000000001"; -- JMP %COMECO

-- LIMITE
tmp(44) := LDA & "000010000"; -- LDA @16
tmp(45) := CEQ & "000000111"; -- CEQ @7
tmp(46) := JEQ & "001110010"; -- JEQ %BLOCKLIMITE
tmp(47) := LDA & "000000111"; -- LDA @7
tmp(48) := STA & "100000010"; -- STA @258
tmp(49) := LDA & "101100001"; -- LDA @353
tmp(50) := CEQ & "000000110"; -- CEQ @6
tmp(51) := JEQ & "000110001"; -- JEQ %UNIDADE
tmp(52) := STA & "111111110"; -- STA @510
tmp(53) := LDA & "101000000"; -- LDA @320
tmp(54) := GRT & "000001001"; -- GRT @9
tmp(55) := JGT & "000110001"; -- JGT %UNIDADE
tmp(56) := STA & "000001010"; -- STA @10
tmp(57) := STA & "100100000"; -- STA @288
tmp(58) := JMP & "000111011"; -- JMP %DEZENA
tmp(59) := LDA & "101100001"; -- LDA @353
tmp(60) := CEQ & "000000110"; -- CEQ @6
tmp(61) := JEQ & "000111011"; -- JEQ %DEZENA
tmp(62) := STA & "111111110"; -- STA @510
tmp(63) := LDA & "101000000"; -- LDA @320
tmp(64) := GRT & "000001001"; -- GRT @9
tmp(65) := JGT & "000111011"; -- JGT %DEZENA
tmp(66) := STA & "000001011"; -- STA @11
tmp(67) := STA & "100100001"; -- STA @289
tmp(68) := JMP & "001000101"; -- JMP %CENTENA
tmp(69) := LDA & "101100001"; -- LDA @353
tmp(70) := CEQ & "000000110"; -- CEQ @6
tmp(71) := JEQ & "001000101"; -- JEQ %CENTENA
tmp(72) := STA & "111111110"; -- STA @510
tmp(73) := LDA & "101000000"; -- LDA @320
tmp(74) := GRT & "000001001"; -- GRT @9
tmp(75) := JGT & "001000101"; -- JGT %CENTENA
tmp(76) := STA & "000001100"; -- STA @12
tmp(77) := STA & "100100010"; -- STA @290
tmp(78) := JMP & "001001111"; -- JMP %UNIMIL
tmp(79) := LDA & "101100001"; -- LDA @353
tmp(80) := CEQ & "000000110"; -- CEQ @6
tmp(81) := JEQ & "001001111"; -- JEQ %UNIMIL
tmp(82) := STA & "111111110"; -- STA @510
tmp(83) := LDA & "101000000"; -- LDA @320
tmp(84) := GRT & "000001001"; -- GRT @9
tmp(85) := JGT & "001001111"; -- JGT %UNIMIL
tmp(86) := STA & "000001101"; -- STA @13
tmp(87) := STA & "100100011"; -- STA @291
tmp(88) := JMP & "001011001"; -- JMP %DEZMIL
tmp(89) := LDA & "101100001"; -- LDA @353
tmp(90) := CEQ & "000000110"; -- CEQ @6
tmp(91) := JEQ & "001011001"; -- JEQ %DEZMIL
tmp(92) := STA & "111111110"; -- STA @510
tmp(93) := LDA & "101000000"; -- LDA @320
tmp(94) := GRT & "000001001"; -- GRT @9
tmp(95) := JGT & "001011001"; -- JGT %DEZMIL
tmp(96) := STA & "000001110"; -- STA @14
tmp(97) := STA & "100100100"; -- STA @292
tmp(98) := JMP & "001100011"; -- JMP %CENMIL
tmp(99) := LDA & "101100001"; -- LDA @353
tmp(100) := CEQ & "000000110"; -- CEQ @6
tmp(101) := JEQ & "001100011"; -- JEQ %CENMIL
tmp(102) := STA & "111111110"; -- STA @510
tmp(103) := LDA & "101000000"; -- LDA @320
tmp(104) := GRT & "000001001"; -- GRT @9
tmp(105) := JGT & "001100011"; -- JGT %CENMIL
tmp(106) := STA & "000001111"; -- STA @15
tmp(107) := STA & "100100101"; -- STA @293
tmp(108) := LDA & "101100001"; -- LDA @353
tmp(109) := CEQ & "000000110"; -- CEQ @6
tmp(110) := JEQ & "001101100"; -- JEQ %ENDLIMITE
tmp(111) := STA & "111111110"; -- STA @510
tmp(112) := LDA & "000000110"; -- LDA @6
tmp(113) := STA & "100000010"; -- STA @258
tmp(114) := NOP & "000000000"; -- NOP
tmp(115) := RET & "000000000"; -- RET

-- SETINIT
tmp(117) := LDA & "000010000"; -- LDA @16
tmp(118) := CEQ & "000000111"; -- CEQ @7
tmp(119) := JEQ & "010111011"; -- JEQ %BLOCKREGRESSIVO
tmp(120) := LDA & "000000111"; -- LDA @7
tmp(121) := STA & "100000000"; -- STA @256
tmp(122) := LDA & "101100010"; -- LDA @354
tmp(123) := CEQ & "000000110"; -- CEQ @6
tmp(124) := JEQ & "001111010"; -- JEQ %SETUNIDADE
tmp(125) := STA & "111111101"; -- STA @509
tmp(126) := LDA & "101000000"; -- LDA @320
tmp(127) := GRT & "000001001"; -- GRT @9
tmp(128) := JGT & "001111010"; -- JGT %SETUNIDADE
tmp(129) := STA & "000010100"; -- STA @20
tmp(130) := STA & "100100000"; -- STA @288
tmp(131) := JMP & "010000100"; -- JMP %SETDEZENA
tmp(132) := LDA & "101100010"; -- LDA @354
tmp(133) := CEQ & "000000110"; -- CEQ @6
tmp(134) := JEQ & "010000100"; -- JEQ %SETDEZENA
tmp(135) := STA & "111111101"; -- STA @509
tmp(136) := LDA & "101000000"; -- LDA @320
tmp(137) := GRT & "000001001"; -- GRT @9
tmp(138) := JGT & "010000100"; -- JGT %SETDEZENA
tmp(139) := STA & "000010101"; -- STA @21
tmp(140) := STA & "100100001"; -- STA @289
tmp(141) := JMP & "010001110"; -- JMP %SETCENTENA
tmp(142) := LDA & "101100010"; -- LDA @354
tmp(143) := CEQ & "000000110"; -- CEQ @6
tmp(144) := JEQ & "010001110"; -- JEQ %SETCENTENA
tmp(145) := STA & "111111101"; -- STA @509
tmp(146) := LDA & "101000000"; -- LDA @320
tmp(147) := GRT & "000001001"; -- GRT @9
tmp(148) := JGT & "010001110"; -- JGT %SETCENTENA
tmp(149) := STA & "000010110"; -- STA @22
tmp(150) := STA & "100100010"; -- STA @290
tmp(151) := JMP & "010011000"; -- JMP %SETUNIMIL
tmp(152) := LDA & "101100010"; -- LDA @354
tmp(153) := CEQ & "000000110"; -- CEQ @6
tmp(154) := JEQ & "010011000"; -- JEQ %SETUNIMIL
tmp(155) := STA & "111111101"; -- STA @509
tmp(156) := LDA & "101000000"; -- LDA @320
tmp(157) := GRT & "000001001"; -- GRT @9
tmp(158) := JGT & "010011000"; -- JGT %SETUNIMIL
tmp(159) := STA & "000010111"; -- STA @23
tmp(160) := STA & "100100011"; -- STA @291
tmp(161) := JMP & "010100010"; -- JMP %SETDEZMIL
tmp(162) := LDA & "101100010"; -- LDA @354
tmp(163) := CEQ & "000000110"; -- CEQ @6
tmp(164) := JEQ & "010100010"; -- JEQ %SETDEZMIL
tmp(165) := STA & "111111101"; -- STA @509
tmp(166) := LDA & "101000000"; -- LDA @320
tmp(167) := GRT & "000001001"; -- GRT @9
tmp(168) := JGT & "010100010"; -- JGT %SETDEZMIL
tmp(169) := STA & "000011000"; -- STA @24
tmp(170) := STA & "100100100"; -- STA @292
tmp(171) := JMP & "010101100"; -- JMP %SETCENMIL
tmp(172) := LDA & "101100010"; -- LDA @354
tmp(173) := CEQ & "000000110"; -- CEQ @6
tmp(174) := JEQ & "010101100"; -- JEQ %SETCENMIL
tmp(175) := STA & "111111101"; -- STA @509
tmp(176) := LDA & "101000000"; -- LDA @320
tmp(177) := GRT & "000001001"; -- GRT @9
tmp(178) := JGT & "010101100"; -- JGT %SETCENMIL
tmp(179) := STA & "000011001"; -- STA @25
tmp(180) := STA & "100100101"; -- STA @293
tmp(181) := LDA & "101100010"; -- LDA @354
tmp(182) := CEQ & "000000110"; -- CEQ @6
tmp(183) := JEQ & "010110101"; -- JEQ %SETENDREGRESSIVO
tmp(184) := STA & "111111101"; -- STA @509
tmp(185) := LDA & "000000110"; -- LDA @6
tmp(186) := STA & "100000010"; -- STA @258
tmp(187) := LDA & "000000110"; -- LDA @6
tmp(188) := STA & "100000000"; -- STA @256
tmp(189) := NOP & "000000000"; -- NOP
tmp(190) := RET & "000000000"; -- RET

-- CONTADOR
tmp(192) := LDA & "000010000"; -- LDA @16
tmp(193) := CEQ & "000000111"; -- CEQ @7
tmp(194) := JEQ & "100010000"; -- JEQ %ESTOROULIMITE
tmp(195) := LDA & "000000000"; -- LDA @0
tmp(196) := SOMA & "000000111"; -- SOMA @7
tmp(197) := CEQ & "000001000"; -- CEQ @8
tmp(198) := JEQ & "011001010"; -- JEQ %INCDEZ
tmp(199) := STA & "000000000"; -- STA @0
tmp(200) := STA & "100100000"; -- STA @288
tmp(201) := JMP & "100011011"; -- JMP %FIMCONT
tmp(202) := LDA & "000000110"; -- LDA @6
tmp(203) := STA & "000000000"; -- STA @0
tmp(204) := STA & "100100000"; -- STA @288
tmp(205) := LDA & "000000001"; -- LDA @1
tmp(206) := SOMA & "000000111"; -- SOMA @7
tmp(207) := CEQ & "000001000"; -- CEQ @8
tmp(208) := JEQ & "011010100"; -- JEQ %INCCEN
tmp(209) := STA & "000000001"; -- STA @1
tmp(210) := STA & "100100001"; -- STA @289
tmp(211) := JMP & "100011011"; -- JMP %FIMCONT
tmp(212) := LDA & "000000110"; -- LDA @6
tmp(213) := STA & "000000000"; -- STA @0
tmp(214) := STA & "000000001"; -- STA @1
tmp(215) := STA & "100100000"; -- STA @288
tmp(216) := STA & "100100001"; -- STA @289
tmp(217) := LDA & "000000010"; -- LDA @2
tmp(218) := SOMA & "000000111"; -- SOMA @7
tmp(219) := CEQ & "000001000"; -- CEQ @8
tmp(220) := JEQ & "011100000"; -- JEQ %INCUNIMIL
tmp(221) := STA & "000000010"; -- STA @2
tmp(222) := STA & "100100010"; -- STA @290
tmp(223) := JMP & "100011011"; -- JMP %FIMCONT
tmp(224) := LDA & "000000110"; -- LDA @6
tmp(225) := STA & "000000000"; -- STA @0
tmp(226) := STA & "000000001"; -- STA @1
tmp(227) := STA & "000000010"; -- STA @2
tmp(228) := STA & "100100000"; -- STA @288
tmp(229) := STA & "100100001"; -- STA @289
tmp(230) := STA & "100100010"; -- STA @290
tmp(231) := LDA & "000000011"; -- LDA @3
tmp(232) := SOMA & "000000111"; -- SOMA @7
tmp(233) := CEQ & "000001000"; -- CEQ @8
tmp(234) := JEQ & "011101110"; -- JEQ %INCDEZMIL
tmp(235) := STA & "000000011"; -- STA @3
tmp(236) := STA & "100100011"; -- STA @291
tmp(237) := JMP & "100011011"; -- JMP %FIMCONT
tmp(238) := LDA & "000000110"; -- LDA @6
tmp(239) := STA & "000000000"; -- STA @0
tmp(240) := STA & "000000001"; -- STA @1
tmp(241) := STA & "000000010"; -- STA @2
tmp(242) := STA & "000000011"; -- STA @3
tmp(243) := STA & "100100000"; -- STA @288
tmp(244) := STA & "100100001"; -- STA @289
tmp(245) := STA & "100100010"; -- STA @290
tmp(246) := STA & "100100011"; -- STA @291
tmp(247) := LDA & "000000100"; -- LDA @4
tmp(248) := SOMA & "000000111"; -- SOMA @7
tmp(249) := CEQ & "000001000"; -- CEQ @8
tmp(250) := JEQ & "011111110"; -- JEQ %INCCENMIL
tmp(251) := STA & "000000100"; -- STA @4
tmp(252) := STA & "100100100"; -- STA @292
tmp(253) := JMP & "100011011"; -- JMP %FIMCONT
tmp(254) := LDA & "000000110"; -- LDA @6
tmp(255) := STA & "000000000"; -- STA @0
tmp(256) := STA & "000000001"; -- STA @1
tmp(257) := STA & "000000010"; -- STA @2
tmp(258) := STA & "000000011"; -- STA @3
tmp(259) := STA & "000000100"; -- STA @4
tmp(260) := STA & "100100000"; -- STA @288
tmp(261) := STA & "100100001"; -- STA @289
tmp(262) := STA & "100100010"; -- STA @290
tmp(263) := STA & "100100011"; -- STA @291
tmp(264) := STA & "100100100"; -- STA @292
tmp(265) := LDA & "000000101"; -- LDA @5
tmp(266) := SOMA & "000000111"; -- SOMA @7
tmp(267) := CEQ & "000001000"; -- CEQ @8
tmp(268) := JEQ & "100011011"; -- JEQ %FIMCONT
tmp(269) := STA & "000000101"; -- STA @5
tmp(270) := STA & "100100101"; -- STA @293
tmp(271) := JMP & "100011011"; -- JMP %FIMCONT
tmp(272) := LDI & "011111111"; -- LDI $255
tmp(273) := STA & "100000000"; -- STA @256
tmp(274) := LDA & "000000111"; -- LDA @7
tmp(275) := STA & "100000010"; -- STA @258
tmp(276) := LDI & "000001111"; -- LDI $15
tmp(277) := STA & "100100000"; -- STA @288
tmp(278) := STA & "100100001"; -- STA @289
tmp(279) := STA & "100100010"; -- STA @290
tmp(280) := STA & "100100011"; -- STA @291
tmp(281) := STA & "100100100"; -- STA @292
tmp(282) := STA & "100100101"; -- STA @293
tmp(283) := NOP & "000000000"; -- NOP
tmp(284) := RET & "000000000"; -- RET

-- REGRESSOR
tmp(286) := LDA & "000000000"; -- LDA @0
tmp(287) := CEQ & "000000110"; -- CEQ @6
tmp(288) := JEQ & "100100101"; -- JEQ %SUBDEZ
tmp(289) := SUB & "000000111"; -- SUB @7
tmp(290) := STA & "000000000"; -- STA @0
tmp(291) := STA & "100100000"; -- STA @288
tmp(292) := JMP & "101101011"; -- JMP %FIMCONTREG
tmp(293) := LDA & "000000001"; -- LDA @1
tmp(294) := CEQ & "000000110"; -- CEQ @6
tmp(295) := JEQ & "100101111"; -- JEQ %SUBCEN
tmp(296) := SUB & "000000111"; -- SUB @7
tmp(297) := STA & "000000001"; -- STA @1
tmp(298) := STA & "100100001"; -- STA @289
tmp(299) := LDA & "000001001"; -- LDA @9
tmp(300) := STA & "000000000"; -- STA @0
tmp(301) := STA & "100100000"; -- STA @288
tmp(302) := JMP & "101101011"; -- JMP %FIMCONTREG
tmp(303) := LDA & "000000010"; -- LDA @2
tmp(304) := CEQ & "000000110"; -- CEQ @6
tmp(305) := JEQ & "100111011"; -- JEQ %SUBUNIMIL
tmp(306) := SUB & "000000111"; -- SUB @7
tmp(307) := STA & "000000010"; -- STA @2
tmp(308) := STA & "100100010"; -- STA @290
tmp(309) := LDA & "000001001"; -- LDA @9
tmp(310) := STA & "000000001"; -- STA @1
tmp(311) := STA & "100100001"; -- STA @289
tmp(312) := STA & "000000000"; -- STA @0
tmp(313) := STA & "100100000"; -- STA @288
tmp(314) := JMP & "101101011"; -- JMP %FIMCONTREG
tmp(315) := LDA & "000000011"; -- LDA @3
tmp(316) := CEQ & "000000110"; -- CEQ @6
tmp(317) := JEQ & "101001001"; -- JEQ %SUBDEZMIL
tmp(318) := SUB & "000000111"; -- SUB @7
tmp(319) := STA & "000000011"; -- STA @3
tmp(320) := STA & "100100011"; -- STA @291
tmp(321) := LDA & "000001001"; -- LDA @9
tmp(322) := STA & "000000010"; -- STA @2
tmp(323) := STA & "100100010"; -- STA @290
tmp(324) := STA & "000000001"; -- STA @1
tmp(325) := STA & "100100001"; -- STA @289
tmp(326) := STA & "000000000"; -- STA @0
tmp(327) := STA & "100100000"; -- STA @288
tmp(328) := JMP & "101101011"; -- JMP %FIMCONTREG
tmp(329) := LDA & "000000100"; -- LDA @4
tmp(330) := CEQ & "000000110"; -- CEQ @6
tmp(331) := JEQ & "101011001"; -- JEQ %SUBCENMIL
tmp(332) := SUB & "000000111"; -- SUB @7
tmp(333) := STA & "000000100"; -- STA @4
tmp(334) := STA & "100100100"; -- STA @292
tmp(335) := LDA & "000001001"; -- LDA @9
tmp(336) := STA & "000000011"; -- STA @3
tmp(337) := STA & "100100011"; -- STA @291
tmp(338) := STA & "000000010"; -- STA @2
tmp(339) := STA & "100100010"; -- STA @290
tmp(340) := STA & "000000001"; -- STA @1
tmp(341) := STA & "100100001"; -- STA @289
tmp(342) := STA & "000000000"; -- STA @0
tmp(343) := STA & "100100000"; -- STA @288
tmp(344) := JMP & "101101011"; -- JMP %FIMCONTREG
tmp(345) := LDA & "000000101"; -- LDA @5
tmp(346) := CEQ & "000000110"; -- CEQ @6
tmp(347) := JEQ & "101101011"; -- JEQ %FIMCONTREG
tmp(348) := SUB & "000000111"; -- SUB @7
tmp(349) := STA & "000000101"; -- STA @5
tmp(350) := STA & "100100101"; -- STA @293
tmp(351) := LDA & "000001001"; -- LDA @9
tmp(352) := STA & "000000100"; -- STA @4
tmp(353) := STA & "100100100"; -- STA @292
tmp(354) := STA & "000000011"; -- STA @3
tmp(355) := STA & "100100011"; -- STA @291
tmp(356) := STA & "000000010"; -- STA @2
tmp(357) := STA & "100100010"; -- STA @290
tmp(358) := STA & "000000001"; -- STA @1
tmp(359) := STA & "100100001"; -- STA @289
tmp(360) := STA & "000000000"; -- STA @0
tmp(361) := STA & "100100000"; -- STA @288
tmp(362) := JMP & "101101011"; -- JMP %FIMCONTREG
tmp(363) := RET & "000000000"; -- RET

-- CHECALIMITE
tmp(365) := LDA & "000000000"; -- LDA @0
tmp(366) := CEQ & "000001010"; -- CEQ @10
tmp(367) := JEQ & "101110001"; -- JEQ %CHECADEZENA
tmp(368) := JMP & "110001000"; -- JMP %FIMCHECALIMITE
tmp(369) := LDA & "000000001"; -- LDA @1
tmp(370) := CEQ & "000001011"; -- CEQ @11
tmp(371) := JEQ & "101110101"; -- JEQ %CHECACENTENA
tmp(372) := JMP & "110001000"; -- JMP %FIMCHECALIMITE
tmp(373) := LDA & "000000010"; -- LDA @2
tmp(374) := CEQ & "000001100"; -- CEQ @12
tmp(375) := JEQ & "101111001"; -- JEQ %CHECAUNIMIL
tmp(376) := JMP & "110001000"; -- JMP %FIMCHECALIMITE
tmp(377) := LDA & "000000011"; -- LDA @3
tmp(378) := CEQ & "000001101"; -- CEQ @13
tmp(379) := JEQ & "101111101"; -- JEQ %CHECADEZMIL
tmp(380) := JMP & "110001000"; -- JMP %FIMCHECALIMITE
tmp(381) := LDA & "000000100"; -- LDA @4
tmp(382) := CEQ & "000001110"; -- CEQ @14
tmp(383) := JEQ & "110000001"; -- JEQ %CHECACENMIL
tmp(384) := JMP & "110001000"; -- JMP %FIMCHECALIMITE
tmp(385) := LDA & "000000101"; -- LDA @5
tmp(386) := CEQ & "000001111"; -- CEQ @15
tmp(387) := JEQ & "110000101"; -- JEQ %LIMITEIGUAL
tmp(388) := JMP & "110001000"; -- JMP %FIMCHECALIMITE
tmp(389) := LDA & "000000111"; -- LDA @7
tmp(390) := STA & "000010000"; -- STA @16
tmp(391) := STA & "100000001"; -- STA @257
tmp(392) := RET  & "000000000"; -- RET 

-- RESETACONT
tmp(394) := LDA & "000000110"; -- LDA @6
tmp(395) := STA & "000000000"; -- STA @0
tmp(396) := STA & "000000001"; -- STA @1
tmp(397) := STA & "000000010"; -- STA @2
tmp(398) := STA & "000000011"; -- STA @3
tmp(399) := STA & "000000100"; -- STA @4
tmp(400) := STA & "000000101"; -- STA @5
tmp(401) := STA & "000001010"; -- STA @10
tmp(402) := STA & "000001011"; -- STA @11
tmp(403) := STA & "000001100"; -- STA @12
tmp(404) := STA & "000001101"; -- STA @13
tmp(405) := STA & "000001110"; -- STA @14
tmp(406) := STA & "000001111"; -- STA @15
tmp(407) := STA & "100100000"; -- STA @288
tmp(408) := STA & "100100001"; -- STA @289
tmp(409) := STA & "100100010"; -- STA @290
tmp(410) := STA & "100100011"; -- STA @291
tmp(411) := STA & "100100100"; -- STA @292
tmp(412) := STA & "100100101"; -- STA @293
tmp(413) := STA & "000010000"; -- STA @16
tmp(414) := STA & "100000000"; -- STA @256
tmp(415) := STA & "100000001"; -- STA @257
tmp(416) := STA & "100000010"; -- STA @258
tmp(417) := RET & "000000000"; -- RET

-- ATUALIZAHEXCONT
tmp(419) := LDA & "000000000"; -- LDA @0
tmp(420) := STA & "100100000"; -- STA @288
tmp(421) := LDA & "000000001"; -- LDA @1
tmp(422) := STA & "100100001"; -- STA @289
tmp(423) := LDA & "000000010"; -- LDA @2
tmp(424) := STA & "100100010"; -- STA @290
tmp(425) := LDA & "000000011"; -- LDA @3
tmp(426) := STA & "100100011"; -- STA @291
tmp(427) := LDA & "000000100"; -- LDA @4
tmp(428) := STA & "100100100"; -- STA @292
tmp(429) := LDA & "000000101"; -- LDA @5
tmp(430) := STA & "100100101"; -- STA @293
tmp(431) := RET & "000000000"; -- RET

-- ATUALIZAHEXREG
tmp(433) := LDA & "000010100"; -- LDA @20
tmp(434) := STA & "100100000"; -- STA @288
tmp(435) := STA & "000000000"; -- STA @0
tmp(436) := LDA & "000010101"; -- LDA @21
tmp(437) := STA & "100100001"; -- STA @289
tmp(438) := STA & "000000001"; -- STA @1
tmp(439) := LDA & "000010110"; -- LDA @22
tmp(440) := STA & "100100010"; -- STA @290
tmp(441) := STA & "000000010"; -- STA @2
tmp(442) := LDA & "000010111"; -- LDA @23
tmp(443) := STA & "100100011"; -- STA @291
tmp(444) := STA & "000000011"; -- STA @3
tmp(445) := LDA & "000011000"; -- LDA @24
tmp(446) := STA & "100100100"; -- STA @292
tmp(447) := STA & "000000100"; -- STA @4
tmp(448) := LDA & "000011001"; -- LDA @25
tmp(449) := STA & "100100101"; -- STA @293
tmp(450) := STA & "000000101"; -- STA @5
tmp(451) := RET & "000000000"; -- RET

-- SETUP
tmp(453) := LDI & "000000000"; -- LDI $0
tmp(454) := STA & "100100000"; -- STA @288
tmp(455) := STA & "100100001"; -- STA @289
tmp(456) := STA & "100100010"; -- STA @290
tmp(457) := STA & "100100011"; -- STA @291
tmp(458) := STA & "100100100"; -- STA @292
tmp(459) := STA & "100100101"; -- STA @293
tmp(460) := STA & "100000000"; -- STA @256
tmp(461) := STA & "100000001"; -- STA @257
tmp(462) := STA & "100000010"; -- STA @258
tmp(463) := STA & "000000000"; -- STA @0
tmp(464) := STA & "000000001"; -- STA @1
tmp(465) := STA & "000000010"; -- STA @2
tmp(466) := STA & "000000011"; -- STA @3
tmp(467) := STA & "000000100"; -- STA @4
tmp(468) := STA & "000000101"; -- STA @5
tmp(469) := STA & "000000110"; -- STA @6
tmp(470) := STA & "000001010"; -- STA @10
tmp(471) := STA & "000001011"; -- STA @11
tmp(472) := STA & "000001100"; -- STA @12
tmp(473) := STA & "000001101"; -- STA @13
tmp(474) := STA & "000001110"; -- STA @14
tmp(475) := STA & "000001111"; -- STA @15
tmp(476) := STA & "000010000"; -- STA @16
tmp(477) := LDI & "000000001"; -- LDI $1
tmp(478) := STA & "000000111"; -- STA @7
tmp(479) := LDI & "000001010"; -- LDI $10
tmp(480) := STA & "000001000"; -- STA @8
tmp(481) := LDI & "000001001"; -- LDI $9
tmp(482) := STA & "000001001"; -- STA @9
tmp(483) := RET & "000000000"; -- RET


		  return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM(to_integer(unsigned(Endereco)));
end architecture;