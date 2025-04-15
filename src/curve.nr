use bignum::{BigNum, params::{BigNumParams, BigNumParamsGetter}};

global Secp224r1_Fq_PARAMS: BigNumParams<2, 224> = BigNumParams::new(
    true,
    [0xffffff000000000000000000000001, 0xffffffffffffffffffffffffff], 
    [0xffffffffffffffffffffffff0, 0x1000000000000000000000000000]
);

pub struct Secp224r1_Fq_Params {}

impl BigNumParamsGetter<2, 224> for Secp224r1_Fq_Params {
    fn get_params() -> BigNumParams<2, 224> {
        Secp224r1_Fq_PARAMS
    }
}

global a: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
    limbs: [0xfffffefffffffffffffffffffffffe, 0xffffffffffffffffffffffffff]
};

global b: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
    limbs: [0x44b0b7d7bfd8ba270b39432355ffb4, 0xb4050a850c04b3abf541325650]
};

pub fn curve_add(in1: [[Field; 2];2], in2: [[Field; 2];2]) -> [[Field; 2]; 2]{

    let x1: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
        limbs: {
            in1[0]
        },
    };

    let y1: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
        limbs: {
            in1[1]
        },
    };

    let x2: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
        limbs: {
            in2[0]
        },
    };

    let y2: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
        limbs: {
            in2[1]
        },
    };

    let lambda = x1
        .__add(x2.__neg())
        .__invmod()
        .__mul(
            y1.add(
                y2.__neg()
                )
            );

    // lambda = (y2 - y1) / (x2 - x1) =>
    // lambda * (x2 - x1) - y2 + y1 === 0
    BigNum::evaluate_quadratic_expression(
            [[lambda]],
            [[false]],
            [[x2, x1]],
            [[false, true]],
            [y2, y1],
            [true, false],
        );

    let x3 = lambda
        .__mul(lambda)
        .__add(
            x1.__neg()
        )
        .__add(
            x2.__neg()
        );
    
    let y3 = lambda
        .__mul(
            x1.__add(
                x3.__neg()
            )
        )
        .__add(
            y1.__neg()
        );

    BigNum::evaluate_quadratic_expression(
        [[lambda]],
        [[false]],
        [[lambda]],
        [[false]],
        [x3, x2, x1],
        [true, true, true],
    );

    BigNum::evaluate_quadratic_expression(
        [[lambda]],
        [[false]],
        [[x3, x1]],
        [[false, true]],
        [y3, y1],
        [false, false],
    );

    [x3.limbs, y3.limbs]
    
}

pub fn curve_double(in1: [[Field; 2];2]) -> [[Field; 2]; 2]{
    let x1: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
        limbs: {
            in1[0]
        },
    };

    let y1: BigNum<2, 224, Secp224r1_Fq_Params> = BigNum {
        limbs: {
            in1[1]
        },
    };

    let lambda = BigNum::one()
        .__add(
            BigNum::one().__add(BigNum::one())
        )
        .__mul(
            x1.__mul(x1)
        )
        .__add(a)
        .__mul(
            y1.__add(y1)
                .__invmod()
        );

    // -lambda * 2y + 3*x*x + a = 0
    BigNum::evaluate_quadratic_expression(
        [[x1, x1, x1], [y1, y1, BigNum::new()]],
        [[false, false, false], [false, false, false]],
        [[x1], [lambda]],
        [[false], [true]],
        [a],
        [false],
    );

    let x3 = lambda
        .__mul(lambda)
        .__add(
            x1.__add(x1).__neg()
        );
    
    let y3 = lambda
        .__mul(
            x1.__add(x3.__neg())
        )
        .__add(
            y1.__neg()
        );

    BigNum::evaluate_quadratic_expression(
        [[lambda]],
        [[false]],
        [[lambda]],
        [[false]],
        [x3, x1, x1],
        [true, true, true],
    );

    BigNum::evaluate_quadratic_expression(
        [[lambda]],
        [[false]],
        [[x3, x1]],
        [[false, true]],
        [y3, y1],
        [false, false],
    );

    [x3.limbs, y3.limbs]
}

#[test]
fn test_add(){
    curve_add([[0x3c1d356c21122343280d6115c1d21, 0xb70e0cbd6bb4bf7f321390b94a],[0x4375a05a07476444d5819985007e34, 0xbd376388b5f723fb4c22dfe6cd]], [[0x474788d16dc18032d268fd1a704fa6, 0x706a46dc76dcb76798e60e6d89],[0x892849fca629487acf3709d2e4e8bb, 0x1c2b76a7bc25e7702a704fa986]]);
}

#[test]
fn test_double(){
    curve_double([[0x3c1d356c21122343280d6115c1d21, 0xb70e0cbd6bb4bf7f321390b94a],[0x4375a05a07476444d5819985007e34, 0xbd376388b5f723fb4c22dfe6cd]]);
}

