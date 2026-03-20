module ks_16bit(
input [15:0] A, B, //adders dont need unsigned signed distiction
output [15:0] S,
output Cout
); 
    wire P00, G00, P10, G10, P20, G20, P30, G30, P40, G40, P50, G50, P60, G60, P70, G70;
    wire P80, G80, P90, G90, P100, G100, P110, G110, P120, G120, P130, G130, P140, G140, P150, G150;
    wire G11, P21, G21, P31, G31, P41, G41, P51, G51, P61, G61, P71, G71, P81, G81, P91, G91;
    wire P101, G101, P111, G111, P121, G121, P131, G131, P141, G141, P151, G151;
    wire G22, G32, P42, G42, P52, G52, P62, G62, P72, G72, P82, G82, P92, G92;
    wire P102, G102, P112, G112, P122, G122, P132, G132, P142, G142, P152, G152;
    wire G43, G53, G63, G73, P83, G83, P93, G93, P103, G103, P113, G113, P123, G123, P133, G133, P143, G143, P153, G153;
    wire G84, G94, G104, G114, G124, G134, G144, G154;

    // Step 0; Radix = 2; Pre-processing
    assign P00 = A[0] ^ B[0]; assign G00 = A[0] & B[0];
    assign P10 = A[1] ^ B[1]; assign G10 = A[1] & B[1];
    assign P20 = A[2] ^ B[2]; assign G20 = A[2] & B[2];
    assign P30 = A[3] ^ B[3]; assign G30 = A[3] & B[3];
    assign P40 = A[4] ^ B[4]; assign G40 = A[4] & B[4];
    assign P50 = A[5] ^ B[5]; assign G50 = A[5] & B[5];
    assign P60 = A[6] ^ B[6]; assign G60 = A[6] & B[6];
    assign P70 = A[7] ^ B[7]; assign G70 = A[7] & B[7];
    assign P80 = A[8] ^ B[8]; assign G80 = A[8] & B[8];
    assign P90 = A[9] ^ B[9]; assign G90 = A[9] & B[9];
    assign P100 = A[10] ^ B[10]; assign G100 = A[10] & B[10];
    assign P110 = A[11] ^ B[11]; assign G110 = A[11] & B[11];
    assign P120 = A[12] ^ B[12]; assign G120 = A[12] & B[12];
    assign P130 = A[13] ^ B[13]; assign G130 = A[13] & B[13];
    assign P140 = A[14] ^ B[14]; assign G140 = A[14] & B[14];
    assign P150 = A[15] ^ B[15]; assign G150 = A[15] & B[15];

   // Step1; Distance=Radix^(Step-1)=2^0=1
    assign G11 = G10 | (P10 & G00);
    assign P21 = P20 & P10; assign G21 = G20 | (P20 & G10);
    assign P31 = P30 & P20; assign G31 = G30 | (P30 & G20);
    assign P41 = P40 & P30; assign G41 = G40 | (P40 & G30);
    assign P51 = P50 & P40; assign G51 = G50 | (P50 & G40);
    assign P61 = P60 & P50; assign G61 = G60 | (P60 & G50);
    assign P71 = P70 & P60; assign G71 = G70 | (P70 & G60);
    assign P81 = P80 & P70; assign G81 = G80 | (P80 & G70);
    assign P91 = P90 & P80; assign G91 = G90 | (P90 & G80);
    assign P101 = P100 & P90; assign G101 = G100 | (P100 & G90);
    assign P111 = P110 & P100; assign G111 = G110 | (P110 & G100);
    assign P121 = P120 & P110; assign G121 = G120 | (P120 & G110);
    assign P131 = P130 & P120; assign G131 = G130 | (P130 & G120);
    assign P141 = P140 & P130; assign G141 = G140 | (P140 & G130);
    assign P151 = P150 & P140; assign G151 = G150 | (P150 & G140);

    // Step=2; Distance=Radix^(Step-1)=2^1=2
    assign G22 = G21 | (P21 & G00);
    assign G32 = G31 | (P31 & G11);
    assign P42 = P41 & P21; assign G42 = G41 | (P41 & G21);
    assign P52 = P51 & P31; assign G52 = G51 | (P51 & G31);
    assign P62 = P61 & P41; assign G62 = G61 | (P61 & G41);
    assign P72 = P71 & P51; assign G72 = G71 | (P71 & G51);
    assign P82 = P81 & P61; assign G82 = G81 | (P81 & G61);
    assign P92 = P91 & P71; assign G92 = G91 | (P91 & G71);
    assign P102 = P101 & P81; assign G102 = G101 | (P101 & G81);
    assign P112 = P111 & P91; assign G112 = G111 | (P111 & G91);
    assign P122 = P121 & P101; assign G122 = G121 | (P121 & G101);
    assign P132 = P131 & P111; assign G132 = G131 | (P131 & G111);
    assign P142 = P141 & P121; assign G142 = G141 | (P141 & G121);
    assign P152 = P151 & P131; assign G152 = G151 | (P151 & G131);

    // Step=3; Distance=Radix^(Step-1)=2^2=4
    assign G43 = G42 | (P42 & G00);
    assign G53 = G52 | (P52 & G11);
    assign G63 = G62 | (P62 & G22);
    assign G73 = G72 | (P72 & G32);
    assign P83 = P82 & P42; assign G83 = G82 | (P82 & G42);
    assign P93 = P92 & P52; assign G93 = G92 | (P92 & G52);
    assign P103 = P102 & P62; assign G103 = G102 | (P102 & G62);
    assign P113 = P112 & P72; assign G113 = G112 | (P112 & G72);
    assign P123 = P122 & P82; assign G123 = G122 | (P122 & G82);
    assign P133 = P132 & P92; assign G133 = G132 | (P132 & G92);
    assign P143 = P142 & P102; assign G143 = G142 | (P142 & G102);
    assign P153 = P152 & P112; assign G153 = G152 | (P152 & G112);

    // Step=4 Distance=Radix^(Step-1)=2^3=8
    assign G84 = G83 | (P83 & G00);
    assign G94 = G93 | (P93 & G11);
    assign G104 = G103 | (P103 & G22);
    assign G114 = G113 | (P113 & G32);
    assign G124 = G123 | (P123 & G43);
    assign G134 = G133 | (P133 & G53);
    assign G144 = G143 | (P143 & G63);
    assign G154 = G153 | (P153 & G73);

    // Sum
    assign S[0]  = P00;
    assign S[1]  = P10  ^ G00;
    assign S[2]  = P20  ^ G11;
    assign S[3]  = P30  ^ G22;
    assign S[4]  = P40  ^ G32;
    assign S[5]  = P50  ^ G43;
    assign S[6]  = P60  ^ G53;
    assign S[7]  = P70  ^ G63;
    assign S[8]  = P80  ^ G73;
    assign S[9]  = P90  ^ G84;
    assign S[10] = P100 ^ G94;
    assign S[11] = P110 ^ G104;
    assign S[12] = P120 ^ G114;
    assign S[13] = P130 ^ G124;
    assign S[14] = P140 ^ G134;
    assign S[15] = P150 ^ G144;

    assign Cout = G154;

endmodule