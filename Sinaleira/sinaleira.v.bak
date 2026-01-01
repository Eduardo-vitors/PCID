module sinaleira (A, B, C, D, NS, LO);
    input  A, B, C, D;
    output NS;
    output LO;

    assign NS = (A | B) & (~C) & (~D);
    assign LO = ~NS;

endmodule
