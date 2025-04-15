use curve::{curve_two_mult, get_val_from_table, curve_add, curve_double, curve_mult};

pub mod curve;

fn main(
    in1: [[Field; 2]; 2],  in2: [[Field; 2]; 2], scalars: [Field; 2]
    ) -> pub [[Field; 2]; 2]{
    // curve_add([[0x3c1d356c21122343280d6115c1d21, 0xb70e0cbd6bb4bf7f321390b94a],[0x4375a05a07476444d5819985007e34, 0xbd376388b5f723fb4c22dfe6cd]], [[0x474788d16dc18032d268fd1a704fa6, 0x706a46dc76dcb76798e60e6d89],[0x892849fca629487acf3709d2e4e8bb, 0x1c2b76a7bc25e7702a704fa986]])
    // curve_mult(in1, scalar)

    // get_val_from_table([[
    //     [[0; 2]; 2], [[1; 2]; 2], [[2; 2]; 2], [[3; 2]; 2],
    //     ], [
    //     [[4; 2]; 2], [[5; 2]; 2], [[6; 2]; 2], [[7; 2]; 2],
    //     ], [
    //     [[8; 2]; 2], [[9; 2]; 2], [[10; 2]; 2], [[11; 2]; 2],
    //     ], [
    //     [[12; 2]; 2], [[13; 2]; 2], [[14; 2]; 2], [[15; 2]; 2],
    //     ]], x, y)

    curve_two_mult(in1, in2, scalars)
}
