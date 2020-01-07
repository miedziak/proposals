package curve25519

import (
	"errors"
	"io"

	"golang.org/x/crypto/curve25519"
)

type PublicKey []byte

func (k PublicKey) Marshal() []byte {
	var public []byte
	copy(public, k)
	return public
}

func UnmarshallPublicKey(marshalled []byte) (PublicKey, error) {
	return marshalled, nil
}

type KeyPair struct {
	PublicKey
	PrivateKey []byte // private key
}

func (me KeyPair) ComputeSharedSecret(other PublicKey) []byte {
	var sharedSecret, privateKey, publicKey [32]byte
	copy(privateKey[:], me.PrivateKey)
	copy(publicKey[:], other)
	curve25519.ScalarMult(&sharedSecret, &privateKey, &publicKey)
	return sharedSecret[:]
}

func GenerateKeyPair(rand io.Reader) (*KeyPair, error) {
	if rand == nil {
		errors.New("random reader is nil")
	}

	var private [32]byte
	_, err := io.ReadFull(rand, private[:])
	if err != nil {
		return nil, nil
	}

	// https://cr.yp.to/ecdh.html
	private[0]  &= 248
	private[31] &= 127
	private[31] |= 64

	// What do we need to do make the key compatable with edwards25519?
	// https://tools.ietf.org/html/rfc8032
	// https://golang.org/src/crypto/ed25519/ed25519.go?s=2707:2770#L67

	var public [32]byte
	curve25519.ScalarBaseMult(&public, &private)

	return &KeyPair{PrivateKey: private[:], PublicKey: public[:]}, nil
}
