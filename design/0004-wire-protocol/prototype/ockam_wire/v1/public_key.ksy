
meta:
  id: public_key

seq:
  - id: type
    type: u1

  - id: value
    type:
      switch-on: type
      cases:
        1: curve_25519
        2: curve_p256_compressed_y0
        3: curve_p256_compressed_y1
        4: curve_p256_uncompressed

types:
  curve_25519:
    seq:
      - id: x
        size: 32

  curve_p256_compressed_y0:
    seq:
      - id: x
        size: 32

  curve_p256_compressed_y1:
    seq:
      - id: x
        size: 32

  curve_p256_uncompressed:
    seq:
      - id: x
        size: 32
      - id: y
        size: 32

# 2.3.4 Octet-String-to-Elliptic-Curve-Point Conversion
# http://www.secg.org/sec1-v2.pdf
