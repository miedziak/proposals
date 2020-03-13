
meta:
  id: variable_length_encoded_u2le
  title: Variable length unsigned integer, base16, little-endian

seq:
  - id: byte1
    type: u1
  - id: byte2
    type: u1
    if: (byte1 & 0b1000_0000) != 0
instances:
  value:
    value: >-
      (byte1 & 0b0111_1111) +
      ((byte1 & 0b1000_0000) != 0 ? ((byte2 & 0b0111_1111) << 7) : 0)

# https://github.com/stoklund/varint
# https://github.com/WebAssembly/design/issues/601
# https://github.com/WebAssembly/design/issues/601#issuecomment-196045891
# http://formats.kaitai.io/vlq_base128_le/index.html
# https://en.wikipedia.org/wiki/LEB128
# https://developers.google.com/protocol-buffers/docs/encoding#varints
