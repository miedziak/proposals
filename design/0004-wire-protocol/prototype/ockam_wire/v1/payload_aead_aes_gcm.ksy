
meta:
  id: payload_aead_aes_gcm
  imports:
    - ../variable_length_encoded_u2le

seq:
  - id: length
    type: variable_length_encoded_u2le
  - id: encrypted_data
    size: length.value - 16
  - id: authentication_tag
    size: 16
