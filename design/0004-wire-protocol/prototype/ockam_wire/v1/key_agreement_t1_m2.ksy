
meta:
  id: key_agreement_t1_m2
  imports:
    - ../variable_length_encoded_u2le

seq:
  - id: length
    type: variable_length_encoded_u2le
  - id: data
    size: length.value
