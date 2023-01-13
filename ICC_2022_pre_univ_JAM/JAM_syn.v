/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : Q-2019.12
// Date      : Wed Mar 30 11:15:20 2022
/////////////////////////////////////////////////////////////


module JAM_DW01_add_0 ( A, B, CI, SUM, CO );
  input [9:0] A;
  input [9:0] B;
  output [9:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3;
  wire   [9:1] carry;

  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XNOR2X1 U2 ( .A(A[9]), .B(n3), .Y(SUM[9]) );
  XOR2XL U3 ( .A(A[8]), .B(n2), .Y(SUM[8]) );
  XOR2XL U4 ( .A(A[7]), .B(carry[7]), .Y(SUM[7]) );
  XOR2XL U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
  NAND2X1 U6 ( .A(A[8]), .B(n2), .Y(n3) );
  AND2X2 U7 ( .A(A[7]), .B(carry[7]), .Y(n2) );
endmodule


module JAM ( CLK, RST, W, J, Cost, MatchCount, MinCost, Valid );
  output [2:0] W;
  output [2:0] J;
  input [6:0] Cost;
  output [3:0] MatchCount;
  output [9:0] MinCost;
  input CLK, RST;
  output Valid;
  wire   N93, N95, N96, N97, N98, N99, N100, N101, N109, N110, N111, N113,
         n711, n712, n713, n714, n715, n716, n717, n718, n719, n720,
         \arr[0][2] , \arr[0][1] , \arr[0][0] , \arr[1][2] , \arr[1][1] ,
         \arr[1][0] , \arr[2][2] , \arr[2][1] , \arr[2][0] , \arr[3][2] ,
         \arr[3][1] , \arr[3][0] , \arr[4][2] , \arr[4][1] , \arr[4][0] ,
         \arr[5][2] , \arr[5][1] , \arr[5][0] , \arr[6][2] , \arr[6][1] ,
         \arr[6][0] , \arr[7][2] , \arr[7][1] , \arr[7][0] , N114, N115, N116,
         N143, N145, N301, N302, N303, N304, N305, N306, N352, N353, N354,
         N355, N356, N357, N358, N359, N360, N383, N384, N385, N386, N387,
         N388, N389, N390, N391, N392, N394, N496, N497, N498, N499, N500,
         N501, n47, n48, n49, n50, n54, n55, n56, n58, n59, n60, n61, n62, n63,
         n65, n66, n67, n71, n74, n76, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n105, n107, n108, n110, n112, n113, n114, n117,
         n118, n121, n122, n124, n128, n130, n132, n133, n134, n136, n138,
         n139, n141, n142, n144, n145, n146, n147, n148, n151, n152, n153,
         n154, n156, n157, n159, n160, n162, n163, n166, n168, n170, n172,
         n174, n175, n177, n178, n180, n181, n182, n184, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n199, n201,
         n202, n203, n204, n205, n206, n209, n210, n211, n212, n213, n214,
         n216, n217, n218, n219, n221, n223, n224, n226, n227, n228, n230,
         n232, n234, n235, n237, n238, n239, n241, n242, n244, n245, n246,
         n247, n249, n251, n253, n254, n255, n256, n257, n258, n260, n261,
         n262, n263, n264, n265, n266, n267, n269, n270, n271, n272, n273,
         n275, n276, n277, n278, n279, n280, n281, n282, n283, n285, n286,
         n287, n288, n289, n290, n291, n292, n293, n294, n295, n296, n297,
         n298, n300, n301, n302, n304, n305, n306, n307, n308, n309, n310,
         n311, n312, n313, n314, n315, n316, n317, n318, n319, n320, n321,
         n322, n323, n324, n325, n326, n327, n328, n329, n330, n331, n332,
         n333, n334, n337, n338, n339, n340, n341, n342, n343, n344, n345,
         n346, n347, n348, n349, n350, n351, n352, n353, n354, n355, n356,
         n357, n358, n359, n360, n361, n362, n363, n364, n365, n366, n367,
         n368, n369, n370, n371, n372, n373, n374, n375, n376, n377, n378,
         n379, n380, n381, n382, n383, n384, n385, n386, n387, n388, n389,
         n390, n391, n392, n444, n445, n446, n447, n448, n449, n450, n463,
         n464, n465, n466, n467, n468, n470, n471, n472, n473, n474, n475,
         n476, n477, n478, n479, n480, n481, n482, n483, n484, n485, n486,
         n487, n488, n489, n490, n491, n492, n493, n494, n495, n496, n497,
         n498, n499, n504, n505, n506, n507, n508, n509, n511, n512, n513,
         n514, n515, n516, n517, n518, n519, n520, n521, n522, n523, n524,
         n525, n526, n527, n528, n529, n530, n531, n533, n534, n535, n536,
         n537, n538, n539, n540, n541, n542, n543, n544, n545, n546, n547,
         n548, n549, n550, n551, n552, n553, n554, n555, n556, n557, n558,
         n559, n560, n561, n562, n563, n564, n565, n566, n567, n568, n569,
         n570, n571, n572, n573, n574, n575, n576, n577, n578, n579, n580,
         n581, n582, n583, n584, n585, n586, n587, n588, n589, n590, n591,
         n592, n593, n594, n595, n596, n597, n598, n599, n600, n601, n602,
         n603, n604, n605, n606, n607, n608, n609, n610, n611, n612, n613,
         n614, n615, n616, n617, n618, n619, n620, n621, n622, n623, n624,
         n625, n626, n627, n628, n629, n630, n631, n632, n633, n634, n635,
         n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n646,
         n647, n648, n649, n650, n651, n652, n653, n654, n655, n656, n657,
         n658, n659, n660, n661, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n686, n687, n688, n689, n690,
         n691, n692, n693, n694, n695, n696, n697, n698, n699, n700, n701,
         n702, n703, n704, n705, n706, n707, n708;
  wire   [2:0] ns;
  wire   [9:0] Cost_sum;

  JAM_DW01_add_0 add_121 ( .A(Cost_sum), .B({1'b0, 1'b0, 1'b0, Cost}), .CI(
        1'b0), .SUM({N392, N391, N390, N389, N388, N387, N386, N385, N384, 
        N383}) );
  DFFRX1 \Cost_sum_reg[6]  ( .D(n384), .CK(CLK), .RN(n511), .Q(Cost_sum[6]), 
        .QN(n312) );
  DFFRX1 \Cost_sum_reg[8]  ( .D(n382), .CK(CLK), .RN(n511), .Q(Cost_sum[8]), 
        .QN(n310) );
  DFFRX1 \Cost_sum_reg[7]  ( .D(n383), .CK(CLK), .RN(n511), .Q(Cost_sum[7]), 
        .QN(n311) );
  DFFRX1 \Cost_sum_reg[4]  ( .D(n386), .CK(CLK), .RN(n513), .Q(Cost_sum[4]), 
        .QN(n314) );
  DFFRX1 \Cost_sum_reg[5]  ( .D(n385), .CK(CLK), .RN(n511), .Q(Cost_sum[5]), 
        .QN(n313) );
  DFFRX1 \Cost_sum_reg[3]  ( .D(n387), .CK(CLK), .RN(n511), .Q(Cost_sum[3]), 
        .QN(n315) );
  DFFRX1 \Cost_sum_reg[2]  ( .D(n388), .CK(CLK), .RN(n663), .Q(Cost_sum[2]), 
        .QN(n316) );
  DFFRX1 \Cost_sum_reg[1]  ( .D(n390), .CK(CLK), .RN(n663), .Q(Cost_sum[1]), 
        .QN(n317) );
  DFFRX1 \Cost_sum_reg[0]  ( .D(n389), .CK(CLK), .RN(n663), .Q(Cost_sum[0]), 
        .QN(n318) );
  DFFRX1 \arr_reg[0][0]  ( .D(n338), .CK(CLK), .RN(n512), .Q(\arr[0][0] ), 
        .QN(n324) );
  DFFSX2 \arr_reg[1][0]  ( .D(n341), .CK(CLK), .SN(n512), .Q(\arr[1][0] ), 
        .QN(n327) );
  DFFSX2 \arr_reg[5][0]  ( .D(n353), .CK(CLK), .SN(n512), .Q(\arr[5][0] ), 
        .QN(n288) );
  DFFSX2 \arr_reg[3][0]  ( .D(n347), .CK(CLK), .SN(n513), .Q(\arr[3][0] ), 
        .QN(n289) );
  DFFSX2 \arr_reg[7][0]  ( .D(n359), .CK(CLK), .SN(n513), .Q(\arr[7][0] ), 
        .QN(n333) );
  DFFRX1 \arr_reg[0][2]  ( .D(n391), .CK(CLK), .RN(n512), .Q(\arr[0][2] ), 
        .QN(n322) );
  DFFRX1 \arr_reg[0][1]  ( .D(n337), .CK(CLK), .RN(n511), .Q(\arr[0][1] ), 
        .QN(n323) );
  DFFSX2 \arr_reg[4][2]  ( .D(n348), .CK(CLK), .SN(n512), .Q(\arr[4][2] ), 
        .QN(n287) );
  DFFSX2 \arr_reg[5][2]  ( .D(n351), .CK(CLK), .SN(n512), .Q(\arr[5][2] ), 
        .QN(n292) );
  DFFSX2 \arr_reg[6][2]  ( .D(n354), .CK(CLK), .SN(n512), .Q(\arr[6][2] ), 
        .QN(n328) );
  DFFSX2 \arr_reg[6][1]  ( .D(n355), .CK(CLK), .SN(n512), .Q(\arr[6][1] ), 
        .QN(n329) );
  DFFSX2 \arr_reg[3][1]  ( .D(n346), .CK(CLK), .SN(n512), .Q(\arr[3][1] ), 
        .QN(n291) );
  DFFSX2 \arr_reg[2][1]  ( .D(n343), .CK(CLK), .SN(n511), .Q(\arr[2][1] ), 
        .QN(n295) );
  DFFRX1 \cs_reg[0]  ( .D(ns[0]), .CK(CLK), .RN(n512), .Q(n450), .QN(n321) );
  DFFSX1 \change_pt_reg[2]  ( .D(n365), .CK(CLK), .SN(n513), .Q(N98), .QN(n307) );
  DFFRX1 \Cost_sum_reg[9]  ( .D(n381), .CK(CLK), .RN(n511), .Q(Cost_sum[9]), 
        .QN(n309) );
  DFFSX1 \MinCost_reg[0]  ( .D(n380), .CK(CLK), .SN(n512), .Q(n719), .QN(n275)
         );
  DFFSX2 \change_pt_reg[1]  ( .D(n366), .CK(CLK), .SN(n513), .Q(N97), .QN(n308) );
  DFFSX1 \MinCost_reg[8]  ( .D(n372), .CK(CLK), .SN(n513), .Q(n713), .QN(n283)
         );
  DFFSX1 \MinCost_reg[3]  ( .D(n377), .CK(CLK), .SN(n512), .Q(n716), .QN(n278)
         );
  DFFSX1 \MinCost_reg[1]  ( .D(n379), .CK(CLK), .SN(n513), .Q(n718), .QN(n276)
         );
  DFFSX1 \MinCost_reg[4]  ( .D(n376), .CK(CLK), .SN(n513), .Q(n715), .QN(n279)
         );
  DFFSX1 \MinCost_reg[6]  ( .D(n374), .CK(CLK), .SN(n513), .QN(n281) );
  DFFSX1 \MinCost_reg[7]  ( .D(n373), .CK(CLK), .SN(n513), .QN(n282) );
  DFFSX1 \MinCost_reg[2]  ( .D(n378), .CK(CLK), .SN(n512), .Q(n717), .QN(n277)
         );
  DFFRX1 \MatchCount_reg[1]  ( .D(n368), .CK(CLK), .RN(n512), .QN(n305) );
  DFFRX1 \MatchCount_reg[0]  ( .D(n369), .CK(CLK), .RN(n513), .Q(n712), .QN(
        n306) );
  DFFRX2 \counter_reg[1]  ( .D(n363), .CK(CLK), .RN(n511), .Q(n449), .QN(n301)
         );
  DFFRX1 \MatchCount_reg[2]  ( .D(n695), .CK(CLK), .RN(n512), .QN(n304) );
  DFFRX1 \MatchCount_reg[3]  ( .D(n370), .CK(CLK), .RN(n511), .Q(n711), .QN(
        n302) );
  DFFRX1 Valid_reg ( .D(n298), .CK(CLK), .RN(n511), .Q(n720), .QN(n297) );
  DFFSX1 \MinCost_reg[5]  ( .D(n375), .CK(CLK), .SN(n513), .Q(n714), .QN(n280)
         );
  DFFRX1 \cs_reg[1]  ( .D(ns[1]), .CK(CLK), .RN(n663), .Q(n706), .QN(n320) );
  DFFSX1 \MinCost_reg[9]  ( .D(n371), .CK(CLK), .SN(n663), .QN(n660) );
  DFFRX2 \arr_reg[1][2]  ( .D(n339), .CK(CLK), .RN(n663), .Q(\arr[1][2] ), 
        .QN(n325) );
  DFFRX2 \arr_reg[3][2]  ( .D(n345), .CK(CLK), .RN(n663), .Q(\arr[3][2] ), 
        .QN(n293) );
  DFFRX2 \arr_reg[1][1]  ( .D(n340), .CK(CLK), .RN(n663), .Q(\arr[1][1] ), 
        .QN(n326) );
  DFFRX2 \change_pt_reg[0]  ( .D(n367), .CK(CLK), .RN(n663), .Q(N96), .QN(N111) );
  DFFRX2 \arr_reg[4][0]  ( .D(n350), .CK(CLK), .RN(n663), .Q(\arr[4][0] ), 
        .QN(n285) );
  DFFRX2 \arr_reg[4][1]  ( .D(n349), .CK(CLK), .RN(n663), .Q(\arr[4][1] ), 
        .QN(n286) );
  DFFRX2 \arr_reg[6][0]  ( .D(n356), .CK(CLK), .RN(n663), .Q(\arr[6][0] ), 
        .QN(n330) );
  DFFRX2 \arr_reg[5][1]  ( .D(n352), .CK(CLK), .RN(n663), .Q(\arr[5][1] ), 
        .QN(n290) );
  DFFRX2 \arr_reg[2][2]  ( .D(n342), .CK(CLK), .RN(n663), .Q(\arr[2][2] ), 
        .QN(n296) );
  DFFRX2 \arr_reg[2][0]  ( .D(n344), .CK(CLK), .RN(n663), .Q(\arr[2][0] ), 
        .QN(n294) );
  DFFSX2 \min_pt_reg[1]  ( .D(n361), .CK(CLK), .SN(n663), .Q(N100), .QN(n565)
         );
  DFFRX2 \min_pt_reg[0]  ( .D(n392), .CK(CLK), .RN(n663), .Q(N99), .QN(n566)
         );
  DFFRX2 \cs_reg[2]  ( .D(ns[2]), .CK(CLK), .RN(n663), .QN(n319) );
  DFFRX2 \counter_reg[0]  ( .D(n364), .CK(CLK), .RN(n663), .Q(N93), .QN(n531)
         );
  DFFSX2 \arr_reg[7][2]  ( .D(n357), .CK(CLK), .SN(n512), .Q(\arr[7][2] ), 
        .QN(n331) );
  DFFSX2 \arr_reg[7][1]  ( .D(n358), .CK(CLK), .SN(n512), .Q(\arr[7][1] ), 
        .QN(n332) );
  DFFSX2 \min_pt_reg[2]  ( .D(n360), .CK(CLK), .SN(n512), .Q(N101), .QN(n334)
         );
  DFFRX1 \counter_reg[2]  ( .D(n362), .CK(CLK), .RN(n663), .Q(N95), .QN(n300)
         );
  NAND2X2 U351 ( .A(n189), .B(n54), .Y(n101) );
  BUFX6 U352 ( .A(N496), .Y(n444) );
  NOR2X2 U353 ( .A(n58), .B(n680), .Y(n189) );
  CLKINVX1 U354 ( .A(n204), .Y(n680) );
  OR2X1 U355 ( .A(n473), .B(n474), .Y(N394) );
  OAI21XL U356 ( .A0(n210), .A1(n707), .B0(n506), .Y(n235) );
  OA21XL U357 ( .A0(n692), .A1(n145), .B0(n681), .Y(n153) );
  OAI22X1 U358 ( .A0(n700), .A1(n56), .B0(n83), .B1(n101), .Y(n82) );
  OAI22XL U359 ( .A0(n332), .A1(n197), .B0(n672), .B1(n202), .Y(n358) );
  CLKBUFX3 U360 ( .A(N96), .Y(n509) );
  OA22X1 U361 ( .A0(n300), .A1(n518), .B0(N95), .B1(n517), .Y(n445) );
  AND2X2 U362 ( .A(n499), .B(n308), .Y(n446) );
  OA22X1 U363 ( .A0(n300), .A1(n522), .B0(N95), .B1(n521), .Y(n447) );
  OA22X1 U364 ( .A0(n584), .A1(n574), .B0(n504), .B1(n573), .Y(n448) );
  CLKINVX1 U365 ( .A(n214), .Y(N110) );
  NOR2X2 U366 ( .A(n301), .B(n531), .Y(n527) );
  NOR2X2 U367 ( .A(n601), .B(n531), .Y(n598) );
  NOR2X2 U368 ( .A(n565), .B(n566), .Y(n561) );
  NOR2X2 U369 ( .A(n565), .B(N99), .Y(n562) );
  NOR3XL U370 ( .A(n565), .B(n334), .C(n566), .Y(n205) );
  INVX4 U371 ( .A(RST), .Y(n663) );
  NOR2X2 U372 ( .A(N98), .B(N97), .Y(n493) );
  OAI211X1 U373 ( .A0(n331), .A1(N114), .B0(n246), .C0(n247), .Y(n204) );
  OAI22X2 U374 ( .A0(n564), .A1(n334), .B0(N101), .B1(n563), .Y(N114) );
  OAI22X1 U375 ( .A0(n548), .A1(n536), .B0(N98), .B1(n535), .Y(N498) );
  OAI222XL U376 ( .A0(N115), .A1(n704), .B0(N114), .B1(n508), .C0(N116), .C1(
        n688), .Y(n265) );
  OAI22X1 U377 ( .A0(n334), .A1(n556), .B0(N101), .B1(n555), .Y(N115) );
  BUFX12 U378 ( .A(n714), .Y(MinCost[5]) );
  OAI21XL U379 ( .A0(n444), .A1(n331), .B0(n253), .Y(n246) );
  OAI22X1 U380 ( .A0(n547), .A1(n548), .B0(N98), .B1(n546), .Y(N496) );
  BUFX12 U381 ( .A(n720), .Y(Valid) );
  BUFX12 U382 ( .A(n711), .Y(MatchCount[3]) );
  INVX16 U383 ( .A(n304), .Y(MatchCount[2]) );
  INVX12 U384 ( .A(n301), .Y(W[1]) );
  BUFX12 U385 ( .A(n712), .Y(MatchCount[0]) );
  INVX16 U386 ( .A(n305), .Y(MatchCount[1]) );
  BUFX12 U387 ( .A(n717), .Y(MinCost[2]) );
  OAI22X1 U388 ( .A0(n334), .A1(n552), .B0(N101), .B1(n551), .Y(N116) );
  INVX12 U389 ( .A(n660), .Y(MinCost[9]) );
  INVX12 U390 ( .A(n282), .Y(MinCost[7]) );
  INVX12 U391 ( .A(n281), .Y(MinCost[6]) );
  BUFX12 U392 ( .A(n715), .Y(MinCost[4]) );
  INVX12 U393 ( .A(n276), .Y(MinCost[1]) );
  AO21XL U394 ( .A0(n317), .A1(n643), .B0(n718), .Y(n642) );
  INVX12 U395 ( .A(n278), .Y(MinCost[3]) );
  BUFX12 U396 ( .A(n713), .Y(MinCost[8]) );
  OAI22X2 U397 ( .A0(n548), .A1(n540), .B0(N98), .B1(n539), .Y(N497) );
  CLKINVX1 U398 ( .A(N111), .Y(n514) );
  AOI221XL U399 ( .A0(n674), .A1(n665), .B0(n151), .B1(n677), .C0(n159), .Y(
        n157) );
  NOR2XL U400 ( .A(n333), .B(n153), .Y(n463) );
  NOR2X1 U401 ( .A(n330), .B(n142), .Y(n464) );
  NOR2X1 U402 ( .A(n288), .B(n690), .Y(n465) );
  OR3X2 U403 ( .A(n463), .B(n464), .C(n465), .Y(n159) );
  AND2X2 U404 ( .A(n514), .B(n308), .Y(n542) );
  NOR2X2 U405 ( .A(n308), .B(N111), .Y(n544) );
  INVX1 U406 ( .A(n96), .Y(n674) );
  INVXL U407 ( .A(n95), .Y(n677) );
  INVXL U408 ( .A(n89), .Y(n679) );
  NAND2X1 U409 ( .A(n86), .B(n100), .Y(n91) );
  NAND3X1 U410 ( .A(n691), .B(n690), .C(n124), .Y(n105) );
  NOR3X1 U411 ( .A(n466), .B(n467), .C(n468), .Y(n650) );
  CLKINVX1 U412 ( .A(n99), .Y(n681) );
  OAI21X1 U413 ( .A0(n507), .A1(n471), .B0(n86), .Y(n85) );
  NAND2XL U414 ( .A(n680), .B(n82), .Y(n79) );
  NOR2XL U415 ( .A(n204), .B(n58), .Y(n99) );
  NAND2XL U416 ( .A(n82), .B(n204), .Y(n81) );
  INVX1 U417 ( .A(n184), .Y(n670) );
  NAND3BX1 U418 ( .AN(N394), .B(n655), .C(n654), .Y(n658) );
  NOR2BXL U419 ( .AN(Cost_sum[3]), .B(n716), .Y(n657) );
  NOR2XL U420 ( .A(n314), .B(n715), .Y(n656) );
  AOI21XL U421 ( .A0(n241), .A1(n304), .B0(n78), .Y(n238) );
  NOR3X1 U422 ( .A(n696), .B(n306), .C(n707), .Y(n76) );
  NOR2XL U423 ( .A(n310), .B(n713), .Y(n641) );
  NOR2XL U424 ( .A(n313), .B(n714), .Y(n648) );
  AND2XL U425 ( .A(n714), .B(n313), .Y(n466) );
  AND2XL U426 ( .A(n715), .B(n314), .Y(n467) );
  AND2X2 U427 ( .A(n646), .B(n645), .Y(n468) );
  INVX12 U428 ( .A(n275), .Y(MinCost[0]) );
  CLKINVX2 U429 ( .A(n506), .Y(n694) );
  INVX1 U430 ( .A(n168), .Y(n668) );
  INVX1 U431 ( .A(n93), .Y(n675) );
  INVX1 U432 ( .A(n128), .Y(n666) );
  INVX1 U433 ( .A(n92), .Y(n678) );
  CLKINVX1 U434 ( .A(n507), .Y(n692) );
  NAND2BXL U435 ( .AN(n100), .B(n86), .Y(n88) );
  NOR2X1 U436 ( .A(n475), .B(N394), .Y(n241) );
  AOI211XL U437 ( .A0(n196), .A1(n509), .B0(n680), .C0(n205), .Y(n206) );
  NOR3X1 U438 ( .A(N97), .B(n509), .C(n705), .Y(n49) );
  NOR2X1 U439 ( .A(n102), .B(n692), .Y(n122) );
  INVX1 U440 ( .A(n681), .Y(n471) );
  NAND2X1 U441 ( .A(n472), .B(n234), .Y(n78) );
  OA22XL U442 ( .A0(n86), .A1(n327), .B0(n85), .B1(n333), .Y(n97) );
  AOI21XL U443 ( .A0(n241), .A1(n306), .B0(n696), .Y(n234) );
  AOI222XL U444 ( .A0(N353), .A1(n507), .B0(n675), .B1(n671), .C0(N497), .C1(
        n201), .Y(n202) );
  NAND2XL U445 ( .A(Cost_sum[2]), .B(n277), .Y(n654) );
  OA22X1 U446 ( .A0(n530), .A1(n300), .B0(N95), .B1(n529), .Y(n470) );
  OAI211XL U447 ( .A0(n307), .A1(n509), .B0(n145), .C0(n701), .Y(N113) );
  NOR2BXL U448 ( .AN(Cost_sum[0]), .B(n719), .Y(n638) );
  INVX1 U449 ( .A(N97), .Y(n497) );
  NOR3XL U450 ( .A(n509), .B(n308), .C(n705), .Y(n160) );
  NAND3X1 U451 ( .A(n320), .B(n450), .C(n319), .Y(n58) );
  NAND2X1 U452 ( .A(n319), .B(n47), .Y(n223) );
  NOR3X1 U453 ( .A(n566), .B(n565), .C(N101), .Y(n133) );
  NAND3XL U454 ( .A(n307), .B(n308), .C(n509), .Y(n102) );
  NOR3X2 U455 ( .A(n301), .B(n300), .C(n708), .Y(n54) );
  NOR2X2 U456 ( .A(n55), .B(n321), .Y(n224) );
  NOR3X1 U457 ( .A(n566), .B(n334), .C(N100), .Y(n174) );
  NAND3X1 U458 ( .A(N100), .B(N101), .C(n566), .Y(n187) );
  NOR3X2 U459 ( .A(N99), .B(n565), .C(N101), .Y(n108) );
  NAND3X1 U460 ( .A(n565), .B(n566), .C(n334), .Y(n83) );
  OR2X1 U461 ( .A(n707), .B(MatchCount[1]), .Y(n472) );
  INVXL U462 ( .A(n241), .Y(n707) );
  AOI32XL U463 ( .A0(n304), .A1(MatchCount[1]), .A2(n76), .B0(MatchCount[2]), 
        .B1(n78), .Y(n74) );
  NOR2X1 U464 ( .A(Cost_sum[9]), .B(n660), .Y(n473) );
  NOR2X1 U465 ( .A(n661), .B(n653), .Y(n474) );
  INVXL U466 ( .A(n655), .Y(n661) );
  AOI32XL U467 ( .A0(n652), .A1(n662), .A2(n651), .B0(n713), .B1(n310), .Y(
        n653) );
  CLKINVX1 U468 ( .A(n110), .Y(n691) );
  INVX3 U469 ( .A(n637), .Y(n499) );
  NAND2X1 U470 ( .A(n232), .B(n499), .Y(n228) );
  OAI21XL U471 ( .A0(n232), .A1(n499), .B0(n230), .Y(n367) );
  NOR2X2 U472 ( .A(n692), .B(n700), .Y(n110) );
  NOR2X1 U473 ( .A(n99), .B(n122), .Y(n113) );
  CLKINVX1 U474 ( .A(n90), .Y(n676) );
  NOR2X1 U475 ( .A(n147), .B(n110), .Y(n146) );
  NAND2X1 U476 ( .A(n699), .B(n212), .Y(n213) );
  CLKINVX1 U477 ( .A(n235), .Y(n696) );
  CLKINVX1 U478 ( .A(n105), .Y(n664) );
  CLKINVX1 U479 ( .A(n101), .Y(n673) );
  AND2X2 U480 ( .A(n142), .B(n681), .Y(n134) );
  CLKINVX1 U481 ( .A(n197), .Y(n672) );
  CLKINVX1 U482 ( .A(n217), .Y(n687) );
  OA21XL U483 ( .A0(n693), .A1(n697), .B0(n687), .Y(n232) );
  NAND3X1 U484 ( .A(n227), .B(n499), .C(n693), .Y(n230) );
  CLKINVX1 U485 ( .A(n703), .Y(n583) );
  CLKINVX1 U486 ( .A(N110), .Y(n602) );
  CLKINVX1 U487 ( .A(n56), .Y(n698) );
  CLKINVX1 U488 ( .A(n49), .Y(n700) );
  CLKINVX1 U489 ( .A(n122), .Y(n690) );
  OAI2BB1X1 U490 ( .A0N(n701), .A1N(n162), .B0(n507), .Y(n195) );
  INVX1 U491 ( .A(N497), .Y(n704) );
  NAND2X1 U492 ( .A(n189), .B(N114), .Y(n90) );
  OAI211X1 U493 ( .A0(n101), .A1(n187), .B0(n194), .C0(n195), .Y(n184) );
  NAND3X1 U494 ( .A(n698), .B(N111), .C(n196), .Y(n194) );
  NAND2X1 U495 ( .A(n189), .B(n444), .Y(n89) );
  NAND2X1 U496 ( .A(N498), .B(n189), .Y(n95) );
  INVX1 U497 ( .A(N115), .Y(n684) );
  OAI31X1 U498 ( .A0(n58), .A1(n54), .A2(n262), .B0(n223), .Y(n212) );
  AOI22X1 U499 ( .A0(n263), .A1(n264), .B0(n265), .B1(n266), .Y(n262) );
  OAI21XL U500 ( .A0(N304), .A1(n685), .B0(n271), .Y(n263) );
  OAI21XL U501 ( .A0(N114), .A1(n508), .B0(n267), .Y(n266) );
  NAND2X1 U502 ( .A(n189), .B(N116), .Y(n96) );
  NAND2X1 U503 ( .A(n189), .B(N115), .Y(n93) );
  OAI21X1 U504 ( .A0(n101), .A1(n669), .B0(n181), .Y(n168) );
  AOI32X1 U505 ( .A0(n509), .A1(n698), .A2(n166), .B0(n507), .B1(n182), .Y(
        n181) );
  OAI21XL U506 ( .A0(n509), .A1(n701), .B0(n162), .Y(n182) );
  OAI221XL U507 ( .A0(\arr[7][0] ), .A1(n683), .B0(\arr[7][1] ), .B1(n684), 
        .C0(n249), .Y(n251) );
  OAI21X1 U508 ( .A0(n58), .A1(n671), .B0(n681), .Y(n201) );
  OR4X1 U509 ( .A(n659), .B(n658), .C(n657), .D(n656), .Y(n475) );
  OA21X2 U510 ( .A0(n162), .A1(n692), .B0(n163), .Y(n147) );
  AOI32X1 U511 ( .A0(n698), .A1(n499), .A2(n166), .B0(n151), .B1(n673), .Y(
        n163) );
  AOI2BB2X1 U512 ( .B0(n108), .B1(n673), .A0N(n702), .A1N(n56), .Y(n124) );
  OAI2BB1X1 U513 ( .A0N(n508), .A1N(N301), .B0(n269), .Y(n264) );
  OAI221XL U514 ( .A0(N301), .A1(n508), .B0(N302), .B1(n704), .C0(n270), .Y(
        n269) );
  AO22X1 U515 ( .A0(n704), .A1(N302), .B0(N303), .B1(n688), .Y(n270) );
  NAND4X1 U516 ( .A(n691), .B(n690), .C(n142), .D(n144), .Y(n128) );
  OA22X1 U517 ( .A0(n667), .A1(n101), .B0(n145), .B1(n56), .Y(n144) );
  INVXL U518 ( .A(N114), .Y(n685) );
  OAI22XL U519 ( .A0(N497), .A1(n684), .B0(n444), .B1(n685), .Y(n267) );
  OAI211X1 U520 ( .A0(N143), .A1(n508), .B0(n257), .C0(n258), .Y(n227) );
  NAND3XL U521 ( .A(n260), .B(n448), .C(N497), .Y(n257) );
  OAI211XL U522 ( .A0(N497), .A1(n448), .B0(n260), .C0(n261), .Y(n258) );
  OAI32X1 U523 ( .A0(n704), .A1(N500), .A2(n71), .B0(N499), .B1(n508), .Y(n63)
         );
  INVXL U524 ( .A(N116), .Y(n683) );
  OAI21X1 U525 ( .A0(n206), .A1(n56), .B0(n195), .Y(n197) );
  NOR2X1 U526 ( .A(n227), .B(n223), .Y(n217) );
  OAI2BB2XL U527 ( .B0(n272), .B1(n273), .A0N(n685), .A1N(N304), .Y(n271) );
  NOR2XL U528 ( .A(N305), .B(n684), .Y(n273) );
  AOI211X1 U529 ( .A0(N305), .A1(n684), .B0(n683), .C0(N306), .Y(n272) );
  NAND3BX1 U530 ( .AN(n196), .B(n210), .C(n226), .Y(n365) );
  AOI32X1 U531 ( .A0(n49), .A1(n227), .A2(n693), .B0(n228), .B1(n705), .Y(n226) );
  CLKBUFX3 U532 ( .A(n242), .Y(n506) );
  NAND2XL U533 ( .A(N394), .B(n697), .Y(n242) );
  CLKBUFX3 U534 ( .A(n689), .Y(n508) );
  INVXL U535 ( .A(n444), .Y(n689) );
  INVX1 U536 ( .A(N498), .Y(n688) );
  NAND2XL U537 ( .A(N143), .B(n508), .Y(n260) );
  NAND2X1 U538 ( .A(n217), .B(n504), .Y(n209) );
  CLKINVX1 U539 ( .A(N109), .Y(n601) );
  CLKINVX1 U540 ( .A(N109), .Y(n619) );
  AND2X2 U541 ( .A(N499), .B(n508), .Y(n71) );
  INVX1 U542 ( .A(n493), .Y(n496) );
  CLKINVX1 U543 ( .A(n166), .Y(n701) );
  CLKINVX1 U544 ( .A(n504), .Y(n584) );
  NAND2X2 U545 ( .A(n699), .B(n54), .Y(n56) );
  CLKINVX1 U546 ( .A(n488), .Y(n498) );
  CLKBUFX3 U547 ( .A(n98), .Y(n507) );
  NOR2X1 U548 ( .A(n55), .B(n450), .Y(n98) );
  NAND2X1 U549 ( .A(n160), .B(n507), .Y(n142) );
  OAI211X1 U550 ( .A0(n54), .A1(n55), .B0(n56), .C0(n692), .Y(ns[1]) );
  NOR2X1 U551 ( .A(n224), .B(n699), .Y(n219) );
  NAND4X1 U552 ( .A(n219), .B(n210), .C(n223), .D(n692), .Y(n218) );
  NOR2X1 U553 ( .A(n706), .B(n450), .Y(n47) );
  CLKINVX1 U554 ( .A(n174), .Y(n669) );
  CLKINVX1 U555 ( .A(n223), .Y(n693) );
  CLKINVX1 U556 ( .A(n133), .Y(n667) );
  AND4X1 U557 ( .A(n145), .B(n702), .C(n102), .D(n700), .Y(n162) );
  CLKINVX1 U558 ( .A(n58), .Y(n699) );
  CLKINVX1 U559 ( .A(n151), .Y(n665) );
  CLKINVX1 U560 ( .A(n210), .Y(n697) );
  CLKINVX1 U561 ( .A(n160), .Y(n702) );
  CLKINVX1 U562 ( .A(n205), .Y(n671) );
  CLKBUFX3 U563 ( .A(n244), .Y(n505) );
  NAND2BX1 U564 ( .AN(n224), .B(n223), .Y(n244) );
  CLKBUFX3 U565 ( .A(n663), .Y(n512) );
  CLKBUFX3 U566 ( .A(n663), .Y(n511) );
  CLKBUFX3 U567 ( .A(n663), .Y(n513) );
  CLKINVX1 U568 ( .A(n641), .Y(n662) );
  OAI22XL U569 ( .A0(n331), .A1(n197), .B0(n672), .B1(n199), .Y(n357) );
  AOI222XL U570 ( .A0(N354), .A1(n507), .B0(n676), .B1(n671), .C0(n444), .C1(
        n201), .Y(n199) );
  NAND2XL U571 ( .A(n331), .B(N114), .Y(n249) );
  AOI2BB2X1 U572 ( .B0(n217), .B1(n499), .A0N(n212), .A1N(n566), .Y(n256) );
  OAI222XL U573 ( .A0(n331), .A1(n79), .B0(n245), .B1(n81), .C0(n322), .C1(n82), .Y(n391) );
  AOI2BB2XL U574 ( .B0(N114), .B1(n83), .A0N(n508), .A1N(n83), .Y(n245) );
  OAI22XL U575 ( .A0(n287), .A1(n146), .B0(n147), .B1(n148), .Y(n348) );
  AOI221XL U576 ( .A0(n676), .A1(n665), .B0(n151), .B1(n679), .C0(n152), .Y(
        n148) );
  OAI222XL U577 ( .A0(n331), .A1(n153), .B0(n328), .B1(n142), .C0(n292), .C1(
        n690), .Y(n152) );
  OAI222XL U578 ( .A0(n333), .A1(n79), .B0(n84), .B1(n81), .C0(n324), .C1(n82), 
        .Y(n338) );
  AOI2BB2XL U579 ( .B0(N116), .B1(n83), .A0N(n83), .A1N(n688), .Y(n84) );
  OAI222XL U580 ( .A0(n332), .A1(n79), .B0(n80), .B1(n81), .C0(n323), .C1(n82), 
        .Y(n337) );
  AOI2BB2XL U581 ( .B0(N115), .B1(n83), .A0N(n704), .A1N(n83), .Y(n80) );
  OAI221XL U582 ( .A0(n88), .A1(n92), .B0(n91), .B1(n93), .C0(n94), .Y(n340)
         );
  OA22X1 U583 ( .A0(n86), .A1(n326), .B0(n85), .B1(n332), .Y(n94) );
  OAI221XL U584 ( .A0(n88), .A1(n95), .B0(n91), .B1(n96), .C0(n97), .Y(n341)
         );
  OAI22XL U585 ( .A0(n508), .A1(\arr[7][2] ), .B0(n254), .B1(n255), .Y(n253)
         );
  NOR2XL U586 ( .A(N497), .B(n332), .Y(n255) );
  AOI211XL U587 ( .A0(n332), .A1(N497), .B0(n333), .C0(N498), .Y(n254) );
  OAI221XL U588 ( .A0(n331), .A1(n85), .B0(n325), .B1(n86), .C0(n87), .Y(n339)
         );
  OA22X1 U589 ( .A0(n88), .A1(n89), .B0(n90), .B1(n91), .Y(n87) );
  OAI22XL U590 ( .A0(n333), .A1(n197), .B0(n672), .B1(n203), .Y(n359) );
  AOI222XL U591 ( .A0(N352), .A1(n507), .B0(n674), .B1(n671), .C0(N498), .C1(
        n201), .Y(n203) );
  OAI211X1 U592 ( .A0(n213), .A1(n619), .B0(n210), .C0(n216), .Y(n361) );
  AOI2BB2X1 U593 ( .B0(n703), .B1(n217), .A0N(n212), .A1N(n565), .Y(n216) );
  CLKINVX1 U594 ( .A(n221), .Y(n703) );
  OAI22XL U595 ( .A0(n288), .A1(n168), .B0(n668), .B1(n178), .Y(n353) );
  AOI221XL U596 ( .A0(n471), .A1(\arr[7][0] ), .B0(N358), .B1(n507), .C0(n180), 
        .Y(n178) );
  OAI22XL U597 ( .A0(n95), .A1(n669), .B0(n174), .B1(n96), .Y(n180) );
  OAI22XL U598 ( .A0(n292), .A1(n168), .B0(n668), .B1(n170), .Y(n351) );
  AOI221XL U599 ( .A0(n471), .A1(\arr[7][2] ), .B0(N360), .B1(n507), .C0(n172), 
        .Y(n170) );
  OAI22XL U600 ( .A0(n89), .A1(n669), .B0(n174), .B1(n90), .Y(n172) );
  OAI22XL U601 ( .A0(n290), .A1(n168), .B0(n668), .B1(n175), .Y(n352) );
  AOI221XL U602 ( .A0(n471), .A1(\arr[7][1] ), .B0(N359), .B1(n507), .C0(n177), 
        .Y(n175) );
  OAI22XL U603 ( .A0(n92), .A1(n669), .B0(n174), .B1(n93), .Y(n177) );
  OAI22XL U604 ( .A0(n329), .A1(n184), .B0(n670), .B1(n190), .Y(n355) );
  AOI221XL U605 ( .A0(n675), .A1(n187), .B0(N356), .B1(n507), .C0(n191), .Y(
        n190) );
  OAI22XL U606 ( .A0(n332), .A1(n681), .B0(n92), .B1(n187), .Y(n191) );
  OAI22XL U607 ( .A0(n328), .A1(n184), .B0(n670), .B1(n186), .Y(n354) );
  AOI221XL U608 ( .A0(n676), .A1(n187), .B0(N357), .B1(n507), .C0(n188), .Y(
        n186) );
  OAI22XL U609 ( .A0(n331), .A1(n681), .B0(n89), .B1(n187), .Y(n188) );
  OAI22XL U610 ( .A0(n330), .A1(n184), .B0(n670), .B1(n192), .Y(n356) );
  AOI221XL U611 ( .A0(n674), .A1(n187), .B0(N355), .B1(n507), .C0(n193), .Y(
        n192) );
  OAI22XL U612 ( .A0(n333), .A1(n681), .B0(n95), .B1(n187), .Y(n193) );
  OAI22XL U613 ( .A0(n295), .A1(n105), .B0(n664), .B1(n114), .Y(n343) );
  AOI221XL U614 ( .A0(n108), .A1(n678), .B0(n110), .B1(\arr[6][1] ), .C0(n117), 
        .Y(n114) );
  OAI22XL U615 ( .A0(n108), .A1(n93), .B0(n332), .B1(n113), .Y(n117) );
  OAI22XL U616 ( .A0(n291), .A1(n128), .B0(n666), .B1(n136), .Y(n346) );
  AOI221XL U617 ( .A0(n110), .A1(\arr[5][1] ), .B0(n122), .B1(\arr[6][1] ), 
        .C0(n138), .Y(n136) );
  OAI222XL U618 ( .A0(n133), .A1(n93), .B0(n332), .B1(n134), .C0(n92), .C1(
        n667), .Y(n138) );
  OAI22XL U619 ( .A0(n289), .A1(n128), .B0(n666), .B1(n139), .Y(n347) );
  AOI221XL U620 ( .A0(n110), .A1(\arr[5][0] ), .B0(n122), .B1(\arr[6][0] ), 
        .C0(n141), .Y(n139) );
  OAI222XL U621 ( .A0(n133), .A1(n96), .B0(n333), .B1(n134), .C0(n95), .C1(
        n667), .Y(n141) );
  OAI22XL U622 ( .A0(n294), .A1(n105), .B0(n664), .B1(n118), .Y(n344) );
  AOI221XL U623 ( .A0(n108), .A1(n677), .B0(n110), .B1(\arr[6][0] ), .C0(n121), 
        .Y(n118) );
  OAI22XL U624 ( .A0(n108), .A1(n96), .B0(n333), .B1(n113), .Y(n121) );
  OAI22XL U625 ( .A0(n296), .A1(n105), .B0(n664), .B1(n107), .Y(n342) );
  AOI221XL U626 ( .A0(n108), .A1(n679), .B0(n110), .B1(\arr[6][2] ), .C0(n112), 
        .Y(n107) );
  OAI22XL U627 ( .A0(n108), .A1(n90), .B0(n331), .B1(n113), .Y(n112) );
  OAI22XL U628 ( .A0(n293), .A1(n128), .B0(n666), .B1(n130), .Y(n345) );
  AOI221XL U629 ( .A0(n110), .A1(\arr[5][2] ), .B0(n122), .B1(\arr[6][2] ), 
        .C0(n132), .Y(n130) );
  OAI222XL U630 ( .A0(n133), .A1(n90), .B0(n331), .B1(n134), .C0(n89), .C1(
        n667), .Y(n132) );
  OAI22XL U631 ( .A0(n285), .A1(n146), .B0(n147), .B1(n157), .Y(n350) );
  OAI22XL U632 ( .A0(n286), .A1(n146), .B0(n147), .B1(n154), .Y(n349) );
  AOI221XL U633 ( .A0(n675), .A1(n665), .B0(n151), .B1(n678), .C0(n156), .Y(
        n154) );
  OAI222XL U634 ( .A0(n332), .A1(n153), .B0(n329), .B1(n142), .C0(n290), .C1(
        n690), .Y(n156) );
  AOI31X1 U635 ( .A0(n684), .A1(\arr[7][1] ), .A2(n249), .B0(n682), .Y(n247)
         );
  CLKINVX1 U636 ( .A(n251), .Y(n682) );
  OAI21XL U637 ( .A0(n302), .A1(n238), .B0(n239), .Y(n370) );
  NAND4X1 U638 ( .A(n302), .B(n76), .C(MatchCount[1]), .D(MatchCount[2]), .Y(
        n239) );
  NAND3X1 U639 ( .A(n209), .B(n210), .C(n211), .Y(n360) );
  OA22X1 U640 ( .A0(n212), .A1(n334), .B0(n213), .B1(n214), .Y(n211) );
  CLKINVX1 U641 ( .A(n74), .Y(n695) );
  AOI221XL U642 ( .A0(N501), .A1(n688), .B0(N500), .B1(n704), .C0(n71), .Y(n62) );
  INVX12 U643 ( .A(n445), .Y(J[0]) );
  INVX12 U644 ( .A(n447), .Y(J[1]) );
  NOR2X1 U645 ( .A(W[0]), .B(n449), .Y(n524) );
  OAI221XL U646 ( .A0(N97), .A1(n230), .B0(n308), .B1(n686), .C0(n210), .Y(
        n366) );
  CLKINVX1 U647 ( .A(n228), .Y(n686) );
  OAI221XL U648 ( .A0(n54), .A1(n58), .B0(n319), .B1(n321), .C0(n59), .Y(ns[0]) );
  AOI32X1 U649 ( .A0(n321), .A1(n60), .A2(n319), .B0(n61), .B1(n706), .Y(n59)
         );
  NAND2X1 U650 ( .A(n54), .B(n450), .Y(n61) );
  OAI2BB2XL U651 ( .B0(n62), .B1(n63), .A0N(n50), .A1N(n49), .Y(n60) );
  OAI22XL U652 ( .A0(n306), .A1(n235), .B0(n696), .B1(n237), .Y(n369) );
  NOR2XL U653 ( .A(N394), .B(n306), .Y(n237) );
  OAI22XL U654 ( .A0(n275), .A1(n694), .B0(n318), .B1(n506), .Y(n380) );
  OAI22XL U655 ( .A0(n277), .A1(n694), .B0(n316), .B1(n506), .Y(n378) );
  OAI22XL U656 ( .A0(n278), .A1(n694), .B0(n315), .B1(n506), .Y(n377) );
  OAI22XL U657 ( .A0(n279), .A1(n694), .B0(n314), .B1(n506), .Y(n376) );
  OAI22XL U658 ( .A0(n280), .A1(n694), .B0(n313), .B1(n506), .Y(n375) );
  OAI22XL U659 ( .A0(n281), .A1(n694), .B0(n312), .B1(n506), .Y(n374) );
  OAI22XL U660 ( .A0(n282), .A1(n694), .B0(n311), .B1(n506), .Y(n373) );
  OAI22XL U661 ( .A0(n283), .A1(n694), .B0(n310), .B1(n506), .Y(n372) );
  OAI22XL U662 ( .A0(n660), .A1(n694), .B0(n309), .B1(n506), .Y(n371) );
  OAI22XL U663 ( .A0(n276), .A1(n694), .B0(n317), .B1(n506), .Y(n379) );
  INVX12 U664 ( .A(n470), .Y(J[2]) );
  OAI2BB2XL U665 ( .B0(n305), .B1(n234), .A0N(n76), .A1N(n305), .Y(n368) );
  CLKINVX1 U666 ( .A(N98), .Y(n548) );
  OAI222XL U667 ( .A0(n219), .A1(n619), .B0(n301), .B1(n218), .C0(n687), .C1(
        n221), .Y(n363) );
  OAI221XL U668 ( .A0(n300), .A1(n218), .B0(n219), .B1(n214), .C0(n209), .Y(
        n362) );
  OAI2BB2XL U669 ( .B0(n309), .B1(n505), .A0N(N392), .A1N(n224), .Y(n381) );
  OAI2BB2XL U670 ( .B0(n310), .B1(n505), .A0N(N391), .A1N(n224), .Y(n382) );
  OAI2BB2XL U671 ( .B0(n311), .B1(n505), .A0N(N390), .A1N(n224), .Y(n383) );
  CLKXOR2X2 U672 ( .A(n301), .B(n708), .Y(N109) );
  XNOR2X1 U673 ( .A(n308), .B(N111), .Y(n221) );
  NAND2X1 U674 ( .A(N145), .B(n688), .Y(n261) );
  OAI2BB2XL U675 ( .B0(n312), .B1(n505), .A0N(N389), .A1N(n224), .Y(n384) );
  OAI2BB2XL U676 ( .B0(n313), .B1(n505), .A0N(N388), .A1N(n224), .Y(n385) );
  OAI2BB2XL U677 ( .B0(n314), .B1(n505), .A0N(N387), .A1N(n224), .Y(n386) );
  OAI2BB2XL U678 ( .B0(n315), .B1(n505), .A0N(N386), .A1N(n224), .Y(n387) );
  OAI2BB2XL U679 ( .B0(n316), .B1(n505), .A0N(N385), .A1N(n224), .Y(n388) );
  XOR2X1 U680 ( .A(n476), .B(n300), .Y(n214) );
  NOR2X1 U681 ( .A(n301), .B(n708), .Y(n476) );
  BUFX12 U682 ( .A(N95), .Y(W[2]) );
  CLKINVX1 U683 ( .A(n531), .Y(n620) );
  OAI2BB2XL U684 ( .B0(n318), .B1(n505), .A0N(N383), .A1N(n224), .Y(n389) );
  OAI2BB2XL U685 ( .B0(n317), .B1(n505), .A0N(N384), .A1N(n224), .Y(n390) );
  NOR2X1 U686 ( .A(N97), .B(n307), .Y(n166) );
  NAND3X1 U687 ( .A(n307), .B(N97), .C(n509), .Y(n145) );
  CLKINVX1 U688 ( .A(N111), .Y(n637) );
  CLKBUFX3 U689 ( .A(N113), .Y(n504) );
  NAND2X1 U690 ( .A(n319), .B(n706), .Y(n55) );
  CLKINVX1 U691 ( .A(n307), .Y(n705) );
  NAND2BX2 U692 ( .AN(n319), .B(n47), .Y(n210) );
  NOR3X2 U693 ( .A(N99), .B(n334), .C(N100), .Y(n151) );
  NAND3X1 U694 ( .A(n565), .B(N99), .C(n334), .Y(n100) );
  OAI21XL U695 ( .A0(n319), .A1(n47), .B0(n48), .Y(ns[2]) );
  AOI33X1 U696 ( .A0(n49), .A1(n50), .A2(n693), .B0(n450), .B1(n706), .B2(n54), 
        .Y(n48) );
  AOI211X1 U697 ( .A0(n323), .A1(\arr[1][1] ), .B0(\arr[1][0] ), .C0(n324), 
        .Y(n66) );
  OAI31XL U698 ( .A0(n706), .A1(n319), .A2(n321), .B0(n297), .Y(n298) );
  NOR2X1 U699 ( .A(n308), .B(n307), .Y(n196) );
  OAI21XL U700 ( .A0(n322), .A1(\arr[1][2] ), .B0(n65), .Y(n50) );
  OAI2BB2XL U701 ( .B0(n66), .B1(n67), .A0N(\arr[1][2] ), .A1N(n322), .Y(n65)
         );
  NOR2X1 U702 ( .A(n323), .B(\arr[1][1] ), .Y(n67) );
  OAI22XL U703 ( .A0(\arr[4][0] ), .A1(n499), .B0(\arr[3][0] ), .B1(n509), .Y(
        n478) );
  NAND2X1 U704 ( .A(N98), .B(n497), .Y(n488) );
  OAI22XL U705 ( .A0(\arr[6][0] ), .A1(n499), .B0(\arr[5][0] ), .B1(n509), .Y(
        n479) );
  OAI222XL U706 ( .A0(n478), .A1(n496), .B0(n488), .B1(n333), .C0(n479), .C1(
        n497), .Y(N358) );
  OAI22XL U707 ( .A0(\arr[4][1] ), .A1(n499), .B0(\arr[3][1] ), .B1(n637), .Y(
        n481) );
  OAI22XL U708 ( .A0(\arr[6][1] ), .A1(n499), .B0(\arr[5][1] ), .B1(n637), .Y(
        n482) );
  OAI222XL U709 ( .A0(n481), .A1(n496), .B0(n488), .B1(n332), .C0(n482), .C1(
        n497), .Y(N359) );
  OAI22XL U710 ( .A0(\arr[4][2] ), .A1(n499), .B0(\arr[3][2] ), .B1(n637), .Y(
        n486) );
  OAI22XL U711 ( .A0(\arr[6][2] ), .A1(n499), .B0(\arr[5][2] ), .B1(n509), .Y(
        n487) );
  OAI222XL U712 ( .A0(n486), .A1(n496), .B0(n488), .B1(n331), .C0(n487), .C1(
        n497), .Y(N360) );
  NOR2X1 U713 ( .A(n496), .B(n509), .Y(n484) );
  NOR2X1 U714 ( .A(n499), .B(n496), .Y(n483) );
  AOI22X1 U715 ( .A0(\arr[1][0] ), .A1(n484), .B0(n483), .B1(\arr[2][0] ), .Y(
        n477) );
  OAI221XL U716 ( .A0(n479), .A1(n488), .B0(n478), .B1(n497), .C0(n477), .Y(
        N352) );
  AOI22X1 U717 ( .A0(\arr[1][1] ), .A1(n484), .B0(n483), .B1(\arr[2][1] ), .Y(
        n480) );
  OAI221XL U718 ( .A0(n482), .A1(n488), .B0(n481), .B1(n497), .C0(n480), .Y(
        N353) );
  AOI22X1 U719 ( .A0(\arr[1][2] ), .A1(n484), .B0(n483), .B1(\arr[2][2] ), .Y(
        n485) );
  OAI221XL U720 ( .A0(n487), .A1(n488), .B0(n486), .B1(n497), .C0(n485), .Y(
        N354) );
  AOI222XL U721 ( .A0(\arr[5][0] ), .A1(N97), .B0(\arr[7][0] ), .B1(n498), 
        .C0(\arr[3][0] ), .C1(n493), .Y(n490) );
  AOI222XL U722 ( .A0(\arr[4][0] ), .A1(N97), .B0(\arr[6][0] ), .B1(n498), 
        .C0(\arr[2][0] ), .C1(n493), .Y(n489) );
  OAI22XL U723 ( .A0(n499), .A1(n490), .B0(n509), .B1(n489), .Y(N355) );
  AOI222XL U724 ( .A0(\arr[5][1] ), .A1(N97), .B0(\arr[7][1] ), .B1(n498), 
        .C0(\arr[3][1] ), .C1(n493), .Y(n492) );
  AOI222XL U725 ( .A0(\arr[4][1] ), .A1(N97), .B0(\arr[6][1] ), .B1(n498), 
        .C0(\arr[2][1] ), .C1(n493), .Y(n491) );
  OAI22XL U726 ( .A0(n499), .A1(n492), .B0(n509), .B1(n491), .Y(N356) );
  AOI222XL U727 ( .A0(\arr[5][2] ), .A1(N97), .B0(\arr[7][2] ), .B1(n498), 
        .C0(\arr[3][2] ), .C1(n493), .Y(n495) );
  AOI222XL U728 ( .A0(\arr[4][2] ), .A1(N97), .B0(\arr[6][2] ), .B1(n498), 
        .C0(\arr[2][2] ), .C1(n493), .Y(n494) );
  OAI22XL U729 ( .A0(n495), .A1(n499), .B0(n509), .B1(n494), .Y(N357) );
  INVX16 U730 ( .A(n708), .Y(W[0]) );
  INVX3 U731 ( .A(N93), .Y(n708) );
  NAND2X1 U732 ( .A(n189), .B(N497), .Y(n92) );
  OAI222XL U733 ( .A0(W[0]), .A1(n219), .B0(n708), .B1(n218), .C0(n509), .C1(
        n687), .Y(n364) );
  NOR2X2 U734 ( .A(n301), .B(N93), .Y(n528) );
  OAI211XL U735 ( .A0(W[0]), .A1(n213), .B0(n210), .C0(n256), .Y(n392) );
  OAI221X4 U736 ( .A0(n101), .A1(n100), .B0(n56), .B1(n102), .C0(n691), .Y(n86) );
  NOR2X1 U737 ( .A(n531), .B(W[1]), .Y(n525) );
  AO22X1 U738 ( .A0(\arr[5][0] ), .A1(n525), .B0(\arr[4][0] ), .B1(n524), .Y(
        n515) );
  AOI221XL U739 ( .A0(\arr[6][0] ), .A1(n528), .B0(\arr[7][0] ), .B1(n527), 
        .C0(n515), .Y(n518) );
  AO22X1 U740 ( .A0(\arr[1][0] ), .A1(n525), .B0(\arr[0][0] ), .B1(n524), .Y(
        n516) );
  AOI221XL U741 ( .A0(\arr[2][0] ), .A1(n528), .B0(\arr[3][0] ), .B1(n527), 
        .C0(n516), .Y(n517) );
  AO22X1 U742 ( .A0(\arr[5][1] ), .A1(n525), .B0(\arr[4][1] ), .B1(n524), .Y(
        n519) );
  AOI221XL U743 ( .A0(\arr[6][1] ), .A1(n528), .B0(\arr[7][1] ), .B1(n527), 
        .C0(n519), .Y(n522) );
  AO22X1 U744 ( .A0(\arr[1][1] ), .A1(n525), .B0(\arr[0][1] ), .B1(n524), .Y(
        n520) );
  AOI221XL U745 ( .A0(\arr[2][1] ), .A1(n528), .B0(\arr[3][1] ), .B1(n527), 
        .C0(n520), .Y(n521) );
  AO22X1 U746 ( .A0(\arr[5][2] ), .A1(n525), .B0(\arr[4][2] ), .B1(n524), .Y(
        n523) );
  AOI221XL U747 ( .A0(\arr[6][2] ), .A1(n528), .B0(\arr[7][2] ), .B1(n527), 
        .C0(n523), .Y(n530) );
  AO22X1 U748 ( .A0(\arr[1][2] ), .A1(n525), .B0(\arr[0][2] ), .B1(n524), .Y(
        n526) );
  AOI221XL U749 ( .A0(\arr[2][2] ), .A1(n528), .B0(\arr[3][2] ), .B1(n527), 
        .C0(n526), .Y(n529) );
  NOR2X1 U750 ( .A(n308), .B(n514), .Y(n545) );
  AO22X1 U751 ( .A0(\arr[5][0] ), .A1(n542), .B0(\arr[4][0] ), .B1(n446), .Y(
        n533) );
  AOI221XL U752 ( .A0(\arr[6][0] ), .A1(n545), .B0(\arr[7][0] ), .B1(n544), 
        .C0(n533), .Y(n536) );
  AO22X1 U753 ( .A0(\arr[1][0] ), .A1(n542), .B0(\arr[0][0] ), .B1(n446), .Y(
        n534) );
  AOI221XL U754 ( .A0(\arr[2][0] ), .A1(n545), .B0(\arr[3][0] ), .B1(n544), 
        .C0(n534), .Y(n535) );
  AO22X1 U755 ( .A0(\arr[5][1] ), .A1(n542), .B0(\arr[4][1] ), .B1(n446), .Y(
        n537) );
  AOI221XL U756 ( .A0(\arr[6][1] ), .A1(n545), .B0(\arr[7][1] ), .B1(n544), 
        .C0(n537), .Y(n540) );
  AO22X1 U757 ( .A0(\arr[1][1] ), .A1(n542), .B0(\arr[0][1] ), .B1(n446), .Y(
        n538) );
  AOI221XL U758 ( .A0(\arr[2][1] ), .A1(n545), .B0(\arr[3][1] ), .B1(n544), 
        .C0(n538), .Y(n539) );
  AO22X1 U759 ( .A0(\arr[5][2] ), .A1(n542), .B0(\arr[4][2] ), .B1(n446), .Y(
        n541) );
  AOI221XL U760 ( .A0(\arr[6][2] ), .A1(n545), .B0(\arr[7][2] ), .B1(n544), 
        .C0(n541), .Y(n547) );
  AO22X1 U761 ( .A0(\arr[1][2] ), .A1(n542), .B0(\arr[0][2] ), .B1(n446), .Y(
        n543) );
  AOI221XL U762 ( .A0(\arr[2][2] ), .A1(n545), .B0(\arr[3][2] ), .B1(n544), 
        .C0(n543), .Y(n546) );
  NOR2X1 U763 ( .A(n566), .B(N100), .Y(n559) );
  NOR2X1 U764 ( .A(N99), .B(N100), .Y(n558) );
  AO22X1 U765 ( .A0(\arr[5][0] ), .A1(n559), .B0(\arr[4][0] ), .B1(n558), .Y(
        n549) );
  AOI221XL U766 ( .A0(\arr[6][0] ), .A1(n562), .B0(\arr[7][0] ), .B1(n561), 
        .C0(n549), .Y(n552) );
  AO22X1 U767 ( .A0(\arr[1][0] ), .A1(n559), .B0(\arr[0][0] ), .B1(n558), .Y(
        n550) );
  AOI221XL U768 ( .A0(\arr[2][0] ), .A1(n562), .B0(\arr[3][0] ), .B1(n561), 
        .C0(n550), .Y(n551) );
  AO22X1 U769 ( .A0(\arr[5][1] ), .A1(n559), .B0(\arr[4][1] ), .B1(n558), .Y(
        n553) );
  AOI221XL U770 ( .A0(\arr[6][1] ), .A1(n562), .B0(\arr[7][1] ), .B1(n561), 
        .C0(n553), .Y(n556) );
  AO22X1 U771 ( .A0(\arr[1][1] ), .A1(n559), .B0(\arr[0][1] ), .B1(n558), .Y(
        n554) );
  AOI221XL U772 ( .A0(\arr[2][1] ), .A1(n562), .B0(\arr[3][1] ), .B1(n561), 
        .C0(n554), .Y(n555) );
  AO22X1 U773 ( .A0(\arr[5][2] ), .A1(n559), .B0(\arr[4][2] ), .B1(n558), .Y(
        n557) );
  AOI221XL U774 ( .A0(\arr[6][2] ), .A1(n562), .B0(\arr[7][2] ), .B1(n561), 
        .C0(n557), .Y(n564) );
  AO22X1 U775 ( .A0(\arr[1][2] ), .A1(n559), .B0(\arr[0][2] ), .B1(n558), .Y(
        n560) );
  AOI221XL U776 ( .A0(\arr[2][2] ), .A1(n562), .B0(\arr[3][2] ), .B1(n561), 
        .C0(n560), .Y(n563) );
  NOR2X1 U777 ( .A(n583), .B(N111), .Y(n580) );
  NOR2X1 U778 ( .A(n583), .B(N96), .Y(n579) );
  NOR2X1 U779 ( .A(N96), .B(n703), .Y(n577) );
  NOR2X1 U780 ( .A(N111), .B(n703), .Y(n576) );
  AO22X1 U781 ( .A0(\arr[5][0] ), .A1(n577), .B0(\arr[4][0] ), .B1(n576), .Y(
        n567) );
  AOI221XL U782 ( .A0(\arr[6][0] ), .A1(n580), .B0(\arr[7][0] ), .B1(n579), 
        .C0(n567), .Y(n570) );
  AO22X1 U783 ( .A0(\arr[1][0] ), .A1(n577), .B0(\arr[0][0] ), .B1(n576), .Y(
        n568) );
  AOI221XL U784 ( .A0(\arr[2][0] ), .A1(n580), .B0(\arr[3][0] ), .B1(n579), 
        .C0(n568), .Y(n569) );
  OAI22XL U785 ( .A0(n584), .A1(n570), .B0(n504), .B1(n569), .Y(N145) );
  AO22X1 U786 ( .A0(\arr[5][1] ), .A1(n577), .B0(\arr[4][1] ), .B1(n576), .Y(
        n571) );
  AOI221XL U787 ( .A0(\arr[6][1] ), .A1(n580), .B0(\arr[7][1] ), .B1(n579), 
        .C0(n571), .Y(n574) );
  AO22X1 U788 ( .A0(\arr[1][1] ), .A1(n577), .B0(\arr[0][1] ), .B1(n576), .Y(
        n572) );
  AOI221XL U789 ( .A0(\arr[2][1] ), .A1(n580), .B0(\arr[3][1] ), .B1(n579), 
        .C0(n572), .Y(n573) );
  AO22X1 U790 ( .A0(\arr[5][2] ), .A1(n577), .B0(\arr[4][2] ), .B1(n576), .Y(
        n575) );
  AOI221XL U791 ( .A0(\arr[6][2] ), .A1(n580), .B0(\arr[7][2] ), .B1(n579), 
        .C0(n575), .Y(n582) );
  AO22X1 U792 ( .A0(\arr[1][2] ), .A1(n577), .B0(\arr[0][2] ), .B1(n576), .Y(
        n578) );
  AOI221XL U793 ( .A0(\arr[2][2] ), .A1(n580), .B0(\arr[3][2] ), .B1(n579), 
        .C0(n578), .Y(n581) );
  OAI22XL U794 ( .A0(n582), .A1(n584), .B0(n504), .B1(n581), .Y(N143) );
  NOR2X1 U795 ( .A(n601), .B(N93), .Y(n597) );
  NOR2X1 U796 ( .A(N93), .B(N109), .Y(n595) );
  NOR2X1 U797 ( .A(n531), .B(N109), .Y(n594) );
  AO22X1 U798 ( .A0(\arr[5][0] ), .A1(n595), .B0(\arr[4][0] ), .B1(n594), .Y(
        n585) );
  AOI221XL U799 ( .A0(\arr[6][0] ), .A1(n598), .B0(\arr[7][0] ), .B1(n597), 
        .C0(n585), .Y(n588) );
  AO22X1 U800 ( .A0(\arr[1][0] ), .A1(n595), .B0(\arr[0][0] ), .B1(n594), .Y(
        n586) );
  AOI221XL U801 ( .A0(\arr[2][0] ), .A1(n598), .B0(\arr[3][0] ), .B1(n597), 
        .C0(n586), .Y(n587) );
  OAI22XL U802 ( .A0(n602), .A1(n588), .B0(N110), .B1(n587), .Y(N303) );
  AO22X1 U803 ( .A0(\arr[5][1] ), .A1(n595), .B0(\arr[4][1] ), .B1(n594), .Y(
        n589) );
  AOI221XL U804 ( .A0(\arr[6][1] ), .A1(n598), .B0(\arr[7][1] ), .B1(n597), 
        .C0(n589), .Y(n592) );
  AO22X1 U805 ( .A0(\arr[1][1] ), .A1(n595), .B0(\arr[0][1] ), .B1(n594), .Y(
        n590) );
  AOI221XL U806 ( .A0(\arr[2][1] ), .A1(n598), .B0(\arr[3][1] ), .B1(n597), 
        .C0(n590), .Y(n591) );
  OAI22XL U807 ( .A0(n602), .A1(n592), .B0(N110), .B1(n591), .Y(N302) );
  AO22X1 U808 ( .A0(\arr[5][2] ), .A1(n595), .B0(\arr[4][2] ), .B1(n594), .Y(
        n593) );
  AOI221XL U809 ( .A0(\arr[6][2] ), .A1(n598), .B0(\arr[7][2] ), .B1(n597), 
        .C0(n593), .Y(n600) );
  AO22X1 U810 ( .A0(\arr[1][2] ), .A1(n595), .B0(\arr[0][2] ), .B1(n594), .Y(
        n596) );
  AOI221XL U811 ( .A0(\arr[2][2] ), .A1(n598), .B0(\arr[3][2] ), .B1(n597), 
        .C0(n596), .Y(n599) );
  OAI22XL U812 ( .A0(n600), .A1(n602), .B0(N110), .B1(n599), .Y(N301) );
  NOR2X1 U813 ( .A(n619), .B(n531), .Y(n616) );
  NOR2X1 U814 ( .A(n619), .B(n620), .Y(n615) );
  NOR2X1 U815 ( .A(n620), .B(N109), .Y(n613) );
  NOR2X1 U816 ( .A(n531), .B(N109), .Y(n612) );
  AO22X1 U817 ( .A0(\arr[5][0] ), .A1(n613), .B0(\arr[4][0] ), .B1(n612), .Y(
        n603) );
  AOI221XL U818 ( .A0(\arr[6][0] ), .A1(n616), .B0(\arr[7][0] ), .B1(n615), 
        .C0(n603), .Y(n606) );
  AO22X1 U819 ( .A0(\arr[1][0] ), .A1(n613), .B0(\arr[0][0] ), .B1(n612), .Y(
        n604) );
  AOI221XL U820 ( .A0(\arr[2][0] ), .A1(n616), .B0(\arr[3][0] ), .B1(n615), 
        .C0(n604), .Y(n605) );
  OAI22XL U821 ( .A0(n214), .A1(n606), .B0(N110), .B1(n605), .Y(N306) );
  AO22X1 U822 ( .A0(\arr[5][1] ), .A1(n613), .B0(\arr[4][1] ), .B1(n612), .Y(
        n607) );
  AOI221XL U823 ( .A0(\arr[6][1] ), .A1(n616), .B0(\arr[7][1] ), .B1(n615), 
        .C0(n607), .Y(n610) );
  AO22X1 U824 ( .A0(\arr[1][1] ), .A1(n613), .B0(\arr[0][1] ), .B1(n612), .Y(
        n608) );
  AOI221XL U825 ( .A0(\arr[2][1] ), .A1(n616), .B0(\arr[3][1] ), .B1(n615), 
        .C0(n608), .Y(n609) );
  OAI22XL U826 ( .A0(n214), .A1(n610), .B0(N110), .B1(n609), .Y(N305) );
  AO22X1 U827 ( .A0(\arr[5][2] ), .A1(n613), .B0(\arr[4][2] ), .B1(n612), .Y(
        n611) );
  AOI221XL U828 ( .A0(\arr[6][2] ), .A1(n616), .B0(\arr[7][2] ), .B1(n615), 
        .C0(n611), .Y(n618) );
  AO22X1 U829 ( .A0(\arr[1][2] ), .A1(n613), .B0(\arr[0][2] ), .B1(n612), .Y(
        n614) );
  AOI221XL U830 ( .A0(\arr[2][2] ), .A1(n616), .B0(\arr[3][2] ), .B1(n615), 
        .C0(n614), .Y(n617) );
  OAI22XL U831 ( .A0(n618), .A1(n602), .B0(N110), .B1(n617), .Y(N304) );
  NOR2X1 U832 ( .A(n583), .B(N111), .Y(n634) );
  NOR2X1 U833 ( .A(n583), .B(n637), .Y(n633) );
  NOR2X1 U834 ( .A(n637), .B(n703), .Y(n631) );
  NOR2X1 U835 ( .A(N111), .B(n703), .Y(n630) );
  AO22X1 U836 ( .A0(\arr[5][0] ), .A1(n631), .B0(\arr[4][0] ), .B1(n630), .Y(
        n621) );
  AOI221XL U837 ( .A0(\arr[6][0] ), .A1(n634), .B0(\arr[7][0] ), .B1(n633), 
        .C0(n621), .Y(n624) );
  AO22X1 U838 ( .A0(\arr[1][0] ), .A1(n631), .B0(\arr[0][0] ), .B1(n630), .Y(
        n622) );
  AOI221XL U839 ( .A0(\arr[2][0] ), .A1(n634), .B0(\arr[3][0] ), .B1(n633), 
        .C0(n622), .Y(n623) );
  OAI22XL U840 ( .A0(n584), .A1(n624), .B0(n504), .B1(n623), .Y(N501) );
  AO22X1 U841 ( .A0(\arr[5][1] ), .A1(n631), .B0(\arr[4][1] ), .B1(n630), .Y(
        n625) );
  AOI221XL U842 ( .A0(\arr[6][1] ), .A1(n634), .B0(\arr[7][1] ), .B1(n633), 
        .C0(n625), .Y(n628) );
  AO22X1 U843 ( .A0(\arr[1][1] ), .A1(n631), .B0(\arr[0][1] ), .B1(n630), .Y(
        n626) );
  AOI221XL U844 ( .A0(\arr[2][1] ), .A1(n634), .B0(\arr[3][1] ), .B1(n633), 
        .C0(n626), .Y(n627) );
  OAI22XL U845 ( .A0(n584), .A1(n628), .B0(n504), .B1(n627), .Y(N500) );
  AO22X1 U846 ( .A0(\arr[5][2] ), .A1(n631), .B0(\arr[4][2] ), .B1(n630), .Y(
        n629) );
  AOI221XL U847 ( .A0(\arr[6][2] ), .A1(n634), .B0(\arr[7][2] ), .B1(n633), 
        .C0(n629), .Y(n636) );
  AO22X1 U848 ( .A0(\arr[1][2] ), .A1(n631), .B0(\arr[0][2] ), .B1(n630), .Y(
        n632) );
  AOI221XL U849 ( .A0(\arr[2][2] ), .A1(n634), .B0(\arr[3][2] ), .B1(n633), 
        .C0(n632), .Y(n635) );
  OAI22XL U850 ( .A0(n636), .A1(n584), .B0(n504), .B1(n635), .Y(N499) );
  OAI22XL U851 ( .A0(Cost_sum[1]), .A1(n638), .B0(n638), .B1(n276), .Y(n640)
         );
  NAND2X1 U852 ( .A(Cost_sum[7]), .B(n282), .Y(n652) );
  NAND2X1 U853 ( .A(Cost_sum[6]), .B(n281), .Y(n647) );
  NOR3BXL U854 ( .AN(n647), .B(n641), .C(n648), .Y(n639) );
  NAND3X1 U855 ( .A(n640), .B(n652), .C(n639), .Y(n659) );
  NAND2X1 U856 ( .A(Cost_sum[9]), .B(n660), .Y(n655) );
  NOR2X1 U857 ( .A(n657), .B(n656), .Y(n646) );
  NOR2BX1 U858 ( .AN(n719), .B(Cost_sum[0]), .Y(n643) );
  OAI211X1 U859 ( .A0(n643), .A1(n317), .B0(n642), .C0(n654), .Y(n644) );
  OAI221XL U860 ( .A0(Cost_sum[2]), .A1(n277), .B0(Cost_sum[3]), .B1(n278), 
        .C0(n644), .Y(n645) );
  NAND2BX1 U861 ( .AN(n648), .B(n647), .Y(n649) );
  OAI222XL U862 ( .A0(n650), .A1(n649), .B0(Cost_sum[6]), .B1(n281), .C0(
        Cost_sum[7]), .C1(n282), .Y(n651) );
endmodule

