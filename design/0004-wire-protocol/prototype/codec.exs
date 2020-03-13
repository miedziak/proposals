
defmodule Ockam.Message.Ping, do: defstruct []
defmodule Ockam.Message.Pong, do: defstruct []
defmodule Ockam.Message.Payload, do: defstruct [:data]
defmodule Ockam.Message.Payload.AuthenticatedEncrypted, do: defstruct [:encrypted_data, :authentication_tag]
defmodule Ockam.Message.KeyAgreement.T1.M1, do: defstruct [:data]
defmodule Ockam.Message.KeyAgreement.T1.M2, do: defstruct [:data]
defmodule Ockam.Message.KeyAgreement.T1.M3, do: defstruct [:data]

defmodule Ockam.Wire do
  use Bitwise

  def decode_varint_u2le(<<0::1, b1::unsigned-integer-7, rest::binary>>), do: {b1, rest}
  def decode_varint_u2le(<<1::1, b1::unsigned-integer-7, _::1, b2::unsigned-integer-7, rest::binary>>) do
    {b1 + (b2 <<< 7), rest}
  end

  def decode_message(message) do
    {version, rest} = decode_varint_u2le(message)
    case version do
      1 -> Ockam.Wire.V1.decode_message(rest)
    end
  end
end

defmodule Ockam.Wire.V1 do

  def decode_length_prefixed(message_and_rest) do
    {length, data_and_rest} = Ockam.Wire.decode_varint_u2le(message_and_rest)
    <<data::binary-size(length), rest::binary>> = data_and_rest
    {length, data, rest}
  end

  def decode_message(<<0, rest::binary>>), do: {%Ockam.Message.Ping{}, rest}

  def decode_message(<<1, rest::binary>>), do: {%Ockam.Message.Pong{}, rest}

  def decode_message(<<2, message_and_rest::binary>>) do
    {_, data, rest} = decode_length_prefixed(message_and_rest)
    {%Ockam.Message.Payload{data: data}, rest}
  end

  def decode_message(<<3, message_and_rest::binary>>) do
    {length, encrypted_data_and_tag, rest} = decode_length_prefixed(message_and_rest)
    data_length = length - 16
    <<data::binary-size(data_length), tag::binary-size(16)>> = encrypted_data_and_tag
    {%Ockam.Message.Payload.AuthenticatedEncrypted{encrypted_data: data, authentication_tag: tag}, rest}
  end

  def decode_message(<<4, message_and_rest::binary>>) do
    {_, data, rest} = decode_length_prefixed(message_and_rest)
    {%Ockam.Message.KeyAgreement.T1.M1{data: data}, rest}
  end

  def decode_message(<<5, message_and_rest::binary>>) do
    {_, data, rest} = decode_length_prefixed(message_and_rest)
    {%Ockam.Message.KeyAgreement.T1.M1{data: data}, rest}
  end

  def decode_message(<<6, message_and_rest::binary>>) do
    {_, data, rest} = decode_length_prefixed(message_and_rest)
    {%Ockam.Message.KeyAgreement.T1.M1{data: data}, rest}
  end

end

# test cases
IO.inspect Ockam.Wire.decode_message(<<1, 0>>) # ping
IO.inspect Ockam.Wire.decode_message(<<1, 1>>) # pong
IO.inspect Ockam.Wire.decode_message(<<1, 2, 2, 100, 100>>) # payload
IO.inspect Ockam.Wire.decode_message(<<1, 3, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>) # payload_aead_aes_gcm
