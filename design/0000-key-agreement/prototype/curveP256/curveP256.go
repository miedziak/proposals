package curveP256

import (
	"crypto/elliptic"
	"errors"
	"io"
	"math/big"
)

type PublicKey struct {
	X, Y *big.Int
}

func (k PublicKey) Marshal() []byte {
	return elliptic.Marshal(elliptic.P256(), k.X, k.Y)
}

func UnmarshallPublicKey(marshalled []byte) (PublicKey, error) {
	x, y := elliptic.Unmarshal(elliptic.P256(), marshalled)
	return PublicKey{X: x, Y: y}, nil
}

type KeyPair struct {
	PublicKey
	PrivateKey []byte // private key
}

func (me KeyPair) ComputeSharedSecret(other PublicKey) []byte {
	sx, _ := elliptic.P256().ScalarMult(other.X, other.Y, me.PrivateKey)
	return sx.Bytes()
}

func GenerateKeyPair(rand io.Reader) (*KeyPair, error) {
	if rand == nil {
		errors.New("random reader is nil")
	}

	private, x, y, err := elliptic.GenerateKey(elliptic.P256(), rand)
	if err != nil {
		return nil, err
	}

	// Jivsov, Andrey. "Compact representation of an elliptic curve point." (2014).
	// https://tools.ietf.org/html/draft-jivsov-ecc-compact-05

	return &KeyPair{PrivateKey: private, PublicKey: PublicKey{X: x, Y: y}}, nil
}
