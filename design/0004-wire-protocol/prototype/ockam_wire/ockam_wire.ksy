
meta:
  id: ockam_wire
  title: Ockam Wire
  imports:
    - variable_length_encoded_u2le
    - v1/v1
    - v2/v2

seq:
  - id: version
    type: variable_length_encoded_u2le

  - id: without_version
    type:
      switch-on: version.value
      cases:
        1: v1
        2: v2
