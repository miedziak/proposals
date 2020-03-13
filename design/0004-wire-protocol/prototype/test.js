const OckamWire = require("./OckamWire");
const KaitaiStream = require('kaitai-struct/KaitaiStream');

const ping                         = new Uint8Array([1,0])
const pong                         = new Uint8Array([1,1])
const payload                      = new Uint8Array([1,2,2,100,100])
const ping_in_paylod               = new Uint8Array([1,2,2,1,0])
const payload_aead_aes_gcm         = new Uint8Array([1,3,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
const ping_in_payload_aead_aes_gcm = new Uint8Array([1,3,18,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

const key_agreement_t1_m1          = new Uint8Array([1,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
const key_agreement_t1_m2          = new Uint8Array([1,5,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
const key_agreement_t1_m3          = new Uint8Array([1,6,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

const message = new OckamWire(new KaitaiStream(key_agreement_t1_m3))
console.log(message)
