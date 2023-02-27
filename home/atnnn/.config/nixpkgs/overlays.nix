[
  (import <rust-overlay>)
  (self: super: {
     # 2022-08-21 binaryen build fails
    binaryen = super.binaryen.overrideAttrs (_: {
      doCheck = false;
    });
  })
]
